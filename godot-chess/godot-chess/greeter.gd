extends Node2D


@onready var label = $Label


func _ready() -> void:
	
	
	#var greeter = RustGreeter.new()
	
	
	var get_greeting = $RustGreeter.greet("hi")
	
	print(get_greeting)
	
	
	label.text = get_greeting
	
	
	pass
