extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _sort_by_score(p1, p2):
	if p1.score > p2.score:
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var players: Array = []
	#print("players ", GameManager.players)
	for pi in GameManager.players:
		var p = GameManager.players[pi]
		players.push_back(p)
	players.sort_custom(Callable(_sort_by_score))
	#print("sorted scores ", scores)
	var scores_str = "Scores:\n"
	var player_count = len(GameManager.players)
	var scores_to_show = 3
	if player_count < 3:
		scores_to_show = player_count
	for i in range(scores_to_show):
		var cur_player = players.pop_front()
		#print("popped score ", cur_score)
		scores_str += cur_player.name + " score: " + str(cur_player.score) + "\n"
	#print("scores_str: ", scores_str)
	self.text = scores_str
