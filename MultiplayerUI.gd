extends Control

# https://www.youtube.com/watch?v=e0JLO_5UgQo


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
	multiplayer.server_disconnected.connect(ServerDisconnected)
	


	
func ServerDisconnected():
	print("BEB GOT SERVER DISCONNECTED")
# Gets fired only from clients
func PlayerConnectedToServer(id):
	print("Player connected to server: ", id)

# Gets fired only from clients
func PlayerConnectionFailed(id):
	print("Player connection failed: ", id)
	GameManager.SendDeletePlayerInfo.rpc_id(1, id)
	GameManager.SendDeletePlayerInfo(id)
	
# Gets fired on both server and client
func PlayerDisconnected(id):
	print("Player disconnected: ", id)
	GameManager.SendDeletePlayerInfo.rpc_id(1, id)
	GameManager.SendDeletePlayerInfo(id)

# Gets fired on both server and client
func PlayerConnected(id):
	print("Player connected: ", id)
	GameManager.SendPlayerInfo.rpc_id(1, $Name.text, multiplayer.get_unique_id())
	GameManager.multiplayer_id = multiplayer.get_unique_id()
	



func _process(delta: float) -> void:
	pass



func _on_join_button_down() -> void:
	var address = GameManager.address
	if $Address.text != "":
		address = $Address.text
	var websocket_addr = "ws://" + address  + ":" + str(GameManager.port)
	print("starting join to ", websocket_addr)
	#peer = ENetMultiplayerPeer.new()
	peer.create_client(websocket_addr)
	multiplayer.set_multiplayer_peer(peer)
	print("finished join")
	self.hide()
	get_tree().root.add_child(main_inst)

