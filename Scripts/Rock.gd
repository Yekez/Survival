extends Area2D

var stone = preload("res://Scenes/Stone.tscn")

var sprites
var HP = 6


func _ready():
	sprites = [$Stone2,$Stone3]
	sprites[randi() % 2].show()



func player_hit():
	if HP > 0:
		HP -= 1
		$stonecut.pitch_scale = rand_range(0.85,1.15)
		$stonecut.play()
	else:
		Global.SFX.get_node("RockHarvested").play()
		var i = 0
		while i < (1 + (randi() % 2)):
			var newstone = stone.instance()
			get_parent().get_parent().add_child(newstone)
			newstone.position = position + Vector2(rand_range(-5,5),rand_range(-30,-50))
			newstone.linear_velocity = Vector2(rand_range(-20,20),rand_range(-50,-100))
			queue_free()
			i += 1
	pass
