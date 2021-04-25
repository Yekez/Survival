extends Area2D




func _on_Timer_timeout():
	queue_free()
	



func _on_EnemyHit_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
