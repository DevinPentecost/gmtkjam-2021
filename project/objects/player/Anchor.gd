extends Area2D
class_name Anchor
signal bumped(area)

export(Color) var highlight_color = Color.orange
export(Color) var dull_color = Color.gray

export(bool) var highlighted = false setget set_highlighted

onready var indicator = $Indicator

func set_highlighted(_highlighted:bool):
	highlighted = _highlighted
	_refresh_color()

func _refresh_color():
	var target_color = dull_color
	if highlighted: target_color = highlight_color
	
	modulate = target_color
	indicator.visible = highlighted

func _on_Anchor_area_entered(area):
	emit_signal("bumped", area)
	
	if area.is_in_group("wall"):
		$CPUParticles2D.direction =  Vector2.RIGHT.rotated(global_position.angle_to_point(area.global_position))
		$CPUParticles2D.emitting = true
