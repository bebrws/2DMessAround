#@tool
extends ColorRect

var w: float
var h: float
@export var radius_divisor: float = 20.0

func _draw():
	
	var ps = get_tree().get_nodes_in_group("player")
	var max_x = 0
	var max_y = 0
	var min_x = 0
	var min_y = 0
	#var max_d = 0
	for p in ps:
		if p.position.x > max_x:
			max_x = p.position.x
		if p.position.y > max_y:
			max_y = p.position.y
		if p.position.x < min_x:
			min_x = p.position.x
		if p.position.y < min_y:
			min_y = p.position.y			

	var dist_y = max_y - min_y
	var dist_x = max_x - min_x
	#var dvec = Vector2(dist_x, dist_y)
	#print("dist ", dvec)
	for p in ps:
		var x = (p.position.x / dist_x) * (w/2) + (w/2)
		var y = (p.position.y / dist_y) * (h/2) + (h/2)
		var cc = Vector2(x,y)
		#print("Draw circle ", cc, " for pos ", p.position)
		draw_circle(cc, w/radius_divisor, Color.RED)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	w = self.size.x
	h = self.size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.queue_redraw()
