extends RigidBody2D

signal locked

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _on_body_shape_entered() -> void:
	queue_free()
	print("hit")

func _on_body_entered() -> void:
	queue_free()
	print("hit")

func _on_locked() -> void:
	queue_free()
	print("hit")
