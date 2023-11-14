extends Sprite2D

const bombscene := preload("res://objects/explosives/bomb.tscn")

#@export var bomb_start_velocity : float = 512.0

var parent : Node2D
@onready var muzzle: Marker2D = $Muzzle

const max_bomb_velocity := 1024
const max_bomb_count := 5
var active_bombs := 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		fire()


func fire() -> void:
	if active_bombs >= max_bomb_count:
		return
	var b := bombscene.instantiate()
#	b.apply_impulse(muzzle.global_position.direction_to(get_global_mouse_position()) * bomb_start_velocity)
	b.apply_impulse(calculate_bomb_velocity())
	b.global_position = muzzle.global_position
#	b.add_constant_torque(randf_range(0, PI * 2) * 10)
	b.exploded.connect(update_bomb_count)
	active_bombs += 1
	frame = active_bombs
	get_tree().current_scene.add_child(b)


func calculate_bomb_velocity() -> Vector2:
	var muzzpos : Vector2 = muzzle.global_position
	var mousepos : Vector2 = get_global_mouse_position()
	var diff : Vector2 = Vector2(mousepos.x - muzzpos.x, mousepos.y - muzzpos.y)
	var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	var vi : Vector2 = Vector2(0, sign(diff.y) * sqrt(abs(2 * gravity * diff.y)))
	var t : float = sqrt(abs((2 * diff.y)) / gravity)
	
	vi.x = diff.x / t
	
	# make there be a max velocity
	if vi.distance_to(Vector2.ZERO) > max_bomb_velocity:
		vi = vi.normalized() * max_bomb_velocity
	print(vi.distance_to(Vector2.ZERO))
	return vi


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func update_bomb_count() -> void:
	print("update_bomb_count")
	# -1 to account for the last bomb still existing
	await get_tree().process_frame
	active_bombs = get_tree().get_nodes_in_group(&"playerbomb").size()# - 1
	print(active_bombs)
	frame = active_bombs
