extends RigidBody2D
class_name contact

var opacity = 1

func _ready() -> void:
	#add_to_group("contacts")
	pass

func _process(_delta: float) -> void:
	pass

func degrade_signal(min, interval) -> void:
	
	if opacity > min:
		opacity = opacity - interval
		$sprite.self_modulate.a = opacity
