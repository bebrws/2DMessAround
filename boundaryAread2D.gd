@tool
extends Area2D

@onready var cs: CollisionShape2D = $BoundaryCollisionShape2D

@export var width: float = 10.0:
	set(v):
		width = v
		cs.shape.size.x = v
@export var height: float = 10.0:
	set(v):
		height = v
		cs.shape.size.y = v

func _draw() -> void:
	var w = cs.shape.size.x
	var h = cs.shape.size.y
	var r: Rect2 = Rect2(-w/2,-h/2,w,h)
	draw_rect(r,Color.BLACK)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cs.shape.size.x = width
	cs.shape.size.y = width


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.queue_redraw()
	pass