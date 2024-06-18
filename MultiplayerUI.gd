extends Control

# https://www.youtube.com/watch?v=e0JLO_5UgQo

@export var address = "localhost"
@export var port = 8920
var websocket_addr = "ws://" + address  + ":" + str(port)

var main_scene: PackedScene = preload("res://MainScene.tscn")
var main_inst: Node = null
var mutiplayer_player_scene: PackedScene = preload("res://MultiPlayerPlayer.tscn")

var is_server = false

var server

var peer := WebSocketMultiplayerPeer.new()
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

#@rpc("any_peer", "call_local")
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
	

# SHOULD BE call_remote ?
@rpc("any_peer")
func SendPlayerInfo(name, id):
	print(multiplayer.get_unique_id(), " - Send Player Info called name ", name, " id ", id)
	if multiplayer.get_unique_id() == 1 and !GameManager.players.has(id):
		GameManager.players[id] = {
			"name": name,
			"id": id,
			"score": 0,
			"bullets": [],
		}
		var main = null
		var tree_children = get_tree().root.get_children()
		for tc in tree_children:
			if tc.name == "Root":
				main = tc
		var s = main.get_node("MultiplayerSpawner")
		print("from ", multiplayer.get_unique_id(), " spawn ", str(id))
		s.spawn({"id": id})
	

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
	SendPlayerInfo.rpc_id(1, $Name.text, multiplayer.get_unique_id())
	#SendPlayerInfo.rpc($Name.text, multiplayer.get_unique_id())
	GameManager.multiplayer_id = multiplayer.get_unique_id()
	



func _process(delta: float) -> void:
	pass
	#if is_server:
		#server.poll()

#
#func _on_start_game_button_down() -> void:
	#print("Start Game button down ", multiplayer.get_unique_id())
	##StartGame.rpc()


func _on_host_button_down() -> void:
	is_server = true
	var error = peer.create_server(port)
	if error != OK:
		print("Cannot host: ", error)
		return
	
	multiplayer.set_multiplayer_peer(peer)
	
	GameManager.multiplayer_id = multiplayer.get_unique_id()
	
	self.hide()
	get_tree().root.add_child(main_inst)
	
	print("***** CREATED SERVER *****")
	#SendPlayerInfo($Name.text, multiplayer.get_unique_id())
	


func _on_join_button_down() -> void:
	print("starting join to ", websocket_addr)
	#peer = ENetMultiplayerPeer.new()
	peer.create_client(websocket_addr)
	multiplayer.set_multiplayer_peer(peer)
	print("finished join")
	self.hide()
	get_tree().root.add_child(main_inst)
	SendPlayerInfo($Name.text, multiplayer.get_unique_id())

