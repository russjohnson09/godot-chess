extends Node

var udp_server := PacketPeerUDP.new()
var udp_peer := PacketPeerUDP.new()
var broadcast_timer := Timer.new()
var active_peers := {} # ip -> timestamp

# 192.168.1.11
#Ethernet adapter vEthernet (WSL (Hyper-V firewall)):

#   Connection-specific DNS Suffix  . :
#   Link-local IPv6 Address . . . . . : fe80::a0f5:7bc4:4f44:8c8e%31
#   IPv4 Address. . . . . . . . . . . : 172.19.80.1
var tcp_server := TCPServer.new()
var connected_clients := [] # StreamPeerTCP
var client_connection := StreamPeerTCP.new()
var is_client_connected := false

const PORT_UDP = 9910
const PORT_TCP = 8911
const BROADCAST_INTERVAL = 2.0

var chat_messages := [] # Array of Strings

var actual_port_udp = PORT_UDP
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
	
	var udp_success = false
	while not udp_success and actual_port_udp < 9915:
		udp_success = udp_server.bind(actual_port_udp) == OK
		if not udp_success:
			actual_port_udp += 1
		
	if not udp_success:
		print("NetworkManager: failed to find open udp port for udp server")
		actual_port_udp += 1
		
	var tcp_success = false
	var test_port = PORT_TCP
	while not tcp_success and test_port < PORT_TCP + 100:
		var tcp_err = tcp_server.listen(test_port, "0.0.0.0")
		if tcp_err == OK:
			actual_port_tcp = test_port
			tcp_success = true
			print("NetworkManager: TCP Server listening on first available port %d" % actual_port_tcp)
		else:
			test_port += 1
	if not tcp_success:
		print("NetworkManager: Error - No available TCP ports found!")
		
	broadcast_timer.wait_time = BROADCAST_INTERVAL
	broadcast_timer.autostart = true
	broadcast_timer.timeout.connect(_on_broadcast_timeout)
	add_child(broadcast_timer)
	
	# not sure if this is required
	udp_peer.set_broadcast_enabled(true)
	#udp_peer.set_dest_address("255.255.255.255", actual_port_udp)

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
		
		if not _is_local_ip(ip, peer_port):
			var peer_key = "%s:%d" % [ip, peer_port]
			active_peers[peer_key] = { "timestamp": Time.get_ticks_msec(), "ip": ip, "port": peer_port }
			udp_peer.put_packet(("GODOT_CHESS_PEER:%d" % actual_port_tcp).to_ascii_buffer())
		
	var current_time = Time.get_ticks_msec()
	var stale_keys = []
	for key in active_peers:
		if current_time - active_peers[key]["timestamp"] > 6000:
			stale_keys.append(key)
	for key in stale_keys:
		active_peers.erase(key)
		
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
					handle_incoming_message("[" + client.get_connected_host() + "]: " + msg)
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
					handle_incoming_message("[" + client_connection.get_connected_host() + "]: " + msg)
		elif c_status != StreamPeerTCP.STATUS_CONNECTING:
			is_client_connected = false
			log_message("Disconnected from server.")

func _udp_send(packet_str: String):
	for port in [9910, 9911, 9912, 9913, 9914, 9915]:
		udp_peer.set_dest_address("255.255.255.255", port)
		udp_peer.put_packet(packet_str.to_ascii_buffer())


func _on_broadcast_timeout() -> void:
	
	_udp_send("GODOT_CHESS_PEER:%d" % actual_port_tcp)
	# TODO simplify this.
	# UDP server	A program listening on a UDP port for incoming datagrams
	# Peer	A remote sender identified by its IP address and port

	# I should really only be using this for discoverability.
	# Once a host is established it can handle one or more clients and all communication going forward is via tcp.
	#var packet = ("GODOT_CHESS_PEER:%d" % actual_port_tcp).to_ascii_buffer()
	#udp_peer.set_dest_address("255.255.255.255", PORT_UDP)
	#udp_peer.put_packet(packet)
	#if actual_port_udp != PORT_UDP:
		#udp_peer.set_dest_address("255.255.255.255", actual_port_udp)
		#udp_peer.put_packet(packet)
	#udp_peer.set_dest_address("255.255.255.255", 9910)
	#udp_peer.put_packet(packet)

func _is_local_ip(ip: String, peer_port: int) -> bool:
	var local_ips = IP.get_local_addresses()
	#local_ips = []
	var is_local_addr = ip in local_ips or ip == "127.0.0.1" or ip == "::1" or ip.begins_with("172.19.")
	if not is_local_addr:
		return false
	#return is_local_addr
	# Only exclude if it is an exact match on our TCP IP and port
	return peer_port == actual_port_tcp

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
	pass
	#chat_messages.append(text)
	#if chat_messages.size() > 100:
		#chat_messages.pop_front()
	#var current_scene = Engine.get_main_loop().current_scene
	#if current_scene and current_scene.has_method("on_network_log"):
		#current_scene.on_network_log(text)

func handle_incoming_message(msg: String) -> void:
	log_message(msg)
	var current_scene = Engine.get_main_loop().current_scene
	# Can't this be handled as a signal instead?
	if current_scene and current_scene.has_method("on_network_message"):
		current_scene.on_network_message(msg)
