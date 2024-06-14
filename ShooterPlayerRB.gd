#@tool
extends RigidBody2D

func calculate_gravity_force() -> Vector2:
	var sum := Vector2.ZERO
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for body in gravs:
		if (self != body):
			#print(body))
			var f = self.position.direction_to(body.position).normalized() * (98000 * self.mass * body.mass) / self.position.distance_squared_to(body.position)
			draw_line(Vector2.ZERO, (self.position.direction_to(body.position)).normalized() * 800.0, Color.YELLOW)
			#rotated(deg_to_rad(rotation_degrees))
			#print(body, f)
			sum += f
	var gravity: Vector2 = self.mass * sum
	return gravity

func _draw():
	var f2d = calculate_gravity_force()
	draw_line(Vector2.ZERO, Vector2.ZERO + f2d * 100.0, Color.GREEN)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.queue_redraw()
	#print(self.rotation_degrees)
	#print(calculate_gravity_force())
	#self.rotate((deg_to_rad(self.rotation_degrees)))
	var head = Vector2(self.position.x, self.position.y + 180)
	var f2d = calculate_gravity_force()
	self.set_rotation(head.angle_to(f2d) + (300*PI/180))
	pass
