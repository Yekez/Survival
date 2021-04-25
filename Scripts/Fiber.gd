extends RigidBody2D




func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.set_fiber(1)
		queue_free()
