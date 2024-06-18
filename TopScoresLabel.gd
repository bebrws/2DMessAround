extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var scores: Array = []
	#print("players ", GameManager.players)
	for pi in GameManager.players:
		var p = GameManager.players[pi]
		scores.push_back(p.score)
	scores.sort()
	#print("sorted scores ", scores)
	var scores_str = "Scores:\n"
	var player_count = len(GameManager.players)
	var scores_to_show = 3
	if player_count < 3:
		scores_to_show = player_count
	for i in range(scores_to_show):
		var cur_score = scores.pop_front()
		#print("popped score ", cur_score)
		scores_str += "Score: " + str(cur_score) + "\n"
	#print("scores_str: ", scores_str)
	self.text = scores_str
