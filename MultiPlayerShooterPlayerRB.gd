#@tool
extends RigidBody2D

@export var height_from_distance: float = 90.0
@export var Bullet: PackedScene

@export var facing_right = true


@export var multiplayer_id: int = 1:
	set(id):
		print("Setting synchronizer & multiplayer_id to ", id)
		multiplayer_id = id
		$PlayerSynchronizer.set_multiplayer_authority(id)
		


@onready var camera: Camera2D = $Camera2D


func calculate_gravity_force() -> Vector2:
	var sum := Vector2.ZERO
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for body in gravs:
		if (self != body):
			#print(body))
			#var f = self.position.direction_to(body.position).normalized() * (98000 * self.mass * body.mass) / self.position.distance_squared_to(body.position)
			var f = self.position.direction_to(body.position).normalized() * (98000 * self.mass * body.mass) / self.position.distance_to(body.position)
			#draw_line(Vector2.ZERO, (self.position.direction_to(body.position)).normalized() * 800.0, Color.YELLOW)
			#rotated(deg_to_rad(rotation_degrees))
			#print(body, f)
			sum += f
	var gravity: Vector2 = self.mass * sum
	return gravity

func _draw():
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
	var gravity = calculate_gravity_force()
	
	draw_line(Vector2.ZERO, Vector2.ZERO + (gravity * 100.0), Color.GREEN)
	draw_line(Vector2.ZERO, (self.global_position.direction_to(get_global_mouse_position()).normalized() * -400.0), Color.RED)
	
	var fn: Node2D = $FootNode
	var hn: Node2D = $HeadNode
	
	var f2h = fn.position.direction_to(hn.position)
	draw_line(Vector2.ZERO, Vector2.ZERO + f2h * 200.0, Color.ORANGE)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$InputSynchronizer.root_path = $"../../"
	
	$Label.text = str(self.multiplayer_id)
	if self.multiplayer_id == multiplayer.get_unique_id():
		camera.enabled = true
	else:
		camera.enabled = false
	#camera = get_node("../Camera2D")
	$AnimatedSprite2D.rotate(deg_to_rad(180))
	#print("Setting Multiplayer synch for id: ", multiplayer_id)
	#$MultiplayerSynchronizer.set_multiplayer_authority(multiplayer_id)
	#if self.multiplayer_id == GameManager.multiplayer_id:
		#var remote_transform_2d = RemoteTransform2D.new()
		#remote_transform_2d.remote_path = NodePath("../Camera2D")
		#remote_transform_2d.position = Vector2(1200, 1200)
		#add_child(remote_transform_2d)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func _integrate_forces(state: PhysicsDirectBodyState2D):
	self.queue_redraw()
	
	if self.multiplayer_id == multiplayer.get_unique_id():
		#print(self.rotation_degrees)
		#print(calculate_gravity_force())
		#self.rotate((deg_to_rad(self.rotation_degrees)))
		
		var f2d = calculate_gravity_force()

		#print(r)
		#self.rotate(head.angle_to(f2d))
		#if r > 0.3:
			#sprite.rotate(r)
		#sprite.set_rotation(r)
		#print(self.get_angle_to(f2d) + deg_to_rad(180))
		#self.position
		
		#var imp = f2d.rotated(head.angle_to(f2d) + deg_to_rad(330))
		var force_to_gravity = f2d.normalized() * 30.0
		#print(f2d)
		var on_ground = false
		var planets = self.get_tree().get_nodes_in_group("planet")
		for p in planets:
			var player_to_planet = self.global_position.distance_to(p.global_position) 
			#print("if state   ", (player_to_planet - (p.radius + self.height_from_distance)))
			if (player_to_planet - (p.radius + self.height_from_distance)) <= 25.0:
				on_ground = true
		#print("on_ground  ", on_ground)
		var sprite: AnimatedSprite2D = $AnimatedSprite2D
		var cn: Node2D = $CenterNode
		var ln: Node2D = $LeftNode
		var rn: Node2D = $RightNode
		
		if on_ground && Input.is_action_pressed("ui_right"):
			facing_right = true
			sprite.set_flip_h(false)
			self.linear_velocity += force_to_gravity
			#self.linear_velocity += (0.5 * force_to_gravity).rotated(deg_to_rad(90.0)) #.orthogonal()
			self.linear_velocity += force_to_gravity.orthogonal()
			print("left  ", force_to_gravity.orthogonal())
			#self.apply_force(force_to_gravity)
			#self.apply_force(force_to_gravity.orthogonal())
			#self.linear_velocity
			#self.apply_central_impulse(imp)
		if on_ground && Input.is_action_pressed("ui_left"):
			facing_right = false
			sprite.set_flip_h(true)
			print("flip_v   ", sprite.flip_v)
			self.linear_velocity += force_to_gravity.orthogonal().rotated(deg_to_rad(180))
			print("right  ", force_to_gravity.orthogonal().rotated(deg_to_rad(180)))
			#self.apply_central_impulse(-imp)		
			pass
		if Input.is_action_pressed("ui_up"):
			self.linear_velocity += (self.global_position.direction_to(get_global_mouse_position()).normalized() * 50.0)
		if Input.is_action_pressed("ui_down"):
			self.linear_velocity -= (self.global_position.direction_to(get_global_mouse_position()).normalized() * 50.0)
			
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#print("shoot")
			var bullet_direction = self.global_position.direction_to(get_global_mouse_position()).normalized()
			if multiplayer.get_unique_id() != 1:
				_shoot_bullet.rpc_id(1, self.multiplayer_id, bullet_direction, self.position)
			else:
				_shoot_bullet(1, bullet_direction, self.position)
		
		#if InputEventMouse.
			#print(self.get_tree().get_nodes_in_group("camera"))
			#var camera: Camera2d = self.get_tree().get_nodes_in_group("camera")[0]
			#camera.get_viewport().set_zoom(Vector2(camera.get_viewport().zoom.x + 0.1, camera.get_viewport().zoom.y + 0.1))
		#print("player angular  ", self.angular_velocity)
		self.angular_velocity = 0.0

@rpc("any_peer")
func _shoot_bullet(from_id, bullet_direction, position):
	print("mpid ", multiplayer.get_unique_id(), " shooting for ", from_id, " pos ", position)
	var main = get_tree().root.get_children()[3]
	var s = main.get_node("BulletSpawner")
	s.spawn({"from_id": multiplayer.get_unique_id(), "bullet_direction": bullet_direction, "position": position})
	
	
func _process(delta: float) -> void:
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
	#print("self: ", self.multiplayer_id, " GameManager ", GameManager.multiplayer_id)
	#if self.multiplayer_id == GameManager.multiplayer_id:
	if self.multiplayer_id == multiplayer.get_unique_id():
		camera.global_position = self.global_position
		
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	var fn: Node2D = $FootNode
	var hn: Node2D = $HeadNode
	
	var f2h = fn.global_position.direction_to(hn.global_position)
	var f2d = calculate_gravity_force()
	#var p = get_tree().get_nodes_in_group("has_gravity")[0]
	#var gv = fn.global_position.direction_to(p.global_position)
	var gv = fn.global_position.direction_to(fn.global_position + f2d)
	
	#print("f2h ", f2h, " gv  ", gv)
	
	var r = f2h.angle_to(gv)
	#print(r)
	#sprite.rotate(r)
	sprite.set_rotation(r + deg_to_rad(180))
