extends contact
class_name data

var value
var size
var type
var category
var flavor_text

func _ready() -> void:
	add_to_group("contacts")

	var available_types = [
		[1,"Faint signal","Hard to tell if something is really there, but could be worth scanning still."], 
		[5,"Unusual repeated pattern", "Human or otherwise, this appears to be a manufactured signal and worth logging."], 
		[12,"Unmapped radio broadcast", "A transmission that seems to be intentionally broadcast, though uncertain for whom."]
	]
	
	var encountered = available_types.pick_random()
	var v_mod = encountered[0]
	type = encountered[1]
	flavor_text = encountered[2]
	
	# Use the encountered value modifier plus the base range
	value = randi_range(50, 100) * v_mod
	size = randi_range(75, 125)
	category = "data"

func _process(delta: float) -> void:
	
	degrade_signal(0.0, 0.01)
	
	var center = Vector2(820, 315)
	var velocity = Vector2.ZERO # The contact's movement vector.
	var vector_to_center = position - center
	position += (vector_to_center/40) * delta
	
	if position.distance_to(Vector2(820, 315)) > 300:
		self.queue_free()

func isolate():
	$sprite.animation = "isolated"

func deselect():
	$sprite.animation = "default"
