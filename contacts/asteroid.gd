extends contact
class_name asteroid

var value
var size
var type
var category
var flavor_text
var vector_to_center

func _ready():
	add_to_group("contacts")

	var available_types = [
		[1,"Icy surface","The surface appears to be reflect visible light, likely an icy asteroid."], 
		[3,"Metallic core", "This contact has a solid radar signature and high mass, contents are likely metallic."], 
		[10,"Radioactive core", "Picking up readings off the visible spectrum, this one seems to be emitting radiation."]
	]
	
	var encountered = available_types.pick_random()
	var v_mod = encountered[0]
	type = encountered[1]
	flavor_text = encountered[2]
	
	# Use the encountered value modifier plus the base range
	value = randi_range(50, 100) * v_mod
	size = randi_range(100, 150)
	category = "asteroid"
	
	return flavor_text

func _process(delta: float) -> void:
	
	degrade_signal(0.1, 0.001)
	
	var center = Vector2(820, 315)
	var velocity = Vector2.ZERO # The contact's movement vector.
	vector_to_center = position - center
	position += (vector_to_center/25) * delta
	
	if position.distance_to(Vector2(820, 315)) > 300:
		self.queue_free()
