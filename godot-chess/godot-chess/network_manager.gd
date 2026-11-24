extends Node

var udp_server := PacketPeerUDP.new()
var udp_peer := PacketPeerUDP.new()
var broadcast_timer := Timer.new()
var active_peers := {} # ip -> timestamp

var tcp_server := TCPServer.new()
var connected_clients := [] # StreamPeerTCP
var client_connection := StreamPeerTCP.new()
var is_client_connected := false

const PORT_UDP = 8910
const PORT_TCP = 8911
const BROADCAST_INTERVAL = 2.0

var chat_messages := [] # Array of Strings

var actual_port_tcp = PORT_TCP

func _ready() -> void:
	# Check and request missing Android permissions
	if OS.has_feature("android"):
		var required_perms = [
			"android.permission.INTERNET",
			"android.permission.ACCESS_NETWORK_STATE",
			"android.permission.ACCESS_WIFI_STATE",
			"android.permission.CHANGE_WIFI_STATE",
			"android.permission.CHANGE_WIFI_MULTICAST_STATE",
			"android.permission.ACCESS_COARSE_LOCATION",
			"android.permission.ACCESS_FINE_LOCATION"
		]
		for perm in required_perms:
			OS.request_permission(perm)

	if udp_server.bind(PORT_UDP) != OK:
		print("NetworkManager: Error binding UDP port %d" % PORT_UDP)
	else:
		print("NetworkManager: Bound UDP port %d" % PORT_UDP)
		
	var tcp_err = tcp_server.listen(PORT_TCP)
	if tcp_err != OK:
		print("NetworkManager: TCP port %d in use, trying %d..." % [PORT_TCP, PORT_TCP + 1])
		actual_port_tcp = PORT_TCP + 1
		tcp_err = tcp_server.listen(actual_port_tcp)
		if tcp_err != OK:
			print("NetworkManager: Error listening on TCP port %d (Code: %d)" % [actual_port_tcp, tcp_err])
		else:
			print("NetworkManager: TCP Server listening on port %d" % actual_port_tcp)
	else:
		print("NetworkManager: TCP Server listening on port %d" % actual_port_tcp)
		
	broadcast_timer.wait_time = BROADCAST_INTERVAL
	broadcast_timer.autostart = true
	broadcast_timer.timeout.connect(_on_broadcast_timeout)
	add_child(broadcast_timer)
	
	udp_peer.set_broadcast_enabled(true)
	udp_peer.set_dest_address("255.255.255.255", PORT_UDP)

func _process(delta: float) -> void:
	# UDP Discovery handling
	while udp_server.get_available_packet_count() > 0:
		var pkt = udp_server.get_packet()
		var ip = udp_server.get_packet_ip()
		var pkt_str = pkt.get_string_from_utf8()
		var peer_port = PORT_TCP
		if pkt_str.begins_with("GODOT_CHESS_PEER"):
			var parts = pkt_str.split(":")
			if parts.size() == 2:
				peer_port = parts[1].to_int()
		if not _is_local_ip(ip):
			active_peers[ip] = { "timestamp": Time.get_ticks_msec(), "port": peer_port }
			udp_peer.put_packet(("GODOT_CHESS_PEER:%d" % actual_port_tcp).to_ascii_buffer())
		
	var current_time = Time.get_ticks_msec()
	var stale_ips = []
	for ip in active_peers:
		if current_time - active_peers[ip]["timestamp"] > 6000:
			stale_ips.append(ip)
	for ip in stale_ips:
		active_peers.erase(ip)
		
	# TCP Incoming connections handling
	if tcp_server.is_connection_available():
		var new_client = tcp_server.take_connection()
		connected_clients.append(new_client)
		log_message("Accepted connection from: " + new_client.get_connected_host())
		
	# Poll existing incoming TCP clients
	for i in range(connected_clients.size() - 1, -1, -1):
		var client = connected_clients[i]
		client.poll()
		var status = client.get_status()
		if status == StreamPeerTCP.STATUS_CONNECTED:
			var avail = client.get_available_bytes()
			if avail > 0:
				var data = client.get_data(avail)
				if data[0] == OK:
					var msg = data[1].get_string_from_utf8()
					log_message("[" + client.get_connected_host() + "]: " + msg)
		elif status != StreamPeerTCP.STATUS_CONNECTING:
			connected_clients.remove_at(i)
			
	# Poll outgoing TCP client connection
	if is_client_connected:
		client_connection.poll()
		var c_status = client_connection.get_status()
		if c_status == StreamPeerTCP.STATUS_CONNECTED:
			var avail = client_connection.get_available_bytes()
			if avail > 0:
				var data = client_connection.get_data(avail)
				if data[0] == OK:
					var msg = data[1].get_string_from_utf8()
					log_message("[" + client_connection.get_connected_host() + "]: " + msg)
		elif c_status != StreamPeerTCP.STATUS_CONNECTING:
			is_client_connected = false
			log_message("Disconnected from server.")

func _on_broadcast_timeout() -> void:
	var packet = ("GODOT_CHESS_PEER:%d" % actual_port_tcp).to_ascii_buffer()
	udp_peer.put_packet(packet)

func _is_local_ip(ip: String) -> bool:
	var local_ips = IP.get_local_addresses()
	return ip in local_ips or ip == "127.0.0.1" or ip == "::1"

func send_message(msg: String) -> bool:
	var data = msg.to_utf8_buffer()
	var sent = false
	
	if is_client_connected and client_connection.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		client_connection.put_data(data)
		sent = true
		
	for client in connected_clients:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			client.put_data(data)
			sent = true
			
	if sent:
		log_message("[Me]: " + msg)
	return sent

func connect_to_peer(target_ip: String, port: int) -> void:
	log_message("Connecting to " + target_ip + ":" + str(port) + "...")
	client_connection.disconnect_from_host()
	var err = client_connection.connect_to_host(target_ip, port)
	if err != OK:
		log_message("Failed to connect.")
		is_client_connected = false
	else:
		is_client_connected = true

func log_message(text: String) -> void:
	chat_messages.append(text)
	if chat_messages.size() > 100:
		chat_messages.pop_front()
	# Notify current scene if it has a listener
	var current_scene = Engine.get_main_loop().current_scene
	if current_scene and current_scene.has_method("on_network_log"):
		current_scene.on_network_log(text)
	if text.begins_with("TTT_MOVE:") and current_scene and current_scene.has_method("on_network_message"):
		current_scene.on_network_message(text)
