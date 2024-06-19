extends Node

var planets = []
var players = {}
var multiplayer_id: int = 1

var address = "52.27.195.58"
var port = 8920
var peer := WebSocketMultiplayerPeer.new()

#var mutiplayer_scene = preload("res://MultiPlayerPlayer.tscn")
#var soawn_node = get_tree().get_current_scene().get_node("SpawnNode")

func HostWSServer() -> void:
	print("Detected running as server so starting websocket server:")
	var error = peer.create_server(port)
	if error != OK:
		print("Cannot host: ", error)
		return
	
	multiplayer.set_multiplayer_peer(peer)
	
	GameManager.multiplayer_id = multiplayer.get_unique_id()
	
	var main_scene: PackedScene = load("res://MainScene.tscn")
	var main_inst = main_scene.instantiate()
	get_tree().root.add_child.call_deferred(main_inst)
	
	print("***** CREATED SERVER *****")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("In GameManager Global script")
	if (DisplayServer.get_name() == "headless" or "--headless" in OS.get_cmdline_args() || "--server" in OS.get_cmdline_args() || OS.has_feature("dedicated_server")):
		HostWSServer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



@rpc("any_peer")
func SendDeletePlayerInfo(id):
	print(multiplayer.get_unique_id(), " - Send Delete Player Info id ", id)
	if multiplayer.get_unique_id() == 1:
		self.players.erase(id)
		
	
@rpc("any_peer")
func SendPlayerInfo(name, id):
	print(multiplayer.get_unique_id(), " - Send Player Info called name ", name, " id ", id)
	var name_or_id = name
	if name == "":
		name_or_id = str(id)
	if multiplayer.get_unique_id() == 1 and !self.players.has(id):
		self.players[id] = {
			"name": name_or_id,
			"id": id,
			"score": 0,
			"bullets": [],
		}
		var main = null
		var tree_children = get_tree().root.get_children()
		for tc in tree_children:
			if tc.name == "Root":
				main = tc
		var s = main.get_node("GameRoot").get_node("MultiplayerSpawner")
		print("from ", multiplayer.get_unique_id(), " spawn ", str(id))
		var pi = randi() % len(self.planets)
		var p = self.planets[pi]
		s.spawn({"id": id, "position": Vector2(p.position.x, p.position.y + p.radius)})


@rpc("authority")
func UpdatePlayersInfo(players_info):
	#print(multiplayer.get_unique_id(), " - Got UpdatePlayersInfo")
	self.players = players_info
	
	
func UpdateAllPlayersInfo():
	#print("Running UpdatePlayersInfo from ", multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == 1:
		for pi in self.players:
			var p = self.players[pi]
			UpdatePlayersInfo.rpc_id(p.id, self.players)




