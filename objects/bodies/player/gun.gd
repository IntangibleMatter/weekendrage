extends Sprite2D

const bombscene := preload("res://objects/explosives/bomb.tscn")

@export var bomb_start_velocity : float = 512.0

var parent : Node2D
@onready var muzzle: Marker2D = $Muzzle


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		fire()


func fire() -> void:
	var b := bombscene.instantiate()
	b.apply_impulse(muzzle.global_position.direction_to(get_global_mouse_position()) * bomb_start_velocity)
	b.global_position = muzzle.global_position
	get_tree().current_scene.add_child(b)


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

