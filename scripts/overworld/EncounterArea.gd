extends Area2D

@export var encounter_table_id: String = "test_grass"


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var service := get_tree().get_first_node_in_group("encounter_service")
	if service != null and service.has_method("set_active_encounter_table"):
		service.call("set_active_encounter_table", encounter_table_id)


func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var service := get_tree().get_first_node_in_group("encounter_service")
	if service != null and service.has_method("clear_active_encounter_table"):
		service.call("clear_active_encounter_table", encounter_table_id)
