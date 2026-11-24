extends Node2D

var board = ["", "", "", "", "", "", "", "", ""]
var my_turn = false
var my_symbol = "X"
var game_active = false

var opponent_cursor_sprite: Sprite2D = null
var cursor_send_timer := 0.0

@onready var status_label: Label = $StatusLabel
@onready var grid_container: GridContainer = $GridContainer
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	for i in range(9):
		var btn = grid_container.get_child(i) as Button
		btn.pressed.connect(func(): _on_cell_pressed(i))
		
	# Check if we have incoming connections (Server/X) or are connected as client (O)
	if NetworkManager.is_client_connected or NetworkManager.connected_clients.size() > 0:
		if NetworkManager.is_client_connected:
			my_symbol = "O"
			my_turn = false
			status_label.text = "Connected as O. Wait for X's turn."
		else:
			my_symbol = "X"
			my_turn = true
			status_label.text = "Hosting as X. Your turn!"
	else:
		my_symbol = "X"
		my_turn = true
		status_label.text = "Hosting as X. Your turn!"
	
	# Set custom cursor sprite
	var cursor_scene = load("res://ui/tic_tac_toe_x.tscn") if my_symbol == "X" else load("res://ui/tic_tac_toe_o.tscn")
	if cursor_scene:
		var cursor_node = cursor_scene.instantiate()
		# Create an image texture from the sprite or set custom mouse cursor if applicable, 
		# or track mouse position for a custom sprite cursor.
		# Godot supports Input.set_custom_mouse_cursor from an Image texture.
		if cursor_node is Sprite2D and cursor_node.texture:
			var img = cursor_node.texture.get_image()
			var rect = cursor_node.region_rect
			if rect.size.x > 0 and rect.size.y > 0:
				var region_img = img.get_region(rect)
				var tex = ImageTexture.create_from_image(region_img)
				Input.set_custom_mouse_cursor(tex, Input.CURSOR_ARROW, Vector2(tex.get_width() / 2, tex.get_height() / 2))
			else:
				var tex = ImageTexture.create_from_image(img)
				Input.set_custom_mouse_cursor(tex, Input.CURSOR_ARROW, Vector2(tex.get_width() / 2, tex.get_height() / 2))

	game_active = true
	update_board_ui()
	
	# Instantiate opponent cursor sprite
	var opp_scene = load("res://ui/tic_tac_toe_o.tscn") if my_symbol == "X" else load("res://ui/tic_tac_toe_x.tscn")
	if opp_scene:
		opponent_cursor_sprite = opp_scene.instantiate() as Sprite2D
		opponent_cursor_sprite.modulate = Color(1, 1, 1, 0.6) # Slightly transparent
		opponent_cursor_sprite.visible = false
		add_child(opponent_cursor_sprite)

func _process(delta: float) -> void:
	if not game_active:
		return
	cursor_send_timer += delta
	if cursor_send_timer >= 0.05: # Send cursor position every 50ms
		cursor_send_timer = 0.0
		var pos = get_viewport().get_mouse_position()
		var msg = "TTT_CURSOR:%.1f:%.1f" % [pos.x, pos.y]
		NetworkManager.send_message(msg)

func _on_cell_pressed(index: int) -> void:
	if not game_active:
		return
	if not my_turn:
		status_label.text = "Not your turn!"
		return
	if board[index] != "":
		return
		
	board[index] = my_symbol
	my_turn = false
	update_board_ui()
	
	# Send move over network
	var msg = "TTT_MOVE:%d:%s" % [index, my_symbol]
	NetworkManager.send_message(msg)
	
	check_game_state()

func receive_move(index: int, symbol: String) -> void:
	if board[index] == "":
		board[index] = symbol
		my_turn = true
		update_board_ui()
		status_label.text = "Your turn (%s)" % my_symbol
		check_game_state()

func update_board_ui() -> void:
	for i in range(9):
		var btn = grid_container.get_child(i) as Button
		btn.text = board[i]

func check_game_state() -> void:
	var win_conditions = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # cols
		[0, 4, 8], [2, 4, 6]            # diagonals
	]
	for cond in win_conditions:
		if board[cond[0]] != "" and board[cond[0]] == board[cond[1]] and board[cond[1]] == board[cond[2]]:
			game_active = false
			var winner = board[cond[0]]
			if winner == my_symbol:
				status_label.text = "You Win!"
			else:
				status_label.text = "You Lose!"
			return
			
	if not "" in board:
		game_active = false
		status_label.text = "It's a Draw!"

func _on_back_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://wifi_scanner.tscn")

func on_network_message(msg: String) -> void:
	if "TTT_MOVE:START" in msg:
		if NetworkManager.is_client_connected:
			my_symbol = "O"
			my_turn = false
			status_label.text = "Game Started! O's turn (Wait for X)."
		else:
			my_symbol = "X"
			my_turn = true
			status_label.text = "Game Started! Your turn (X)."
		game_active = true
		update_board_ui()
	elif "TTT_CURSOR:" in msg:
		var parts = msg.split(":")
		if parts.size() >= 3 and opponent_cursor_sprite:
			var cx = parts[1].to_float()
			var cy = parts[2].to_float()
			opponent_cursor_sprite.position = Vector2(cx, cy)
			opponent_cursor_sprite.visible = true
	elif "TTT_MOVE:" in msg and not "START" in msg:
		var parts = msg.split(":")
		for p in parts:
			if p.is_valid_int():
				var idx = p.to_int()
				var symbol = "O" if my_symbol == "X" else "X"
				receive_move(idx, symbol)
				break
