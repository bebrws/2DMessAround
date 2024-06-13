extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_parent())
	self.shape.radius = get_parent().radius
	#self.shape.radius = 10.0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
