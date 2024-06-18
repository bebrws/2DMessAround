extends Node

var players = {}
var multiplayer_id: int = 1


#var mutiplayer_scene = preload("res://MultiPlayerPlayer.tscn")
#var soawn_node = get_tree().get_current_scene().get_node("SpawnNode")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@rpc("any_peer")
func SendPlayerInfo(name, id):
	print(multiplayer.get_unique_id(), " - Send Player Info called name ", name, " id ", id)
	if multiplayer.get_unique_id() == 1 and !self.players.has(id):
		self.players[id] = {
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
		var s = main.get_node("GameRoot").get_node("MultiplayerSpawner")
		print("from ", multiplayer.get_unique_id(), " spawn ", str(id))
		s.spawn({"id": id})


@rpc("any_peer")
func UpdatePlayersInfo(players_info):
	#print(multiplayer.get_unique_id(), " - Got UpdatePlayersInfo")
	self.players = players_info
	
	
func UpdateAllPlayersInfo():
	#print("Running UpdatePlayersInfo from ", multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == 1:
		for pi in self.players:
			var p = self.players[pi]
			UpdatePlayersInfo.rpc_id(p.id, self.players)
