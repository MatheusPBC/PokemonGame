extends Area2D

signal interacted(text: String)

@export var interaction_text: String = "..."


func _ready() -> void:
	add_to_group("interactable")


func interact() -> void:
	interacted.emit(interaction_text)
