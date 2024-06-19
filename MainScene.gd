extends Node2D

@export var distance_ignore_gravity: float = 20.0

@export var player_scene: PackedScene
	
var camera: Camera2D
	
# Define the space boundaries and parameters
var planets_width = 10000
var planets_height = 10000
var num_planets = 20
var planets_min_distance = 1000
var planets_max_attempts = 1000
var max_planet_radius = 1000
var min_planet_radius = 200
# Function to check if a position is valid
func is_valid_position(planets, x, y, r):
	for planet in planets:
		if planet.position.distance_to(Vector2(x, y)) < r + 2 * planet.radius:
			return false
	return true

# Generate planet locations
func generate_planet_locations():
	var planets = []
	var attempts = 0

	while len(planets) < num_planets and attempts < planets_max_attempts:
		var x = randi() % planets_width - planets_width/2 
		var y = randi() % planets_height - planets_height/2
		var r = (randi() % max_planet_radius) + min_planet_radius
		
		if is_valid_position(planets, x, y, r):
			planets.append({"position": Vector2(x, y), "radius": r})
			attempts = 0  # Reset attempts after a successful placement
		else:
			attempts += 1

	return planets

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MPIDLabel.text = str(multiplayer.get_unique_id())
	randomize()
	if multiplayer.get_unique_id() == 1:
		camera = Camera2D.new()
		#get_tree().root.
		print(get_tree().root.get_children())
		get_tree().root.get_node("Root").get_node("GameRoot").add_child(camera)
		camera.make_current()
	
		var planets = generate_planet_locations()
		GameManager.planets = planets
		for planet in planets:
			$PlanetSpawner.spawn(planet)
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
		
		if Input.is_action_pressed("ui_up"):
			camera.zoom += Vector2.ONE * 0.1
		if Input.is_action_pressed("ui_down"):
			camera.zoom -= Vector2.ONE * 0.1
		if Input.is_action_just_pressed("ui_accept"):
			#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			camera.position = get_global_mouse_position()
			
		#if Input.is_action_just_pressed("ui_accept"): # or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#$PlanetSpawner.spawn()
		
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
