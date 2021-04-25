extends Node2D



func _ready():
	$Player.Camera.current = true
	$Table/Ship/AnimationPlayer.play("shipwave")

func _on_AnimationPlayer_animation_finished(anim_name):
	$Table/Ship/AnimationPlayer.play("shipwave")

func _on_SeaCheck_body_entered(body):
	if body.is_in_group("player"):
		body.near_sea = true
		print("near sea")


func _on_SeaCheck_body_exited(body):
	if is_instance_valid(body):
		if body.is_in_group("player"):
			body.near_sea = false
			print("not near sea")





func _on_FishingArea_body_entered(body):
	if body.is_in_group("player"):
		body.can_fish = true
		print("can fish")


func _on_FishingArea_body_exited(body):
	if is_instance_valid(body):
		if body.is_in_group("player"):
			body.can_fish = false
			print("can't fish")


func _on_SeaTimer_timeout():
	$AmbientSFX/SeaTimer.start(8+randi() % 20)
	$AmbientSFX/Sea.play()
