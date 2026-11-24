extends Node2D

@onready var status_label: Label = $StatusLabel
@onready var missing_permissions_label: Label = $MissingPermissionsLabel
@onready var peers_list: ItemList = $PeersList
@onready var ip_input: LineEdit = $IpInput
@onready var connect_btn: Button = $ConnectButton
@onready var msg_input: LineEdit = $MessageInput
@onready var send_btn: Button = $SendButton
@onready var play_game_btn: Button = $PlayGameButton
@onready var chat_log: TextEdit = $ChatLog
@onready var my_ip_label: Label = $MyIpLabel
@onready var udp_server_label: Label = $UdpServerLabel

func _ready() -> void:
	if OS.has_feature("android"):
		var missing_perms = []
		for perm in ["android.permission.INTERNET", "android.permission.ACCESS_NETWORK_STATE", "android.permission.ACCESS_WIFI_STATE", "android.permission.CHANGE_WIFI_STATE", "android.permission.CHANGE_WIFI_MULTICAST_STATE", "android.permission.ACCESS_COARSE_LOCATION", "android.permission.ACCESS_FINE_LOCATION"]:
			if not OS.request_permission(perm):
				missing_perms.append(perm)
		if missing_perms.size() > 0:
			status_label.text = "Error: Missing permissions!"
			missing_permissions_label.text = "ERROR: Required Android permissions missing: " + ", ".join(missing_perms)
		else:
			missing_permissions_label.text = ""

	status_label.text = "Scanning local WiFi..."
	
	# Display local IP and port
	var local_ips = IP.get_local_addresses()
	var valid_ip = "127.0.0.1"
	for ip in local_ips:
		if not ip.contains(":") and not ip.begins_with("127.") and not ip.begins_with("172.19."):
			valid_ip = ip
			break
	if valid_ip == "127.0.0.1" and local_ips.size() > 0:
		for ip in local_ips:
			if not ip.contains(":"):
				valid_ip = ip
				break
	my_ip_label.text = "My Server IP & Port: %s:%d" % [valid_ip, NetworkManager.actual_port_tcp]
	udp_server_label.text = "UDP Server Port: %d (Active)" % NetworkManager.actual_port_udp
	
	# Restore chat log history
	chat_log.text = "".join(NetworkManager.chat_messages)
	
	connect_btn.pressed.connect(_on_connect_pressed)
	send_btn.pressed.connect(_on_send_pressed)
	play_game_btn.pressed.connect(_on_play_game_pressed)
	peers_list.item_selected.connect(_on_peer_selected)

func _process(delta: float) -> void:
	peers_list.clear()
	for key in NetworkManager.active_peers:
		var peer_data = NetworkManager.active_peers[key]
		peers_list.add_item("%s:%d" % [peer_data["ip"], peer_data["port"]])

func _on_peer_selected(index: int) -> void:
	var text = peers_list.get_item_text(index)
	ip_input.text = text

func _on_connect_pressed() -> void:
	var target = ip_input.text.strip_edges()
	if target == "":
		return
	var parts = target.split(":")
	if parts.size() == 2:
		NetworkManager.connect_to_peer(parts[0], parts[1].to_int())
	else:
		NetworkManager.connect_to_peer(target, NetworkManager.actual_port_tcp)

func _on_send_pressed() -> void:
	var msg = msg_input.text
	if msg == "":
		return
	if NetworkManager.send_message(msg):
		msg_input.text = ""
	else:
		log_message("No active connection to send message.")

func log_message(text: String) -> void:
	chat_log.text += text + "\n"

func on_network_log(text: String) -> void:
	chat_log.text += text + "\n"

func on_network_message(msg: String) -> void:
	if msg.begins_with("TTT_MOVE:"):
		get_tree().change_scene_to_file("res://tictactoe.tscn")

func _on_play_game_pressed() -> void:
	NetworkManager.send_message("TTT_MOVE:START")
	get_tree().change_scene_to_file("res://tictactoe.tscn")
