extends CollisionShape2D

#@export var shape: Shape2D 

#func _draw():
	#print("draw shape radius ", self.shape.radius, " parent raidus ", get_parent().radius)
	#draw_circle(Vector2.ZERO, self.shape.radius, Color.WHITE)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(self.get_parent())
	self.shape.radius = get_parent().radius
	#self.shape.radius = 10.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.shape.radius = get_parent().radius
	#print("_process shape radius ", self.shape.radius, " parent raidus ", get_parent().radius)
	#self.queue_redraw()
	pass

