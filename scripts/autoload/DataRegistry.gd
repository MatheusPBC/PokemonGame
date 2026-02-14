extends Node

# Autoload (Project Settings -> Autoload) com o nome: DataRegistry
# Carrega dados de Resources em res://data/* e fornece lookup por id.

var species_by_id: Dictionary = {}
var moves_by_id: Dictionary = {}
var encounter_tables_by_id: Dictionary = {}


func _ready() -> void:
	reload_all()


func reload_all() -> void:
	species_by_id = _load_resources_by_id("res://data/species")
	moves_by_id = _load_resources_by_id("res://data/moves")
	encounter_tables_by_id = _load_resources_by_id("res://data/encounter_tables")


func get_species(species_id: String) -> Resource:
	return species_by_id.get(species_id)


func get_move(move_id: String) -> Resource:
	return moves_by_id.get(move_id)


func get_encounter_table(table_id: String) -> Resource:
	return encounter_tables_by_id.get(table_id)


func _load_resources_by_id(dir_path: String) -> Dictionary:
	var result: Dictionary = {}
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return result

	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name.is_empty():
			break
		if dir.current_is_dir():
			continue
		if not (file_name.ends_with(".tres") or file_name.ends_with(".res")):
			continue

		var resource_path := dir_path.path_join(file_name)
		var res := load(resource_path)
		if res == null:
			continue

		var id_value := _extract_string_id(res)
		if id_value.is_empty():
			continue

		result[id_value] = res

	dir.list_dir_end()
	return result


func _extract_string_id(res: Resource) -> String:
	for prop in res.get_property_list():
		if String(prop.get("name", "")) != "id":
			continue
		var value = res.get("id")
		if typeof(value) == TYPE_STRING:
			return String(value)
		return ""
	return ""
