extends Node2D

func _draw():
	var ps = get_tree().get_nodes_in_group("player")
	var max_x = 0;
	var max_y = 0;
	for p in ps:
		if p.position.x > max_x:
			max_x = p.position.x
		if p.position.y > max_y:
			max_y = p.position.y
	
	var vs = get_viewport().get_visible_rect().size
	
	var sf = 0.10
	var vs_size = vs * sf
	var vs_rect = Rect2(-vs.x,-vs.y,vs_size.x,vs_size.y)
	draw_rect(vs_rect, Color.GREEN)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.queue_redraw()
	pass
