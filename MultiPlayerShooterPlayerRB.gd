#@tool
extends RigidBody2D

@export var height_from_distance: float = 90.0
@export var Bullet: PackedScene
@export var move_speed: float = 100000.0
@export var booster_speed: float = 5.0
@export var facing_right = true

var last_shot_time: int = 0

@export var multiplayer_id: int = 1:
	set(id):
		print("Setting synchronizer & multiplayer_id to ", id)
		multiplayer_id = id
		$PlayerSynchronizer.set_multiplayer_authority(id)
		
@onready var camera: Camera2D = $Camera2D

@onready var rbfn: Node2D = $RBFootNode
@onready var rbhn: Node2D = $RBHeadNode

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fn: Node2D = $AnimatedSprite2D/FootNode
@onready var hn: Node2D = $AnimatedSprite2D/HeadNode
@onready var cn: Node2D = $AnimatedSprite2D/CenterNode
@onready var ln: Node2D = $AnimatedSprite2D/LeftNode
@onready var rn: Node2D = $AnimatedSprite2D/RightNode

func calculate_gravity_force() -> Vector2:
	var sum := Vector2.ZERO
	var gravs = self.get_tree().get_nodes_in_group("has_gravity")
	for body in gravs:
		if (self != body):
			var f = self.position.direction_to(body.position).normalized() * (98000 * self.mass * body.mass) / self.position.distance_squared_to(body.position)
			sum += f
	var gravity: Vector2 = self.mass * sum
	return gravity

func _draw():
	var gravity = calculate_gravity_force()
	
	draw_line(Vector2.ZERO, Vector2.ZERO + (gravity * 100.0), Color.GREEN)
	draw_line(Vector2.ZERO, (self.global_position.direction_to(get_global_mouse_position()).normalized() * -400.0), Color.RED)
	
	var fn: Node2D = $AnimatedSprite2D/FootNode
	var hn: Node2D = $AnimatedSprite2D/HeadNode
	
	draw_line(Vector2.ZERO, Vector2.ZERO + (gravity.orthogonal().normalized().rotated(deg_to_rad(-30)) * 200.0), Color.ORANGE)
	draw_line(Vector2.ZERO, Vector2.ZERO + (gravity.orthogonal().normalized().rotated(deg_to_rad(-30)).rotated(deg_to_rad(180)) * 200.0), Color.CORAL)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$InputSynchronizer.root_path = $"../../"
	
	$Label.text = str(self.multiplayer_id)
	if self.multiplayer_id == multiplayer.get_unique_id():
		camera.enabled = true
	else:
		camera.enabled = false
	#camera = get_node("../Camera2D")
	sprite.rotate(deg_to_rad(180))

@rpc("any_peer")
func _shoot_bullet(from_id, bullet_direction, position, linear_velocity):
	#print("mpid ", multiplayer.get_unique_id(), " shooting for ", from_id, " pos ", position)
	if last_shot_time + 100 < Time.get_ticks_msec():
		last_shot_time = Time.get_ticks_msec()
		#var main = get_tree().root.get_children()[3]
		#var s = main.get_node("BulletSpawner")
		var s = $"../BulletSpawner"
		s.spawn({"from_id": from_id, "bullet_direction": bullet_direction, "position": position, "linear_velocity": linear_velocity})
	
	
func _process(delta: float) -> void:
	self.queue_redraw()
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
	#print("self: ", self.multiplayer_id, " GameManager ", GameManager.multiplayer_id)
	#if self.multiplayer_id == GameManager.multiplayer_id:
	if self.multiplayer_id == multiplayer.get_unique_id():
		camera.global_position = self.global_position
			
	var f2h = rbfn.global_position.direction_to(rbhn.global_position)
	var f2d = calculate_gravity_force()
	#var p = get_tree().get_nodes_in_group("has_gravity")[0]
	#var gv = fn.global_position.direction_to(p.global_position)
	var gv = rbfn.global_position.direction_to(rbfn.global_position + f2d)
	
	#print("f2h ", f2h, " gv  ", gv)
	
	var r = f2h.angle_to(gv)
	#print(r)
	#sprite.rotate(r)
	sprite.set_rotation(r + deg_to_rad(180))
	
	

	if self.multiplayer_id == multiplayer.get_unique_id():		
		var force_to_gravity = f2d.normalized() * 30.0
		var on_ground = false
		var planets = self.get_tree().get_nodes_in_group("planet")
		for p in planets:
			var player_to_planet = self.global_position.distance_to(p.global_position) 
			#print("if state   ", (player_to_planet - (p.radius + self.height_from_distance)))
			if (player_to_planet - (p.radius + self.height_from_distance)) <= 25.0:
				on_ground = true
		#print("on_ground  ", on_ground)

		
		#if on_ground && Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_right"):
			facing_right = true
			sprite.set_flip_h(false)
			#var f = force_to_gravity.orthogonal().normalized() * delta * 100000.0
			var f = cn.global_position.direction_to(rn.global_position) * delta * move_speed
			#print("right f ", f)
			#print("rot ", sprite.rotation_degrees)
			self.apply_central_force(f)
			
		#if on_ground && Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_left"):
			facing_right = false
			sprite.set_flip_h(true)
			#var f = force_to_gravity.orthogonal().rotated(deg_to_rad(180)).normalized() * delta * 100000.0
			var f = cn.global_position.direction_to(ln.global_position) * delta * move_speed
			#print("left f ", f)
			#print("rot ", sprite.rotation_degrees)
			self.apply_central_force(f)
		
		if Input.is_action_pressed("ui_up"):
			var f = cn.global_position.direction_to(hn.global_position) * delta * move_speed * booster_speed
			#print("up f ", f)
			self.apply_central_force(f)
			#self.linear_velocity += (self.global_position.direction_to(get_global_mouse_position()).normalized() * 50.0)
		if Input.is_action_pressed("ui_down"):
			var f = cn.global_position.direction_to(fn.global_position) * delta * move_speed * booster_speed
			#print("down f ", f)
			self.apply_central_force(f)
			#self.linear_velocity -= (self.global_position.direction_to(get_global_mouse_position()).normalized() * 50.0)
			
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#print("shoot")
			var bullet_direction = self.global_position.direction_to(get_global_mouse_position()).normalized()
			if multiplayer.get_unique_id() != 1:
				_shoot_bullet.rpc_id(1, self.multiplayer_id, bullet_direction, self.position, self.linear_velocity)
			else:
				_shoot_bullet(1, bullet_direction, self.position, self.linear_velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	#self.linear_velocity = Vector2.ZERO
	#self.constant_force = Vector2.ZERO
	#self.constant_torque = 0.0
	pass

func RemoveFromGame():
	queue_free()
