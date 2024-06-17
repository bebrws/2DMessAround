extends Control

# https://www.youtube.com/watch?v=e0JLO_5UgQo

@export var address = "localhost"
@export var port = 8920

var main_scene: PackedScene = preload("res://MainScene.tscn")
var main_inst: Node = null
var mutiplayer_player_scene: PackedScene = preload("res://MultiPlayerPlayer.tscn")


var peer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_inst = main_scene.instantiate()
	#get_tree().root.add_child(main_inst)
	
	#get_tree().root.add_child(main_inst)
	
	#var soawn_node = main_inst.get_node("SpawnNode")
	#var player_to_add = mutiplayer_player_scene.instantiate()
	#player_to_add.multiplayer_id = multiplayer.get_unique_id()
	#main_inst.add_child(player_to_add)
	
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(PlayerConnectedToServer)
	multiplayer.connection_failed.connect(PlayerConnectionFailed)

@rpc("any_peer", "call_local")
func StartGame():
	print("Start Game Called ", multiplayer.get_unique_id())
	self.hide()
	get_tree().root.add_child(main_inst)
	var main = get_tree().root.get_children()[3]
	print(main)
	for p in GameManager.players:
		var s = main.get_node("MultiplayerSpawner")
		print(s)
		print("from ", multiplayer.get_unique_id(), " spawn ", str(GameManager.players[p].id))
		s.spawn({"id": GameManager.players[p].id})
	
	#main_inst.owner = get_tree().root
	#main_inst.show()
	#get_tree().root.add_child(main_inst)
	#var first_child = get_tree().root.get_child(1)
	#first_child.show()
	#get_tree().root.get_child()
	
@rpc("any_peer")
func SendPlayerInfo(name, id):
	print(multiplayer.get_unique_id(), " - Send Player Info called name ", name, " id ", id)
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name": name,
			"id": id,
			"score": 0,
			"bullets": [],
		}
	#if multiplayer.is_server():
	#for p in GameManager.players:
		#SendPlayerInfo.rpc(GameManager.players[p].name, p)
		

# Gets fired only from clients
func PlayerConnectedToServer(id):
	print("Player connected to server: ", id)

# Gets fired only from clients
func PlayerConnectionFailed(id):
	print("Player connection failed: ", id)

# Gets fired on both server and client
func PlayerDisconnected(id):
	print("Player disconnected: ", id)

# Gets fired on both server and client
func PlayerConnected(id):
	print("Player connected: ", id)
	var s = main_inst.get_node("MultiplayerSpawner")
	main_inst.get_node("MultiplayerSpawner").spawn({"id": id})
	#SendPlayerInfo.rpc_id(1, $Name.text, id)
	#SendPlayerInfo.rpc_id(1, $Name.text, multiplayer.get_unique_id())
	SendPlayerInfo.rpc($Name.text, multiplayer.get_unique_id())
	#GameManager.multiplayer_id = multiplayer.get_unique_id()
	#_add_player_to_game(id)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_down() -> void:
	print("Start Game button down ", multiplayer.get_unique_id())
	StartGame.rpc()


func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: ", error)
		return
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("BEBWaiting for players")
	SendPlayerInfo($Name.text, multiplayer.get_unique_id())
	#_add_player_to_game(multiplayer.get_unique_id())
	var s = main_inst.get_node("MultiplayerSpawner")
	
	main_inst.get_node("MultiplayerSpawner").spawn({"id": 1})
	
	


func _on_join_button_down() -> void:
	print("starting join")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("finished join")
	SendPlayerInfo($Name.text, multiplayer.get_unique_id())
	#_add_player_to_game(multiplayer.get_unique_id())
	main_inst.get_node("MultiplayerSpawner").spawn({"id": multiplayer.get_unique_id()})
	

func _add_player_to_game(id):
	print("** plyaer id: ", multiplayer.get_unique_id(), " _add_player_to_game for id: ", id)
	var spawn_node = main_inst.get_node("SpawnNode")
	#var soawn_node = get_tree().get_current_scene().get_node("SpawnNode")
	var player_to_add = mutiplayer_player_scene.instantiate()
	
	var player_nodes = spawn_node.get_children()
	print("spawn_node len is ", len(player_nodes))
	print("AddingPlayer for inst ", multiplayer.get_unique_id(), " player len: ", len(player_nodes))
		
	
	player_to_add.multiplayer_id = id # multiplayer.get_unique_id()
	spawn_node.add_child(player_to_add, true)
	for p in player_nodes:
		print("!!** Player id: ", p.multiplayer_id, " added to player inst: ", multiplayer.get_unique_id())
