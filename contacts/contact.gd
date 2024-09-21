extends RigidBody2D
class_name contact

func _ready() -> void:
	add_to_group("contacts")

func _process(_delta: float) -> void:
	pass
