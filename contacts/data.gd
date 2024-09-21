extends contact
class_name data

var value
var size
var type
var category

func _ready() -> void:
	add_to_group("contacts")
	value = randi_range(150, 300)
	size = randi_range(10, 20)
	category = "data"
	var available_types = ["Faint signal", "Unusual repeated pattern", "Unmapped radio broadcast"]
	type = available_types.pick_random()

func _process(_delta: float) -> void:
	pass
