extends Node

var intro = load("res://Scenes/Intro.tscn")

var player
var SFX
var table
var tools

func try_again():
	get_node("/root/Main").queue_free()
	var newgame = intro.instance()
	get_node("/root").add_child(newgame)
	newgame.get_node("Camera2D").current = true
	
	
