extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $TimerLabel
@onready var icon1: Sprite2D = $Icon
@onready var icon2: Sprite2D = $Icon2
@onready var icon3: Sprite2D = $Icon3

var time_passed: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	if timer and label:
		label.text = "Time left: %.2f" % max(0.0, timer.time_left)
	
	if icon1 and icon2 and icon3:
		icon1.rotation = sin(time_passed * 3.0) * 0.5
		icon2.position.y = 124.0 + cos(time_passed * 4.0) * 20.0
		icon3.scale = Vector2.ONE * (1.0 + sin(time_passed * 5.0) * 0.2)

func _on_timer_timeout() -> void:
	get_tree().quit()
