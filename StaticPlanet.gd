extends RigidBody2D

@onready var coll_shape: CollisionShape2D = $CircleCollisionShape2D
@onready var planet_sprite: Sprite2D = $PlanetSprite2D

@export var radius: float = 1.0
	#set(r):
		#if coll_shape:
			#print("Updated collision shape radius to ", r)
			#coll_shape.shape.radius = r
		#else:
			#print("Collision Shape not there")
		#radius = r
		
			
#func _draw():
	#draw_circle(Vector2.ZERO, radius, Color.WHITE)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticPlanetSynchronizer.set_multiplayer_authority(1)
	#if coll_shape:
		#print(multiplayer.get_unique_id(), " - Updated collision shape radius to ", radius)
		#coll_shape.shape.radius = radius
	#else:
		#print("Collision Shape not there")
	print("_ready staticplanet radius ", self.radius)
	planet_sprite.scale *= radius / 10.0
	self.mass *= radius / 250.0
	#planet_sprite.transform.get_scale() = planet_sprite.transform.scale * radius
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

