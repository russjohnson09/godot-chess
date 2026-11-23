extends Node2D

@onready var status_label: Label = $StatusLabel
@onready var peers_list: ItemList = $PeersList
@onready var ip_input: LineEdit = $IpInput
@onready var connect_btn: Button = $ConnectButton
@onready var msg_input: LineEdit = $MessageInput
@onready var send_btn: Button = $SendButton
@onready var chat_log: TextEdit = $ChatLog

var udp_server := UDPServer.new()
var udp_peer := PacketPeerUDP.new()
var broadcast_timer := Timer.new()
var active_peers := {} # ip -> timestamp

var tcp_server := TCPServer.new()
var connected_clients := [] # StreamPeerTCP
var client_connection := StreamPeerTCP.new()
var is_client_connected := false

const PORT = 8910
const BROADCAST_INTERVAL = 2.0

func _ready() -> void:
	if udp_server.listen(PORT) != OK:
		status_label.text = "Error listening on UDP port %d" % PORT
	else:
		status_label.text = "Scanning local WiFi..."
		
	if tcp_server.listen(PORT) != OK:
		log_message("Error listening on TCP port %d" % PORT)
	else:
		log_message("TCP Server listening on port %d" % PORT)
		
	broadcast_timer.wait_time = BROADCAST_INTERVAL
	broadcast_timer.autostart = true
	broadcast_timer.timeout.connect(_on_broadcast_timeout)
	add_child(broadcast_timer)
	
	udp_peer.set_broadcast_enabled(true)
	udp_peer.set_dest_address("255.255.255.255", PORT)
	
	connect_btn.pressed.connect(_on_connect_pressed)
	send_btn.pressed.connect(_on_send_pressed)
	peers_list.item_selected.connect(_on_peer_selected)

func _process(delta: float) -> void:
	# UDP Discovery handling
	udp_server.poll()
	while udp_server.is_connection_available():
		var conn := udp_server.take_connection()
		var pkt := conn.get_packet()
		var ip := conn.get_packet_ip()
		if not _is_local_ip(ip):
			active_peers[ip] = Time.get_ticks_msec()
		
	var current_time = Time.get_ticks_msec()
	var stale_ips = []
	for ip in active_peers:
		if current_time - active_peers[ip] > 6000:
			stale_ips.append(ip)
	for ip in stale_ips:
		active_peers.erase(ip)
		
	peers_list.clear()
	for ip in active_peers:
		peers_list.add_item(ip)
		
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
	var packet = "GODOT_CHESS_PEER".to_ascii_buffer()
	udp_peer.put_packet(packet)

func _is_local_ip(ip: String) -> bool:
	var local_ips = IP.get_local_addresses()
	return ip in local_ips or ip == "127.0.0.1" or ip == "::1"

func _on_peer_selected(index: int) -> void:
	var ip = peers_list.get_item_text(index)
	ip_input.text = ip

func _on_connect_pressed() -> void:
	var target_ip = ip_input.text.strip_edges()
	if target_ip == "":
		return
	log_message("Connecting to " + target_ip + "...")
	client_connection.disconnect_from_host()
	var err = client_connection.connect_to_host(target_ip, PORT)
	if err != OK:
		log_message("Failed to connect.")
		is_client_connected = false
	else:
		is_client_connected = true

func _on_send_pressed() -> void:
	var msg = msg_input.text
	if msg == "":
		return
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
		msg_input.text = ""
	else:
		log_message("No active connection to send message.")

func log_message(text: String) -> void:
	chat_log.text += text + "\n"
