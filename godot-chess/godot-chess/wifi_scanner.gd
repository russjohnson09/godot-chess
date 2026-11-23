extends Node2D

@onready var status_label: Label = $StatusLabel
@onready var peers_list: ItemList = $PeersList

var udp_server := UDPServer.new()
var udp_peer := PacketPeerUDP.new()
var broadcast_timer := Timer.new()
var active_peers := {} # ip -> timestamp

const PORT = 8910
const BROADCAST_INTERVAL = 2.0

func _ready() -> void:
	# Listen for peer broadcasts
	if udp_server.listen(PORT) != OK:
		status_label.text = "Error listening on port %d" % PORT
	else:
		status_label.text = "Scanning local WiFi..."
		
	# Setup periodic broadcasting
	broadcast_timer.wait_time = BROADCAST_INTERVAL
	broadcast_timer.autostart = true
	broadcast_timer.timeout.connect(_on_broadcast_timeout)
	add_child(broadcast_timer)
	
	udp_peer.set_broadcast_enabled(true)
	udp_peer.set_dest_address("255.255.255.255", PORT)

func _process(delta: float) -> void:
	# Poll server for incoming packets
	udp_server.poll()
	while udp_server.is_connection_available():
		var conn := udp_server.take_connection()
		var pkt := conn.get_packet()
		var ip := conn.get_packet_ip()
		active_peers[ip] = Time.get_ticks_msec()
		
	# Cleanup stale peers (> 6 seconds old)
	var current_time = Time.get_ticks_msec()
	var stale_ips = []
	for ip in active_peers:
		if current_time - active_peers[ip] > 6000:
			stale_ips.append(ip)
	for ip in stale_ips:
		active_peers.erase(ip)
		
	# Update UI list
	peers_list.clear()
	for ip in active_peers:
		peers_list.add_item("Godot Instance at: " + ip)

func _on_broadcast_timeout() -> void:
	var packet = "GODOT_CHESS_PEER".to_ascii_buffer()
	udp_peer.put_packet(packet)
