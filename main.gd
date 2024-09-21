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
var locked_contacts = []

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
	
	total_contacts = get_tree().get_nodes_in_group("contacts").size()
	if total_contacts < max_contacts and at_menu == 0:
		
		search_for_life = randi_range(1,signal_rate) / ship_speed
		if search_for_life < 5:
			var contact = contact.instantiate()
			contact.position = Vector2(820 + randi_range(-275,275), 315 + randi_range(-275,275))
			add_child(contact)
			print(get_tree().get_nodes_in_group("contacts").size())
			contact_server(contact.get_instance_id(), 1337, "detected", "A new contact has appeared", "update")
			$contact_new.play()

func _increment_signals(contact_id):
	$contact_locked.play()
	locked_contacts.append(str(contact_id))
	contact_server(contact_id, 1337, "locked", "Contact locked", "update")
	score = locked_contacts.size()
	$HUD.update_score(score)
	print(locked_contacts)
	if score >= 3:
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
		
	#if send_request != OK:
		#print(url)
		#print('Issue with request')
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(response_code, headers)
	#print(json)
	update_game(json)
	
func update_game(heartbeat):
	if 'status' in heartbeat && heartbeat.status == "locked" && at_menu == 0:
		if !locked_contacts.has(str(heartbeat.id)):
			print(locked_contacts)
			print("Remove " + str(heartbeat.id))
			$cursor.lock_contact_by_id(heartbeat.id)
			#_increment_signals(heartbeat.id)


# Game start/end methods
func new_game():
	score = 0
	at_menu = 0
	contact_server(1, 1337, "none", "Scanner warming up", "update")
	$cursor.start($StartPosition.position)

func _on_gameover():
	score = 0
	locked_contacts = []
	at_menu = 1
	await get_tree().create_timer(2.0).timeout
	contact_server(1, 1337, "none", "No contacts present", "update")
	
