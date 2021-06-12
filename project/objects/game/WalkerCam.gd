extends Camera2D

export(float) var speed = 0.1
onready var target: Walker = get_tree().get_nodes_in_group("walker")[0]


func _process(delta):
	
	global_position = lerp(global_position, target.center_position.global_position, speed)
