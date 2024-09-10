extends Node

@export var contact: PackedScene
var score

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func _increment_signals():
	score = score + 1
	$HUD.update_score(score)
	
func new_game():
	score = 0
	$cursor.start($StartPosition.position)

	var contact = contact.instantiate()
	contact.position = Vector2(randi_range(200,500), randi_range(200,500))

	add_child(contact)
