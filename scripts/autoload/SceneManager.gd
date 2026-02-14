extends Node

# Autoload (Project Settings -> Autoload) com o nome: SceneManager


func go_to_overworld() -> void:
	get_tree().change_scene_to_file(GameState.return_overworld_scene_path)


func start_battle(encounter_payload: Dictionary) -> void:
	GameState.pending_encounter = encounter_payload
	get_tree().change_scene_to_file("res://scenes/battle/BattlePlaceholder.tscn")
