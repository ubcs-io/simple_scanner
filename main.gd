extends Node

@export var contact: PackedScene
@export var ship_speed = 10
@export var signal_rate = 5000
@export var max_contacts = 5

var request : HTTPRequest
var root_url : String = "https://typeri.us/dora_brain?"

var score = 0
var search_for_life = 0
var total_contacts = 0
var at_menu = 1

var headers
var body
var contact_id
var session
var status
var message
var source = "game_client"

# Set up the server sync
@export_range(0, 1, 0.05, "suffix:s", "or_greater")
var heartbeat_delay: float = 3.0
var server_heartbeat := Timer.new()

signal gameover
signal locked

func _ready() -> void:
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)

	add_child(server_heartbeat)
	server_heartbeat.wait_time = heartbeat_delay
	server_heartbeat.one_shot = false
	server_heartbeat.connect("timeout", server_heartbeat_timeout)
	server_heartbeat.start()

func _process(_delta) -> void:

	if Input.is_action_pressed("speed_up"):
		if ship_speed < 200:
			ship_speed += 10
	if Input.is_action_pressed("speed_down"):
		if ship_speed > 5:
			ship_speed -= 5
	
	if total_contacts < max_contacts and at_menu == 0:
		search_for_life = randi_range(1,signal_rate) / ship_speed
		if search_for_life < 5:
			var contact = contact.instantiate()
			contact.position = Vector2(randi_range(200,1100), randi_range(100,550))
			add_child(contact)
			contact_id = contact.get_instance_id()
			contact_server(contact_id, 1337, "detected", "A new contact has appeared", "update")
			$contact_new.play()
			total_contacts = total_contacts + 1

func _increment_signals(contact_id):
	$contact_locked.play()
	score = score + 1
	total_contacts = total_contacts - 1
	$HUD.update_score(score)
	#print("Remove contact with id: " + str(contact_id))
	contact_server(contact_id, 1337, "locked", "Contact locked", "update")
	if score > 3:
		gameover.emit()
		get_tree().call_group("contacts", "queue_free")

func server_heartbeat_timeout():
	var heartbeat = contact_server(1, 1337, "none", "none", "sync")
	
func contact_server(id, session, status, message, event_type):

	contact_id = str(id)
	session = str(session)
	status = status.uri_encode()
	message = message.uri_encode()

#	# This one gets mad about initializing
	#var params = request.HTTPClient.query_string_from_dict(fields)
	
	headers = ["Content-type: application/json"]
	var url = root_url
	var params = ""
	params = "id="+contact_id+"&session="+session+"&event_type="+event_type+"&status="+status+"&source="+source+"&message="+message
	
	url = url + params
	var send_request = request.request(
		url, headers, HTTPClient.METHOD_GET)
		
	if send_request != OK:
		#print(url)
		print('Issue with request')
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(response_code, headers)
	#print(json)
	update_game(json)
	
func update_game(heartbeat):
	if 'status' in heartbeat && heartbeat.status == "locked":
		print("Sending lock signal for " + str(heartbeat.id))
		for contact in contact.get_children():
			if heartbeat.id == contact.id:
					print("Should remove: " + contact.id)
		#locked.emit(heartbeat.id)
		#$cursor.lock_contact_by_id(heartbeat.id)
	
# Game start/end methods
func new_game():
	score = 0
	at_menu = 0
	contact_server(1, 1337, "none", "Scanner warming up", "update")
	$cursor.start($StartPosition.position)

func _on_gameover():
	score = 0
	total_contacts = 0 
	at_menu = 1
	await get_tree().create_timer(2.0).timeout
	contact_server(1, 1337, "none", "No contacts present", "update")
	
