extends RigidBody2D
class_name contact

var opacity = .90

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func degrade_signal(min, interval):
	if opacity > min:
		opacity = opacity - interval
		$sprite.self_modulate.a = opacity
		
func activate_contact():
	opacity = 0.99
	$sprite.self_modulate.a = opacity

func get_contact_position():
	return position
	
func get_vector_to_center():
	print(position.distance_to(Vector2(820, 315)))

	
#func isolate():
	#$sprite.animation = "isolated"
#
#func deselect():
	#$sprite.animation = "default"
