extends Node3D

@onready var timer = $Timer 
@onready var timer_label = $Timer/Label_Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.coins = 0
	timer.start()
	update_timer_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_timer_label()


func _on_timer_timeout() -> void:
	if Global.coins < Global.coins_to_win:
		get_tree().change_scene_to_file("res://GameOverScreen.tscn")

func update_timer_label():
	var time_left = ceil(timer.time_left)  # Get remaining time in whole seconds
	var minutes = int(time_left / 60)  # Get the minutes
	var seconds = int(time_left) % 60  # Get the remaining seconds

	# Format the minutes and seconds to always be two digits
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	if time_left <= 10:
		timer_label.modulate = Color(1, 0, 0)  # Red color
	else:
		timer_label.modulate = Color(1, 1, 1) 
