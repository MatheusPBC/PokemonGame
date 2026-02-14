extends CharacterBody2D

@export var speed: float = 90.0
@export var interact_offset: float = 12.0

@export var interaction_detector_path: NodePath
@export var step_tracker_path: NodePath

var facing: Vector2 = Vector2.DOWN

@onready var _interaction_detector := get_node_or_null(interaction_detector_path) as Area2D
@onready var _step_tracker := get_node_or_null(step_tracker_path)


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_dir.length_squared() > 0.0:
		input_dir = _lock_to_4_directions(input_dir).normalized()
		facing = input_dir

	velocity = input_dir * speed
	move_and_slide()

	_update_interaction_detector_position()

	if Input.is_action_just_pressed("interact"):
		if _interaction_detector != null and _interaction_detector.has_method("try_interact"):
			_interaction_detector.call("try_interact")


func _lock_to_4_directions(dir: Vector2) -> Vector2:
	if absf(dir.x) > absf(dir.y):
		return Vector2(signf(dir.x), 0.0)
	return Vector2(0.0, signf(dir.y))


func _update_interaction_detector_position() -> void:
	if _interaction_detector == null:
		return
	_interaction_detector.position = facing * interact_offset
