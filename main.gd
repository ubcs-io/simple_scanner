extends Node

@export var contact: PackedScene
@export var ship_speed = 10
@export var signal_rate = 5000
@export var max_contacts = 5

var score = 0
var search_for_life = 0
var total_contacts = 0
var at_menu = 1

signal gameover

func _ready() -> void:
	pass

func _process(_delta) -> void:

	if Input.is_action_pressed("speed_up"):
		if ship_speed < 200:
			ship_speed += 10
	if Input.is_action_pressed("speed_down"):
		if ship_speed > 5:
			ship_speed -= 5
	
	if total_contacts < max_contacts and at_menu == 0:
		search_for_life = randi_range(1,signal_rate) / ship_speed
		print(search_for_life)
		if search_for_life < 5:
			var contact = contact.instantiate()
			contact.position = Vector2(randi_range(200,1100), randi_range(100,550))
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
		get_tree().call_group("contacts", "queue_free")

func new_game():
	score = 0
	at_menu = 0
	$cursor.start($StartPosition.position)

func _on_gameover():
	score = 0
	total_contacts = 0 
	at_menu = 1
	await get_tree().create_timer(1.0).timeout
