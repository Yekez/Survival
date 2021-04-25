extends Node2D

onready var Main = preload("res://Scenes/Main.tscn")


func _ready():
	$AnimationPlayer.play("IntroCam")
	$AnimationPlayer2.play("Sceneslabelbounce")
	pass # Replace with function body.



func _on_Button_pressed():
	get_tree().change_scene_to(Main)
	queue_free()
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
