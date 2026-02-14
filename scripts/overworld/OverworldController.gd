extends Node2D

@export var player_path: NodePath
@export var dialogue_box_path: NodePath

@onready var _player := get_node_or_null(player_path) as Node2D
@onready var _dialogue_box := get_node_or_null(dialogue_box_path)


func _ready() -> void:
	_ensure_input_actions()
	_restore_player_position_if_needed()
	_connect_interactables()


func _restore_player_position_if_needed() -> void:
	if _player == null:
		return
	if GameState.return_player_position == Vector2.ZERO:
		return
	_player.global_position = GameState.return_player_position


func _connect_interactables() -> void:
	for node in get_tree().get_nodes_in_group("interactable"):
		if node.has_signal("interacted") and not node.is_connected("interacted", _on_interactable_interacted):
			node.connect("interacted", _on_interactable_interacted)


func _on_interactable_interacted(text: String) -> void:
	if _dialogue_box != null and _dialogue_box.has_method("show_text"):
		_dialogue_box.call("show_text", text)


func _ensure_input_actions() -> void:
	_ensure_action("move_up", [KEY_W, KEY_UP])
	_ensure_action("move_down", [KEY_S, KEY_DOWN])
	_ensure_action("move_left", [KEY_A, KEY_LEFT])
	_ensure_action("move_right", [KEY_D, KEY_RIGHT])
	_ensure_action("interact", [KEY_E, KEY_SPACE])


func _ensure_action(action_name: StringName, keys: Array[int]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	for key in keys:
		if _action_has_key(action_name, key):
			continue
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action_name, event)


func _action_has_key(action_name: StringName, key: int) -> bool:
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey and event.physical_keycode == key:
			return true
	return false
