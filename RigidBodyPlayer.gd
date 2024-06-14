@tool
extends RigidBody2D

@export var speed: float = 5.0
@export var radius: float = 20.0


func _draw():
	draw_circle(Vector2.ZERO, radius, Color.ORANGE)	
	
	#print("mouse", get_global_mouse_position())
	#print("pos", self.global_position)
	
	var impulse : Vector2 = ((get_global_mouse_position() - self.global_position).normalized() * speed * 100.0) #.rotated(self.rotation_degrees)
	#var impulse = self.global_position.direction_to(get_global_mouse_position())
	#var impulse = dir_to.rotated(dir_to.angle()) * speed

	#draw_line(self.position, impulse, Color.BLUE_VIOLET)
	draw_line(Vector2.ZERO, (Vector2.ZERO + impulse), Color.WHITE)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.notification(NOTIFICATION_DRAW)
	self.queue_redraw()
	#var impulse = self.position.direction_to(get_global_mouse_position()).normalized() * speed
	var impulse : Vector2 = (get_global_mouse_position() - self.position).normalized() * speed
	#DebugDraw3D.draw_line(Vector3(self.position.x, self.position.y, 1.0), Vector3(impulse.x, impulse.y, 1.0), Color(1, 1, 0))
	#DebugDraw3D.draw_line(Vector3(0.0, 0.0, 0.0), Vector3(100.0, 100.0, 0.0), Color(1, 0, 0))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print("position", self.position)
		#print("impulse", impulse)
		#self.linear_velocity = Vector2(0.0, 0.0)
		self.apply_central_impulse(impulse)
		#self.apply_central_force(impulse)
	pass
