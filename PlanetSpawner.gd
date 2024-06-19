extends MultiplayerSpawner

var planet_scene: PackedScene = preload("res://StaticPlanet.tscn")
var planets = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _spawn_callable : Callable = Callable(_spawn)
	self.spawn_function = _spawn_callable
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _spawn(info):
	var p: RigidBody2D = planet_scene.instantiate()
	#p.radius = 500.0
	p.radius = info.radius
	p.position = info.position
	p.mass = p.mass * p.radius / 100.0
	#if len(self.planets) == 0:
		#p.position = Vector2(780, 500)
	#else:
		#p.position = get_viewport().get_mouse_position()
	planets.push_back(p)
	#get_viewport().get_mouse_position()
	#print(get_viewport().get_mouse_position())
	#print("Spawn new planet at ", p.position)
	return p
	
