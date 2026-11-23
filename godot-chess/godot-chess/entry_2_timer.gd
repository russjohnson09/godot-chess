extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $TimerLabel

func _process(_delta: float) -> void:
	if timer and label:
		label.text = "Time left: %.2f" % max(0.0, timer.time_left)

func _on_timer_timeout() -> void:
	get_tree().quit()
