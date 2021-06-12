extends Camera2D

export(float) var speed = 0.1
onready var target: Walker = get_tree().get_nodes_in_group("walker")[0]
var target_zoom = Vector2(0.5,0.5)

func _process(delta):
	if target.find_node("AnimatedSprite").get_animation() != "sleep": # don't know how to do this, zoom out on first input
		zoom = lerp(zoom, target_zoom, speed/10)
	global_position = lerp(global_position, target.center_position.global_position, speed)
