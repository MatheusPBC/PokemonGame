extends Node

signal step

@export var step_distance_px: float = 16.0

var _accumulated: float = 0.0
var _last_position: Vector2


func _ready() -> void:
	var parent := get_parent() as Node2D
	if parent == null:
		set_physics_process(false)
		return
	_last_position = parent.global_position


func _physics_process(delta: float) -> void:
	var parent := get_parent() as Node2D
	if parent == null:
		return

	var current := parent.global_position
	var moved := current.distance_to(_last_position)
	_last_position = current

	if moved <= 0.0:
		return

	_accumulated += moved
	while _accumulated >= step_distance_px:
		_accumulated -= step_distance_px
		step.emit()
