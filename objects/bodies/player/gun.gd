extends Sprite2D

var parent : Node2D
@onready var muzzle: Marker2D = $Muzzle

#func _ready() -> void:
#	if get_parent() == null:
#		push_error("Yeah bud I can't work without a parent lmao")
#		get_tree().quit()
#
#	parent = get_parent()
	


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
#	var angle_to_mouse : float = get_angle_to(get_global_mouse_position())
#	prints(Time.get_ticks_msec(),"mouse", angle_to_mouse)
#	rotation = angle_to_mouse
