extends contact
class_name object

var value
var size
var type
var category

func _ready() -> void:
	add_to_group("contacts")
	value = randi_range(50, 100)
	size = randi_range(100, 150)
	category = "object"
	var available_types = ["Abandoned cargo", "Scrap", "Derelict satellite"]
	type = available_types.pick_random()

func _process(_delta: float) -> void:
	pass
