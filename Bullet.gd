extends Area2D

@export var speed: float = 1000.0
@export var direction: Vector2 = Vector2(0.0,0.0)
@export var creator: Node2D = null

func _physics_process(delta):
	position += direction * speed * delta
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("Bulllet collison")
	if body != creator:
		queue_free()
	#if body.is_in_group("mobs"):
		#body.queue_free()
	
