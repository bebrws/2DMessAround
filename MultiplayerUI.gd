extends Control

# https://www.youtube.com/watch?v=e0JLO_5UgQo

@export var address = "localhost"
@export var port = 8920

var peer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(PlayerConnectedToServer)
	multiplayer.connection_failed.connect(PlayerConnectionFailed)
	
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func StartGame():
	print("Start Game Called")
	var main_scene = load("res://MainScene.tscn").instantiate()
	get_tree().root.add_child(main_scene)
	self.hide()
	
@rpc("any_peer")
func SendPlayerInfo(name, id):
	print("Send Player Info called")
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name": name,
			"id": id,
			"score": 0,
		}
	if multiplayer.is_server():
		for p in GameManager.players:
			SendPlayerInfo.rpc(GameManager.players[p].name, p)
		

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
	GameManager.multiplayer_id = multiplayer.get_unique_id()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_down() -> void:
	StartGame.rpc()


func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: ", error)
		return
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	SendPlayerInfo($Name.text, multiplayer.get_unique_id())
	
	


func _on_join_button_down() -> void:
	print("starting join")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("finished join")
	
