extends Node2D

@export var disance_ignore_gravity: float = 20.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for p in gravs:
		# F = G * m_source * m_body / distance_to_source_center^2
		for op in gravs:
			if p != op && p.global_position.distance_to(op.global_position) > 0.1:
				if p.is_in_group("planet") && op.is_in_group("player"):
					var player_to_planet = p.global_position.distance_to(op.global_position)
					#print(p, "  grav dist   ", player_to_planet)
					if (player_to_planet - (p.radius + op.height_from_distance)) > disance_ignore_gravity:
						var f = (98000 * p.mass * op.mass) / p.position.distance_squared_to(op.position)
						#print("F  ", f, " for planet ", p)
						p.apply_central_impulse(p.position.direction_to(op.position).normalized() * f)
						op.apply_central_impulse(op.position.direction_to(p.position).normalized() * f)
						
					#print("planet  ", p.radius)
				#print("di   ", p.position.distance_squared_to(op.position))
				#var f = (98000 * p.mass * op.mass) / p.position.distance_squared_to(op.position)
				#print("f  ", f)
				#print("Applying ", f, " to ", p, "from ", op)
				#p.apply_central_impulse(p.position.direction_to(op.position).normalized() * f)
				#op.apply_central_impulse(op.position.direction_to(p.position).normalized() * f)
	pass
