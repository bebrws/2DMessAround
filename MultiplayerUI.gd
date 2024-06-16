extends Control

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_down() -> void:
	pass # Replace with function body.


func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: ", error)
		return
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	
	


func _on_join_button_down() -> void:
	print("starting join")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("finished join")
	
