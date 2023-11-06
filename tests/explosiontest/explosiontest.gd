extends Node2D

const bombscene := preload("res://objects/explosives/bomb.tscn")

var timer_value : int = 1

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					for i in 10:
						spawnbomb(timer_value)
				MOUSE_BUTTON_RIGHT:
					spawnbomb(0)
				MOUSE_BUTTON_WHEEL_DOWN:
					timer_value -= 1
					if timer_value < 1: timer_value = 1
				MOUSE_BUTTON_WHEEL_UP:
					timer_value += 1
					if timer_value > 10: timer_value = 10


func spawnbomb(timer : int) -> void:
	var b := bombscene.instantiate()
#	await b.ready
	b.global_position = get_global_mouse_position()
	add_child(b)
	b.start_countdown(timer)
