extends MultiplayerSpawner

var mutiplayer_player_scene: PackedScene = preload("res://MultiPlayerPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var custom_spawn_new_player : Callable = Callable(_spawn_new_player)
	self.spawn_function = custom_spawn_new_player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _spawn_new_player(player_info):
	print("_spawn_new_player in player: ", multiplayer.get_unique_id(), " player id is ", player_info["id"])
	#var spawn_node = main_inst.get_node("SpawnNode")
	#var soawn_node = get_tree().get_current_scene().get_node("SpawnNode")
	#var player_to_add = mutiplayer_player_scene.instantiate()
	
	#var player_nodes = spawn_node.get_children()
	#print("spawn_node len is ", len(player_nodes))
	#print("AddingPlayer for inst ", multiplayer.get_unique_id(), " player len: ", len(player_nodes))
	#if multiplayer.get_unique_id() != 1:
		#spawn_node.global_position.x += 400
		#player_to_add.global_position.x += len(player_nodes) * 400
	var new_player = mutiplayer_player_scene.instantiate()
	new_player.multiplayer_id = player_info["id"]
	#if multiplayer.get_unique_id() != 1:
		#new_player.global_position.x += 400
	return new_player
	
