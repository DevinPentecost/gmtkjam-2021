extends Area2D
class_name Wall

func play_bump_animation():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("flex")
