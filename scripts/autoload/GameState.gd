extends Node

# Autoload (Project Settings -> Autoload) com o nome: GameState

var return_overworld_scene_path: String = "res://scenes/overworld/Overworld.tscn"
var return_player_position: Vector2 = Vector2.ZERO

var pending_encounter: Dictionary = {}


func clear_pending_encounter() -> void:
	pending_encounter = {}
