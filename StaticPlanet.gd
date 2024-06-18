extends RigidBody2D


@export var radius: float = 20.0

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticPlanetSynchronizer.set_multiplayer_authority(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
