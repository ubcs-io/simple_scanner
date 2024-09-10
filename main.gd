extends Node

@export var contact: PackedScene
var score = 0
var search_for_life = 0
var total_contacts = 0
var at_menu = 1

func _ready() -> void:
	pass

func _process(_delta) -> void:
	
	if total_contacts < 7 and at_menu == 0:
		search_for_life = randi_range(0,5000)
		if search_for_life < 7:
			var contact = contact.instantiate()
			contact.position = Vector2(randi_range(100,1100), randi_range(100,550))
			add_child(contact)
			total_contacts = total_contacts + 1

func _increment_signals():
	score = score + 1
	$HUD.update_score(score)
	
func new_game():
	score = 0
	at_menu = 0
	$cursor.start($StartPosition.position)
