extends Area2D

@export var speed = 400
var screen_size
var on_contact
var desired_position
var contact_id
var current_contact
var contacts_covered = []

signal isolated_contact (type, category)
signal hit
signal locked

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	
	desired_position = position
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Update the desired position
	desired_position += velocity * delta
	var position_distance = position.distance_to(Vector2(820, 315))
	var desired_position_distance = desired_position.distance_to(Vector2(820, 315))

	# Only move the cursor if the vect dist is less than the console radius
	# Or if it moves it closer to the center
	if position_distance < 280 || desired_position_distance < position_distance:
		position += velocity * delta
	
	# Keep this as a fallback - cursor should stay in screen
	position = position.clamp(Vector2.ZERO, screen_size)
		
	#print("contact is: " + str(on_contact))
	
	if Input.is_action_pressed("space"):
		if on_contact != null:
			#print(on_contact)
			lock_contact(on_contact)
	
func _on_body_entered(body):
	contacts_covered.append(str(body.get_instance_id()))
	contact_id = contacts_covered[0]
	current_contact = instance_from_id(int(contact_id))
	isolated_contact.emit(current_contact.category, current_contact.type)
	$contact_isolated.play()
	on_contact = current_contact
	hit.emit()
	
	print(contacts_covered)
	
	# Send a connected call to the server indicating it's been isolated

func _on_body_exited(body) -> void:
	contacts_covered.erase(str(body.get_instance_id()))
	if contacts_covered.size() > 0:
		contact_id = contacts_covered[0]
		current_contact = instance_from_id(int(contact_id))
	else:
		on_contact = null

func lock_contact(body):	
	if body.is_in_group("contacts"):
		on_contact = null
		remove_body(body)
		locked.emit(body.get_instance_id())
		
func lock_contact_by_id (contact_id):
	var contact_to_remove = instance_from_id(int(contact_id))
	remove_body(contact_to_remove)
	locked.emit(int(contact_id))
	
func remove_body (body):
	body.queue_free()
	
func start(pos):
	position = pos
	self.show()
	$CollisionShape2D.disabled = false

func _on_main_gameover() -> void:
	self.hide()
