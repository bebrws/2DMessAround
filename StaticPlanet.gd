extends RigidBody2D

@onready var coll_shape: CollisionShape2D = $CircleCollisionShape2D

@export var radius: float = 20.0
	#set(r):
		#if coll_shape:
			#print("Updated collision shape radius to ", r)
			#coll_shape.shape.radius = r
		#else:
			#print("Collision Shape not there")
		#radius = r
		
			
func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticPlanetSynchronizer.set_multiplayer_authority(1)
	if coll_shape:
		print(multiplayer.get_unique_id(), " - Updated collision shape radius to ", radius)
		coll_shape.shape.radius = radius
	else:
		print("Collision Shape not there")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

