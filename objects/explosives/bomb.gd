extends RigidBody2D

const EXPLOSION_FORCE : int = 1500
const RANGE_SIZE : float = 128
const ANGLE_FORGIVENESS : float = 0.2

const explosion_fx := preload("res://objects/explosives/explosionfx.tscn")

@onready var aoe: Area2D = $Aoe
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal exploded

func _ready() -> void:
	print("wkjhalkfsjh")

func start_countdown(from: int) -> void:
	var count := from
	if count <= 0:
		for _i in 3:
			await get_tree().process_frame
		explode()
		return
	while count > 0:
		$Label.text = str(count)
		await get_tree().create_timer(1.0).timeout
		count -= 1
	explode()


func explode() -> void:
	prints("blowing up", self)
	collision_layer = 0
	var objects := aoe.get_overlapping_bodies()
	animation_player.play(&"destroy")
	var efx := explosion_fx.instantiate()
	efx.global_position = global_position
	get_tree().current_scene.add_child(efx)
	push_away_objects(objects)
	destroy_objects(objects)
	emit_signal(&"exploded")
	prints("queueing self for freeing.", self)
	queue_free()


func push_away_objects(objects: Array[Node2D]) -> void:
	#print("running")
	for object in objects:
		if not is_instance_valid(object):
			continue
		#print(object)
		if not object is RigidBody2D:
			continue
		
		#prints("hitting", object)
		var force_dir : Vector2 = -(global_position - object.global_position).normalized()
		var angle_check : float = -get_angle_to(object.global_position)
		if angle_check > PI / 2 - ANGLE_FORGIVENESS and angle_check < PI / 2 + ANGLE_FORGIVENESS:
			force_dir = Vector2.UP
			#print("corrected angle!")
		#prints("angle", angle_check)
		var force_size: Vector2 = force_dir \
		* cubic_interpolate(
			0.3, 0.9, 0, 1.0,
			1.0 - clampf(abs(global_position.distance_to(object.global_position)) / RANGE_SIZE, 0, 1)
			)\
		* EXPLOSION_FORCE
		
		object.apply_impulse(force_size)
	#print("ran")
	await get_tree().physics_frame


func destroy_objects(objects: Array[Node2D]) -> void:
	for object in objects:
		if not is_instance_valid(object):
			continue
		if not object.has_method(&"destroy"):
			continue
		object.destroy()


func _on_body_entered(_body: Node) -> void:
	call_deferred(&"freeze_movement")


func freeze_movement() -> void:
	freeze = true
	lock_rotation = true
	#print(freeze)
	start_countdown(1)
