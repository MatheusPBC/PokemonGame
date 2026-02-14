extends Resource
class_name PokemonSpeciesResource

@export var id: String = ""
@export var display_name: String = ""

@export var types: Array[String] = []

@export var base_hp: int = 10
@export var base_atk: int = 5
@export var base_def: int = 5
@export var base_spa: int = 5
@export var base_spd: int = 5
@export var base_spe: int = 5

@export var front_sprite: Texture2D
@export var back_sprite: Texture2D
