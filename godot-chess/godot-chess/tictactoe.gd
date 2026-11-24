extends Node2D

var board = ["", "", "", "", "", "", "", "", ""]
var my_turn = false
var my_symbol = "X"
var game_active = false

@onready var status_label: Label = $StatusLabel
@onready var grid_container: GridContainer = $GridContainer
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	for i in range(9):
		var btn = grid_container.get_child(i) as Button
		btn.pressed.connect(func(): _on_cell_pressed(i))
		
	# Check if we connected as client (O) or server (X)
	if NetworkManager.is_client_connected:
		my_symbol = "O"
		my_turn = false
		status_label.text = "Connected as O. Wait for X's turn."
	else:
		my_symbol = "X"
		my_turn = true
		status_label.text = "Hosting as X. Your turn!"
	game_active = true
	update_board_ui()

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
	get_tree().change_scene_to_file("res://wifi_scanner.tscn")

func on_network_message(msg: String) -> void:
	if msg.begins_with("TTT_MOVE:"):
		var parts = msg.split(":")
		if parts.size() == 3:
			receive_move(parts[1].to_int(), parts[2])
