extends CanvasLayer



#func _draw():
	#var ps = get_tree().get_nodes_in_group("player")
	#var max_x = 0;
	#var max_y = 0;
	#for p in ps:
		#if p.position.x > max_x:
			#max_x = p.position.x
		#if p.position.y > max_y:
			#max_y = p.position.y
	#
	#var vs = get_viewport().get_visible_rect().size
	#
	#var sf = 0.10
	#var vs_size = vs * sf
	#var vs_rect = Rect2(0,0,vs_size.x,vs_size.y)
	#draw_rect(vs_rect, Color.GREEN)
	#var sum := Vector2.ZERO
	#var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	#for body in gravs:
		#if (self != body):
			##print(body))
			#var f = self.global_position.direction_to(body.position).normalized() * (98000 * self.mass * body.mass) / self.global_position.distance_squared_to(body.position)
			#draw_line(Vector2.ZERO, (self.global_position.direction_to(body.position)).normalized() * 800.0, Color.YELLOW)
			##rotated(deg_to_rad(rotation_degrees))
			##print(body, f)
			#sum += f
	#var gravity: Vector2 = self.mass * sum
	#var gravity = calculate_gravity_force()
	#
	#draw_line(Vector2.ZERO, Vector2.ZERO + (gravity * 100.0), Color.GREEN)
	#draw_line(Vector2.ZERO, (self.global_position.direction_to(get_global_mouse_position()).normalized() * -400.0), Color.RED)
	#
	#var fn: Node2D = $FootNode
	#var hn: Node2D = $HeadNode
	#
	#var f2h = fn.position.direction_to(hn.position)
	#draw_line(Vector2.ZERO, Vector2.ZERO + f2h * 200.0, Color.ORANGE)
	#
	#pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
