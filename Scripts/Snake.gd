extends KinematicBody2D

var hit = preload("res://Scenes/EnemyHit.tscn")
var meat = preload("res://Scenes/Meat.tscn")
var hitting = false
var HP = 5

func _physics_process(delta):
	if to_local(Global.player.global_position).x < 0:
		$AnimatedSprite.flip_h = false
		if $AnimatedSprite.frame == 6 && !hitting:
			hitting = true
			var _hit = hit.instance()
			add_child(_hit)
			_hit.scale.x = 9
			pass
		elif $AnimatedSprite.frame == 1:
			hitting = false
	else:
		$AnimatedSprite.flip_h = true
		if $AnimatedSprite.frame == 6 && !hitting:
			hitting = true
			var _hit = hit.instance()
			add_child(_hit)
			_hit.scale.x = 9
			pass
		elif $AnimatedSprite.frame == 1:
			hitting = false

func _on_Detection_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite.play("default")


func _on_Detection_body_exited(body):
	if is_instance_valid(body):
		if body.is_in_group("player"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1

func take_damage(input):
	print("snake took dmg")
	$TookDmg.pitch_scale = rand_range(0.95,1.05)
	$TookDmg.play()
	HP -= input
	if HP <= 0:
		queue_free()
		var newmeat = meat.instance()
		get_parent().get_parent().add_child(newmeat)
		newmeat.position = position + Vector2(rand_range(-5,5),rand_range(-30,-60))
		newmeat.linear_velocity = Vector2(rand_range(-20,20),rand_range(-50,-100))
	# death sound
