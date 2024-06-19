extends Area2D

@export var speed: float = 1000.0
@export var bullet_direction: Vector2 = Vector2(0.0,0.0)
#@export var creator: Node2D = null
@export var shooter_multiplayer_id: int = 1
@export var linear_velocity_length: float = 1.0

func _physics_process(delta):
	position +=  bullet_direction * (speed + linear_velocity_length) * delta
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func _draw() -> void:
	#draw_circle(Vector2.ZERO, 20.0, Color.WHITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.queue_redraw()
	pass


func _on_body_entered(body: Node2D) -> void:
	#print(multiplayer.get_unique_id(), " - Bulllet collison ", body.name, " - body ", body["multiplayer_id"], " shooter ", self.shooter_multiplayer_id)
	if not (body.is_in_group("player") && body.multiplayer_id == self.shooter_multiplayer_id):
		queue_free()
		if body.is_in_group("player") && body.multiplayer_id != self.shooter_multiplayer_id:
			GameManager.players[self.shooter_multiplayer_id].score += 1
	
	
