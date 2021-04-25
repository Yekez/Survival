extends RigidBody2D


func _ready():
	$Fish.frame = randi() % 2
	linear_velocity = Vector2(40,rand_range(-200,-250))

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.set_food(1)
		queue_free()
