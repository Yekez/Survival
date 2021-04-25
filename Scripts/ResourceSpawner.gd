extends Node2D

var tree = preload("res://Scenes/Tree.tscn")
var rock = preload("res://Scenes/Rock.tscn")
var bush = preload("res://Scenes/Bush.tscn")



func _on_Timer_timeout():
	var tree_pos = Vector2(rand_range(0,10000),0)
	if get_tree().get_nodes_in_group("tree").size() < 50 && tree_pos.distance_to(Global.player.global_position) > 500:
		var newtree = tree.instance()
		add_child(newtree)
		newtree.position = tree_pos
		pass
	var rock_pos = Vector2(rand_range(4000,10000),0)
	if get_tree().get_nodes_in_group("rock").size() < 40 && rock_pos.distance_to(Global.player.global_position) > 500:
		var newrock = rock.instance()
		add_child(newrock)
		newrock.position = rock_pos
		pass
	var bush_pos = Vector2(rand_range(0,10000),0)
	if get_tree().get_nodes_in_group("bush").size() < 30 && bush_pos.distance_to(Global.player.global_position) > 500:
		var newbush = bush.instance()
		add_child(newbush)
		newbush.position = bush_pos
		
