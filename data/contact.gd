class_name Contact
extends Resource

@export var id:int
@export var name:String
@export var rarity:String

@export var min_value:int
@export var max_value:int

@export var min_storage:int
@export var max_storage:int

@export var scene:PackedScene

var storage
var value

func _ready() -> void:
	storage = randi_range(min_storage,max_storage)
	value = randi_range(min_value,max_value)
