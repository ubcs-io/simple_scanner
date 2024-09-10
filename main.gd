extends Node

@export var contact: PackedScene
var score = 0
var search_for_life = 0
var total_contacts = 0
var at_menu = 1

signal gameover

func _ready() -> void:
	pass

func _process(_delta) -> void:
	
	if total_contacts < 3 and at_menu == 0:
		search_for_life = randi_range(0,5000)
		if search_for_life < 50:
			var contact = contact.instantiate()
			contact.position = Vector2(randi_range(100,1100), randi_range(100,550))
			add_child(contact)
			$contact_new.play()
			total_contacts = total_contacts + 1

func _increment_signals():
	$contact_locked.play()
	score = score + 1
	total_contacts = total_contacts - 1
	$HUD.update_score(score)
	if score > 3:
		gameover.emit()
		for contact in get_tree().get_nodes_in_group("contacts"):
			contact.queue_free()

func new_game():
	score = 0
	at_menu = 0
	$cursor.start($StartPosition.position)

func _on_gameover():
	score = 0
	total_contacts = 0 
	at_menu = 1
	await get_tree().create_timer(1.0).timeout
