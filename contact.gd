extends RigidBody2D

signal locked

var contact_to_remove

func _ready() -> void:
	add_to_group("contacts")

func _process(_delta: float) -> void:
	pass

func _lock_contact_by_id (contact_id):
	print("Removing contact " + str(contact_id))
	contact_to_remove = instance_from_id(contact_id)
	contact_to_remove.queue_free()
