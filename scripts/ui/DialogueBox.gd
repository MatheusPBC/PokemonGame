extends Control

@export var text_label_path: NodePath
@export var close_button_path: NodePath

@onready var _text_label := get_node_or_null(text_label_path) as Label
@onready var _close_button := get_node_or_null(close_button_path) as Button


func _ready() -> void:
	visible = false
	if _close_button != null and not _close_button.pressed.is_connected(_on_close_pressed):
		_close_button.pressed.connect(_on_close_pressed)


func show_text(content: String) -> void:
	if _text_label != null:
		_text_label.text = content
	visible = true


func _on_close_pressed() -> void:
	visible = false
