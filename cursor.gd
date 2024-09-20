extends Area2D

@export var speed = 400
var screen_size
var on_contact

signal hit
signal locked

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
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

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
		
	if Input.is_action_pressed("space"):
		if on_contact != null:
			lock_contact(on_contact)

func _on_body_entered(body):
	hit.emit()
	# Ideally this should activate an animation on the signal, but this'll do for now
	$contact_isolated.play()
	on_contact = body
		
func lock_contact(body):	
	if body.is_in_group("contacts"):
		on_contact = null
		locked.emit(body.get_instance_id())
		#print(body)
		#print("Sending lock signal for " + str(body.get_instance_id()))
		lock_contact_by_id(body.get_instance_id())
		
func lock_contact_by_id (contact_id):
	print("Removing contact " + str(contact_id))
	var contact_to_remove = instance_from_id(int(contact_id))
	print(contact_to_remove)
	contact_to_remove.queue_free()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_main_gameover() -> void:
	hide()
