extends Control

@export var player_name: String

var score: int = 0
var current_player_rank: int = -1

var leaderboard_data = [
	{ "name": "Player", "score": 11567 }, 
	{ "name": "ReadyToDeliver", "score": 5759 }, 
	{ "name": "Wartle", "score": 4610 }, 
	{ "name": "Test", "score": 3965 }, 
	{ "name": "BANTUL", "score": 3734 }, 
	{ "name": "tes", "score": 3375 }, 
	{ "name": "FSTVLST", "score": 2722 }, 
	{ "name": "aliran", "score": 2494 }, 
	{ "name": "BAHLIL", "score": 1715 }, 
	{ "name": "sasd", "score": 1599 }, 
	{ "name": "Altsen", "score": 1381 }, 
	{ "name": "Ahdan", "score": 1235 }, 
	{ "name": "Khabib", "score": 1184 }, 
	{ "name": "Ris", "score": 1097 }, 
	{ "name": "HDR", "score": 1059 }, 
	{ "name": "embut", "score": 1032 }, 
	{ "name": "Budi", "score": 987 }, 
	{ "name": "Wong Kok Mendo", "score": 829 }, 
	{ "name": "Dirra", "score": 516 }, 
	{ "name": "aa", "score": 412 }, 
	{ "name": "tesaaa", "score": 154 }, 
	{ "name": "Rasyid", "score": 149 }, 
	{ "name": "Daffa", "score": 119 }
]



func _process(delta: float) -> void:
	update_live_leaderboard()

func _ready() -> void:
	update_live_leaderboard()
	add_score()

func add_score():
	while true:
		await get_tree().create_timer(0.1).timeout
		score += 10 

func update_live_leaderboard() -> void:
	var live_data = []
	
	var current_name = player_name
	var current_score = score
	
	var player_has_history = false
	var history_score = 0

	for entry in leaderboard_data:
		if entry["name"] == current_name:
			player_has_history = true
			history_score = entry["score"]
		else:
			live_data.append({"name": entry["name"], "score": entry["score"], "type": "normal"})
			
	if player_has_history:
		if current_score >= history_score:
			live_data.append({"name": current_name, "score": current_score, "type": "active"})
		else:
			live_data.append({"name": current_name + " (Best)", "score": history_score, "type": "history"})
			live_data.append({"name": current_name, "score": current_score, "type": "active"})
	else:
		live_data.append({"name": current_name, "score": current_score, "type": "active"})
		
	live_data.sort_custom(func(a, b): return a["score"] > b["score"])
	
	
	var active_index = 0
	
	for i in range(live_data.size()):
		if live_data[i]["type"] == "active":
			active_index = i
			break

	var max_display = 4
	var indices_to_show = []

	if live_data.size() <= max_display:
		for i in range(live_data.size()):
			indices_to_show.append(i)
	else:
		indices_to_show.append(0) 

		var slots_left = max_display - 1
		var bottom_index = min(active_index + 1, live_data.size() - 1)
		var top_index = bottom_index - slots_left + 1

		if top_index <= 0:
			top_index = 1
			bottom_index = top_index + slots_left - 1

		for i in range(top_index, bottom_index + 1):
			indices_to_show.append(i)


	var text_output = "[center][b]LEADERBOARD[/b][/center]\n"
	var new_player_rank = -1
	var previous_index = -1
	
	for i in indices_to_show:
		var entry = live_data[i]
		var rank = i + 1
		
		if previous_index != -1 and i - previous_index > 1:
			text_output += "[center][color=gray] .  .  . [/color][/center]\n"
		
		if entry["type"] == "active":
			new_player_rank = rank
			text_output += "[wave amp=10 freq=4][color=gold][b]" + str(rank) + ". > " + entry["name"] + " : " + str(entry["score"]) + " <[/b][/color][/wave]\n"
		elif entry["type"] == "history":
			text_output += "[color=cyan]" + str(rank) + ". " + entry["name"] + " : " + str(entry["score"]) + "[/color]\n"
		else:
			text_output += "[color=white]" + str(rank) + ". " + entry["name"] + " : " + str(entry["score"]) + "[/color]\n"
			
		previous_index = i
		
	if current_player_rank != -1 and new_player_rank != -1 and new_player_rank < current_player_rank:
		_on_player_overtake(new_player_rank)
		
	current_player_rank = new_player_rank
		
	if has_node("LeaderboardLabel"):
		$LeaderboardLabel.text = text_output


func _on_player_overtake(new_rank: int) -> void:
	if has_node("LeaderboardLabel"):
		var label = $LeaderboardLabel
		
		label.pivot_offset = label.size / 2.0
		
		var tween = create_tween()
		tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
