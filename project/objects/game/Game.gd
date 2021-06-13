extends Node2D

onready var player = $Walker
onready var total_targets = get_tree().get_nodes_in_group("goal").size()
onready var gui = $GUI

var progress = 0
var steps = 0
var hits = 0
var time = 0

func _process(delta):
	time += delta
	gui.refresh_time(time)

func get_current_targets():
	var goals = get_tree().get_nodes_in_group("goal")
	return goals.size()

func _on_Walker_hit_goal():
	progress = (total_targets-get_current_targets())/total_targets
	gui.refresh(hits, progress, steps)

func _on_Walker_hit_wall():
	hits += 1
	$Bumper/AnimatedSprite.play("flex")
	gui.refresh(hits, progress, steps)


func _on_Walker_step():
	steps += 1
	gui.refresh(hits, progress, steps)
