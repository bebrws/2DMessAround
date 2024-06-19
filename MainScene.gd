extends Node2D

@export var distance_ignore_gravity: float = 20.0

@export var player_scene: PackedScene
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MPIDLabel.text = str(multiplayer.get_unique_id())
	#$MultiplayerSpawner.spawn({"id": 1})
	#for p in GameManager.players:
		#var current_player = player_scene.instantiate()
		#current_player.multiplayer_id = GameManager.players[p].id
		#add_child(current_player)
		#var spawn_point = $SpawnPoint
		#current_player.global_position = spawn_point.global_position
		#
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if multiplayer.get_unique_id() == 1:
		GameManager.UpdateAllPlayersInfo()
		
		if Input.is_action_just_pressed("ui_accept"): # or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$PlanetSpawner.spawn()
		
	#if get_multiplayer_authority() == multiplayer.get_unique_id():
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for p in gravs:
		# F = G * m_source * m_body / distance_to_source_center^2
		for op in gravs:
			if p != op && p.global_position.distance_to(op.global_position) > 0.1:
				if p.is_in_group("planet") && op.is_in_group("player"):
					#if GameManager.multiplayer_id == op.multiplayer_id:
					if true:
					#if get_multiplayer_authority() == multiplayer.get_unique_id():
						var player_to_planet = p.global_position.distance_to(op.global_position)
						#print(p, "  grav dist   ", player_to_planet)
						if (player_to_planet - (p.radius + op.height_from_distance)) > distance_ignore_gravity:
							var f = delta * (980000000 * p.mass * op.mass) / p.position.distance_squared_to(op.position)
							#var f = delta * (98000 * p.mass * op.mass) / p.position.distance_to(op.position)
							
							# Dont move plnaet to help with jitter?
							#if GameManager.multiplayer_id == 1:
								#p.apply_central_impulse(p.position.direction_to(op.position).normalized() * f)
							if GameManager.multiplayer_id == op.multiplayer_id:
								#print("F  ", f, " for player ", op)
								#op.apply_central_impulse(op.position.direction_to(p.position).normalized() * f)
								op.apply_central_force(op.position.direction_to(p.position).normalized() * f)
						#if (player_to_planet - (p.radius + op.height_from_distance)) < distance_ignore_gravity:
							#p.position
						#else:
							#if GameManager.multiplayer_id == op.multiplayer_id:
								#p.distance_to(op).
						#print("planet  ", p.radius)
					#print("di   ", p.position.distance_squared_to(op.position))
					#var f = (98000 * p.mass * op.mass) / p.position.distance_squared_to(op.position)
					#print("f  ", f)
					#print("Applying ", f, " to ", p, "from ", op)
					#p.apply_central_impulse(p.position.direction_to(op.position).normalized() * f)
					#op.apply_central_impulse(op.position.direction_to(p.position).normalized() * f)
