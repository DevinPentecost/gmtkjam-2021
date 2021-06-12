extends Node2D
signal hit_goal
signal hit_wall


enum RotateDirection {
	CLOCKWISE=1,
	COUNTER_CLOCKWISE=-1
}

var current_anchor: Anchor
var other_anchor: Anchor
var rotate_direction = RotateDirection.CLOCKWISE
var rotate_speed = PI / 2  # Rotate PI radians every X second(s)

onready var left_anchor = $Anchor_Left
onready var right_anchor = $Anchor_Right
onready var anchor_distance = right_anchor.global_position.distance_to(left_anchor.global_position)
onready var anchor_angle: float

func _physics_process(delta):
	_process_rotation(delta)

func _process_rotation(delta):
	
	if current_anchor == null or other_anchor == null:
		return
	
	#Amount and direction to rotate
	anchor_angle += rotate_direction * rotate_speed * delta
	var anchor_position = current_anchor.global_position
	var offset = Vector2.DOWN.rotated(anchor_angle) * anchor_distance
	other_anchor.global_position = anchor_position + offset
	

func switch_anchor(player_hit_left: bool):
	#If no current anchor, go the direction hit
	if current_anchor == null:
		if player_hit_left:
			current_anchor = right_anchor
		else:
			current_anchor = left_anchor
	
	#Move to the next anchor
	current_anchor.highlighted = false
	if current_anchor == right_anchor:
		current_anchor = left_anchor
		other_anchor = right_anchor
	else:
		current_anchor = right_anchor
		other_anchor = left_anchor
	current_anchor.highlighted = true
	
	anchor_angle = other_anchor.global_position.angle_to_point(current_anchor.global_position) - PI/2
	
	#Which way to rotate
	if player_hit_left:
		rotate_direction = RotateDirection.COUNTER_CLOCKWISE
	else:
		rotate_direction = RotateDirection.CLOCKWISE

func _handle_player_left():
	switch_anchor(true)
	
func _handle_player_right():
	switch_anchor(false)

	
func _unhandled_key_input(event):
	if event.is_action_pressed("player_left"):
		_handle_player_left()
	elif event.is_action_pressed("player_right"):
		_handle_player_right()

func _handle_bump(anchor: Anchor, with:Area2D):
	if with.is_in_group("goal"):
		emit_signal("hit_goal")
		print("We won!")
		return
	
	if with.is_in_group("wall"):
		#The pivot anchor shouldn't bump but check just in case
		if anchor == current_anchor:
			return
		emit_signal("hit_wall")
		if rotate_direction == RotateDirection.CLOCKWISE:
			rotate_direction = RotateDirection.COUNTER_CLOCKWISE
		else:
			rotate_direction = RotateDirection.CLOCKWISE

func _on_Anchor_Right_bumped(area):
	_handle_bump(right_anchor, area)
func _on_Anchor_Left_bumped(area):
	_handle_bump(left_anchor, area)
