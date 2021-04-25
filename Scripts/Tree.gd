extends Area2D

var wood = preload("res://Scenes/Wood.tscn")

var sprites
var HP = 6


func _ready():
	sprites = [$Tree1,$Tree2,$Tree3]
	sprites[randi() % 3].show()



func player_hit():
	if HP > 0:
		HP -= 1
		$woodcut.pitch_scale = rand_range(0.85,1.15)
		$woodcut.play()
	else:
		Global.SFX.get_node("TreeHarvested").play()
		var i = 0
		while i < (1 + (randi() % 2)):
			var newwood = wood.instance()
			get_parent().get_parent().add_child(newwood)
			newwood.position = position + Vector2(rand_range(-5,5),rand_range(-30,-60))
			newwood.linear_velocity = Vector2(rand_range(-20,20),rand_range(-50,-100))
			queue_free()
			i += 1
	pass
