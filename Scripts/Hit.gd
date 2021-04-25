extends Area2D


func _on_Timer_timeout():
	queue_free()



func _on_Hit_area_entered(area):
	if get_overlapping_bodies().size()<=0:
		if Global.player.axe_selected:
			if area.is_in_group("tree") || area.is_in_group("rock"):
				get_overlapping_areas()[0].player_hit()
				get_overlapping_areas()[0].player_hit()
				get_overlapping_areas()[0].player_hit()
				Global.player.set_axe_dur(-1)
				pass
		elif Global.player.spear_selected:
			Global.player.spear_selected = false
			Global.tools.select(2,false)
			if area.is_in_group("tree") || area.is_in_group("rock"):
				get_overlapping_areas()[0].player_hit()
				Global.player.set_spear_dur(-1)
			pass
		else:
			if area.is_in_group("tree") || area.is_in_group("rock"):
				get_overlapping_areas()[0].player_hit()


func _on_Hit_body_entered(body):
	if body.is_in_group("enemy"):
		# snake hit sound
		if Global.player.spear_selected:
			body.take_damage(3)
			Global.player.set_spear_dur(-1)
		elif Global.player.axe_selected:
			body.take_damage(2)
			Global.player.set_axe_dur(-3)
		else:
			body.take_damage(1)
