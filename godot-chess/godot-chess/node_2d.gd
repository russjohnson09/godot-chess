extends Node2D

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= 10.0:
		get_tree().quit()
