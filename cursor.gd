extends Area2D

@export var speed = 400
var screen_size

signal hit

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

func _on_body_entered(body):
	hit.emit()
	
	# For some reason some instances don't have a contact name
	print(body.name)
	
	#if body.name == "contact":
	if body is RigidBody2D:
		body.queue_free()
		#print("hit!")
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_main_gameover() -> void:
	hide()
