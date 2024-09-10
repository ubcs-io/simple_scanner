extends RigidBody2D

signal locked

func _ready() -> void:
	add_to_group("contacts")

func _process(_delta: float) -> void:
	pass
