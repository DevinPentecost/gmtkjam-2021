extends Node2D
signal game_complete

onready var player = $Walker
onready var total_targets = get_tree().get_nodes_in_group("goal").size()
onready var gui = $GUI

var progress = 0
var steps = 0
var hits = 0
var time = 0
var game_complete = false

func _process(delta):
	if not game_complete:
		time += delta
		gui.refresh_time(time)

func get_current_targets():
	var goals = get_tree().get_nodes_in_group("goal")
	var remaining = goals.size()
	if remaining == 0:
		game_complete = true
		emit_signal("game_complete")
	return remaining

func _on_Walker_hit_goal():
	progress = (total_targets-get_current_targets())/float(total_targets)
	gui.refresh(hits, progress, steps)

func _on_Walker_hit_wall():
	hits += 1
	gui.refresh(hits, progress, steps)


func _on_Walker_step():
	steps += 1
	gui.refresh(hits, progress, steps)
