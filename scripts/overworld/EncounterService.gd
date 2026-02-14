extends Node

@export var encounter_chance_per_step: float = 0.08
@export var min_steps_between_encounters: int = 10

@export var player_path: NodePath
@export var step_tracker_path: NodePath
@export var encounter_table_id: String = ""

var _steps_since_last: int = 9999
var _inside_encounter_area: bool = false

@onready var _player := get_node_or_null(player_path) as Node2D
@onready var _step_tracker := get_node_or_null(step_tracker_path)


func _ready() -> void:
	add_to_group("encounter_service")
	randomize()
	if _step_tracker != null and _step_tracker.has_signal("step"):
		_step_tracker.connect("step", _on_step)
	_steps_since_last = min_steps_between_encounters


func _on_step() -> void:
	_steps_since_last += 1
	if not _inside_encounter_area:
		return
	if encounter_table_id.is_empty():
		return
	if _steps_since_last < min_steps_between_encounters:
		return
	if randf() > encounter_chance_per_step:
		return

	var table := DataRegistry.get_encounter_table(encounter_table_id)
	if table == null:
		return
	if not (table is EncounterTableResource):
		return
	if table.entries.is_empty():
		return

	var entry := _pick_weighted_entry(table.entries)
	if entry == null:
		return
	if entry.species_id.is_empty():
		return

	var level := randi_range(entry.min_level, entry.max_level)

	GameState.return_player_position = (_player.global_position if _player != null else Vector2.ZERO)
	SceneManager.start_battle({
		"species_id": entry.species_id,
		"level": level,
		"encounter_source": "grass",
	})

	_steps_since_last = 0


func set_active_encounter_table(table_id: String) -> void:
	_inside_encounter_area = not table_id.is_empty()
	encounter_table_id = table_id


func clear_active_encounter_table(table_id: String = "") -> void:
	if table_id.is_empty() or table_id == encounter_table_id:
		_inside_encounter_area = false
		encounter_table_id = ""


func _pick_weighted_entry(entries: Array[EncounterEntryResource]) -> EncounterEntryResource:
	var total_weight := 0
	for e in entries:
		if e == null:
			continue
		total_weight += max(0, e.weight)
	if total_weight <= 0:
		return null

	var roll := randi_range(1, total_weight)
	var running := 0
	for e in entries:
		if e == null:
			continue
		running += max(0, e.weight)
		if roll <= running:
			return e

	return null
