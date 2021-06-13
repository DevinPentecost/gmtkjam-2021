extends Area2D
class_name Anchor
signal bumped(area)

export(Color) var highlight_color = Color.orange
export(Color) var dull_color = Color.gray

export(bool) var highlighted = false setget set_highlighted

onready var indicator = $Indicator

var done = false

func set_highlighted(_highlighted:bool):
	highlighted = _highlighted
	_refresh_color()
	
	if highlighted:
		$AudioStreamPlayer.play()

func wake(and_walk=false, and_sleep=false):
	$AnimatedSprite.play("wake")
	yield($AnimatedSprite, "animation_finished")
	if and_walk:
		$AnimatedSprite.play("walk")
	elif and_sleep:
		$AnimatedSprite.play("inactive")

func cheer(loop:bool):
	if loop:
		$AnimatedSprite.play("activate_loop")
	else:
		var previous_animation = $AnimatedSprite.animation
		$AnimatedSprite.play("activate")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play(previous_animation)
		
	done = loop

func walk():
	if not done:
		$AnimatedSprite.play("walk")

func _refresh_color():
	var target_color = dull_color
	if highlighted: target_color = highlight_color
	
	modulate = target_color
	indicator.visible = highlighted

func _on_Anchor_area_entered(area):
	emit_signal("bumped", area)
	
	if area.is_in_group("wall"):
		var as_wall = area as Wall
		if as_wall != null:
			as_wall.play_bump_animation()
		$CPUParticles2D.direction =  Vector2.RIGHT.rotated(global_position.angle_to_point(area.global_position))
		$CPUParticles2D.emitting = true
		
