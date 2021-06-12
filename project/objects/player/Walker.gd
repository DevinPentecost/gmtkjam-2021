extends Node2D
class_name Walker
signal hit_goal
signal hit_wall
signal step

const FootprintScene = preload("res://objects/player/Footprint.tscn")

enum RotateDirection {
	CLOCKWISE=1,
	COUNTER_CLOCKWISE=-1
}

var current_anchor: Anchor
var other_anchor: Anchor
var rotate_direction = RotateDirection.CLOCKWISE
var rotate_speed = PI / 2  # Rotate PI radians every X second(s)
var pause = false
var firststep = true

onready var left_anchor = $Anchor_Left
onready var right_anchor = $Anchor_Right
onready var center_position = $CenterPosition
onready var anchor_distance = right_anchor.global_position.distance_to(left_anchor.global_position)
onready var anchor_angle: float

func _physics_process(delta):
	_process_rotation(delta)
	_update_center()

func _process_rotation(delta):
	if pause: return
	
	if current_anchor == null or other_anchor == null:
		return
	
	#Amount and direction to rotate
	anchor_angle += rotate_direction * rotate_speed * delta
	var anchor_position = current_anchor.global_position
	var offset = Vector2.DOWN.rotated(anchor_angle) * anchor_distance
	var other_position = anchor_position + offset
	other_anchor.global_position = other_position
	
	# set sprite direction
	if not other_anchor.find_node("AnimatedSprite").flip_h and offset.y > 0: # need to add logic flip when counter clockwise
		other_anchor.find_node("AnimatedSprite").flip_h = true
	elif other_anchor.find_node("AnimatedSprite").flip_h and offset.y < 0:
		other_anchor.find_node("AnimatedSprite").flip_h = false
	
func _update_center():
	center_position.global_position = left_anchor.global_position + (right_anchor.global_position - left_anchor.global_position)/2

func switch_anchor(player_hit_left):
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
	
	# update sprite animations on switch
	if firststep:
		firststep = false
		current_anchor.find_node("AnimatedSprite").play("wake") # think have to add animationPlayer to queue up walk animation after
		other_anchor.find_node("AnimatedSprite").play("wake")
	else:
		current_anchor.find_node("AnimatedSprite").play("inactive")
		other_anchor.find_node("AnimatedSprite").play("walk")
	
	anchor_angle = other_anchor.global_position.angle_to_point(current_anchor.global_position) - PI/2
	
	#Which way to rotate
	if player_hit_left != null:
		if player_hit_left:
			rotate_direction = RotateDirection.COUNTER_CLOCKWISE
		else:
			rotate_direction = RotateDirection.CLOCKWISE
	
	_leave_footprint()

func _handle_player_left():
	emit_signal("step")
	switch_anchor(true)
	
func _handle_player_right():
	emit_signal("step")
	switch_anchor(false)

func _handle_player_step():
	emit_signal("step")
	switch_anchor(null)

func _leave_footprint():
	var footprint = FootprintScene.instance()
	footprint.global_position = current_anchor.global_position
	get_parent().add_child(footprint)

func _unhandled_key_input(event):
	if event.is_action_pressed("player_step"):
		_handle_player_step()

func play_cheer():
	pause = true
	$AnimationPlayer.play("cheer")
	yield($AnimationPlayer, "animation_finished")
	other_anchor.find_node("AnimatedSprite").play("walk")
	pause = false

func _handle_bump(anchor: Anchor, with:Area2D):
	if with.is_in_group("goal"):
		with.queue_free()
		play_cheer()
		print("We won!")
		emit_signal("hit_goal")
		other_anchor.find_node("AnimatedSprite").play("activate")
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
	
		center_position.flip_h = rotate_direction == RotateDirection.COUNTER_CLOCKWISE

func _on_Anchor_Right_bumped(area):
	_handle_bump(right_anchor, area)
func _on_Anchor_Left_bumped(area):
	_handle_bump(left_anchor, area)
