extends contact
class_name object

var value
var size
var type
var category
var flavor_text

func _ready() -> void:
	add_to_group("contacts")

	var available_types = [
		[1,"Scrap","Signals indicative of space junk. Might be something left by scavangers.  Maybe."], 
		[3,"Derelict satellite", "This satellite isn't in the logs anywhere, perhaps there's something to salvage from it."], 
		[15,"Abandoned cargo", "Signs of bundled cargo left adrift, could be worth a pretty penny."]
	]
	
	var encountered = available_types.pick_random()
	var v_mod = encountered[0]
	type = encountered[1]
	flavor_text = encountered[2]
	
	# Use the encountered value modifier plus the base range
	value = randi_range(50, 100) * v_mod
	size = randi_range(100, 150)
	category = "object"

func _process(delta: float) -> void:
	
	var center = Vector2(820, 315)
	var velocity = Vector2.ZERO # The contact's movement vector.
	var vector_to_center = position - center
	position += (vector_to_center/35) * delta
	
	if position.distance_to(Vector2(820, 315)) > 300:
		self.queue_free()

func isolate():
	$sprite.animation = "isolated"

func deselect():
	$sprite.animation = "default"
