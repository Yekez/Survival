extends Node2D

var snake = preload("res://Scenes/Snake.tscn")
var komodo = preload("res://Scenes/Komodo.tscn")





func _on_Timer_timeout():
	var newsnake_pos = Vector2(rand_range(2500,6000),-17)
	var newkomodo_pos = Vector2(rand_range(6500,10000),-10)
	if get_tree().get_nodes_in_group("snake").size() < 10 && newsnake_pos.distance_to(Global.player.global_position) > 500:
		var newsnake = snake.instance()
		newsnake.global_position = newsnake_pos
		print("snake spawned")
		add_child(newsnake)
	if get_tree().get_nodes_in_group("komodo").size() < 10 && newkomodo_pos.distance_to(Global.player.global_position) > 500:
		var newkomodo = komodo.instance()
		newkomodo.global_position = newkomodo_pos
		add_child(newkomodo)
		print("komodo spawned")
