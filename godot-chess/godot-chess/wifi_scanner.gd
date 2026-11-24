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
	
	# Restore chat log history
	chat_log.text = "".join(NetworkManager.chat_messages)
	
	connect_btn.pressed.connect(_on_connect_pressed)
	send_btn.pressed.connect(_on_send_pressed)
	play_game_btn.pressed.connect(_on_play_game_pressed)
	peers_list.item_selected.connect(_on_peer_selected)

func _process(delta: float) -> void:
	peers_list.clear()
	for ip in NetworkManager.active_peers:
		peers_list.add_item(ip)

func _on_peer_selected(index: int) -> void:
	var ip = peers_list.get_item_text(index)
	ip_input.text = ip

func _on_connect_pressed() -> void:
	var target_ip = ip_input.text.strip_edges()
	if target_ip == "":
		return
	NetworkManager.connect_to_peer(target_ip)

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
	if text.begins_with("TTT_MOVE:"):
		get_tree().change_scene_to_file("res://tictactoe.tscn")

func _on_play_game_pressed() -> void:
	NetworkManager.send_message("TTT_MOVE:START")
	get_tree().change_scene_to_file("res://tictactoe.tscn")
