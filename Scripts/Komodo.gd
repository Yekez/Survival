extends KinematicBody2D

var hit = preload("res://Scenes/EnemyHit.tscn")
var meat = preload("res://Scenes/Meat.tscn")

var hitting = false
var HP = 10
var distance_factor = 150
var direction = Vector2(0,0)
var can_move = true
var move_speed = 50
var gravity = 200
var velocity = Vector2.ZERO
var player_detected = false

func _physics_process(delta):
	movement_animations()
	velocity = move_speed*direction
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	move_and_slide(velocity)


func movement_animations():
	if !player_detected:
		if velocity.x > 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Walk")
		elif velocity.x < 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Walk")
		else:
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			pass
	else:
		$AnimatedSprite.play("Attack")
		if to_local(Global.player.global_position).x > 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
# attacking
	if $AnimatedSprite.animation == "Attack":
		if $AnimatedSprite.frame == 6 && !hitting:
			hitting = true
			var _hit = hit.instance()
			add_child(_hit)
			if $AnimatedSprite.flip_h == false:
				_hit.position = Vector2(-32,0)
			else:
				_hit.position = Vector2(37,0)
			pass
		elif $AnimatedSprite.frame == 1:
			hitting = false

		

func _on_Detection_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true


func _on_Detection_body_exited(body):
	if body.is_in_group("player") && is_instance_valid(body):
		player_detected = false

func take_damage(input):
	$TookDmg.pitch_scale = rand_range(0.95,1.05)
	$TookDmg.play()
	HP -= input
	if HP <= 0:
		var newmeat = meat.instance()
		get_parent().get_parent().add_child(newmeat)
		newmeat.position = position + Vector2(rand_range(-5,5),rand_range(-30,-60))
		newmeat.linear_velocity = Vector2(rand_range(-20,20),rand_range(-50,-100))
		queue_free()
		# death sound


func _on_Timer_timeout():
	if can_move:
		can_move = false
		if global_position.distance_to(Global.player.global_position) > distance_factor:
			if global_position.x >= 4500:
				direction = Vector2(rand_range(-1,1),0).normalized()
				pass
			else:
				direction = Vector2(1,0).normalized()
		else:
			direction = Vector2((to_local(Global.player.global_position).x),0).normalized()
	else:
		can_move = true
		if global_position.distance_to(Global.player.global_position) > distance_factor:
			direction = Vector2.ZERO
		else:
			direction = Vector2((to_local(Global.player.global_position).x),0).normalized()
