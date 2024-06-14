extends Node2D

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for p in gravs:
		# F = G * m_source * m_body / distance_to_source_center^2
		for op in gravs:
			if p != op:
				var f = (98000 * p.mass * op.mass) / p.position.distance_squared_to(op.position)
				#print("Applying ", f, " to ", p, "from ", op)
				p.apply_central_impulse(p.position.direction_to(op.position).normalized() * f)
				op.apply_central_impulse(op.position.direction_to(p.position).normalized() * f)
	pass
