extends Area2D

var fiber = preload("res://Scenes/Fiber.tscn")

var sprites
var HP = 6


func _ready():
	sprites = [$Bush1,$Bush2,$Bush3,$Bush4,$Bush5]
	sprites[randi() % 5].show()



func player_hit():
	if HP > 0:
		HP -= 1
		# needs sound
		$bushcut.pitch_scale = rand_range(0.85,1.15)
		$bushcut.play()
	else:
		# Needs sound as well
		Global.SFX.get_node("BushHarvested").play()
		var i = 0
		while i < (1 + (randi() % 2)):
			var newfiber = fiber.instance()
			get_parent().get_parent().add_child(newfiber)
			newfiber.position = position + Vector2(rand_range(-5,5),rand_range(-30,-60))
			newfiber.linear_velocity = Vector2(rand_range(-20,20),rand_range(-50,-100))
			queue_free()
			i += 1
	pass
