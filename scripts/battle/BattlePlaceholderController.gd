extends Control

@export var encounter_label_path: NodePath
@export var back_button_path: NodePath

@onready var _encounter_label := get_node_or_null(encounter_label_path) as Label
@onready var _back_button := get_node_or_null(back_button_path) as Button


func _ready() -> void:
	if _back_button != null and not _back_button.pressed.is_connected(on_back_pressed):
		_back_button.pressed.connect(on_back_pressed)

	var species_id := String(GameState.pending_encounter.get("species_id", ""))
	var level := int(GameState.pending_encounter.get("level", 0))

	if _encounter_label != null:
		_encounter_label.text = "Um Pokemon selvagem apareceu: %s (Lv %d)" % [species_id, level]


func on_back_pressed() -> void:
	GameState.clear_pending_encounter()
	SceneManager.go_to_overworld()
