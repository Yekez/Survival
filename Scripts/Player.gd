extends KinematicBody2D


onready var Camera = $Camera2D

var hit = preload("res://Scenes/Hit.tscn")
var fish = preload("res://Scenes/Fish.tscn")
var can_move = false
var gravity = 200
var move_speed = 150
var velocity = Vector2.ZERO
var music = 0

# Inventory related
var has_axe = false 
var axe_dur = 20 setget set_axe_dur
var has_spear = false
var spear_dur = 20 setget set_spear_dur
var has_rod = false
var rod_dur = 5 setget set_rod_dur
var axe_selected = false
var rod_selected = false
var spear_selected = false
var attacking = false
var wood_count = 90 setget set_wood
var food_count = 90 setget set_food
var fiber_count = 90 setget set_fiber
var rope_count = 0 setget set_rope
var plank_count = 0 setget set_plank
var stone_count = 90 setget set_stone
var panel = false
var durability = 20
var has_table = false
# Stats
var HP = 10 setget set_hp
var hunger = 100 setget set_hunger

# dynamics
var hitting = false
var near_sea = true
var can_sail = false
var can_fish = false
var fishing = false

func _ready():
	$Camera2D/CanvasLayer/Control/Tools.focus_mode = 0
	Global.tools = $Camera2D/CanvasLayer/Control/Tools
	for i in range(0,$Camera2D/CanvasLayer/Inventory/CraftingPanel.get_item_count()):
		$Camera2D/CanvasLayer/Inventory/CraftingPanel.set_item_tooltip_enabled(i,false)
	for i in range(0,$Camera2D/CanvasLayer/Control/Tools.get_item_count()):
		$Camera2D/CanvasLayer/Control/Tools.set_item_tooltip_enabled(i,false)
	Global.player = self
	Global.SFX = $SFX
	$AnimatedSprite.play("Wake")

	


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Wake":
		$Camera2D/CanvasLayer/Dialogues/Tween.interpolate_property($Camera2D/CanvasLayer/Dialogues/Wake1, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Camera2D/CanvasLayer/Dialogues/Tween.start()
	elif $AnimatedSprite.animation == "NormalAttack" || $AnimatedSprite.animation == "AxeAttack" || $AnimatedSprite.animation == "SpearAttack" || $AnimatedSprite.animation == "Run":
		attacking = false 
		hitting = false



func _on_Tween_tween_completed(Wake1, modulate):
	$Camera2D/CanvasLayer/Dialogues/Tween.stop($Camera2D/CanvasLayer/Dialogues/Wake1,"modulate")
	$Camera2D/CanvasLayer/Dialogues/Tween.interpolate_property($Camera2D/CanvasLayer/Dialogues/Wake1, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Camera2D/CanvasLayer/Dialogues/Tween.start()
	can_move = true
	$CollisionShape2D.position.y += 3
	$AnimatedSprite.play("Idle")
	pass # Replace with function body.

func _movement():
	var move_direction = +int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right")) 
	velocity.x = lerp(move_speed * move_direction, 0,2)
	if move_direction > 0:
		$AnimatedSprite.flip_h = true
	elif move_direction < 0:
		$AnimatedSprite.flip_h = false

func _unhandled_input(event):
	if Input.is_action_pressed("Crafting") && !panel && can_move:
		$Camera2D/CanvasLayer/Inventory.show()
		$Camera2D/CanvasLayer/Inventory/TablePanel.hide()
		$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
		$Camera2D/CanvasLayer/Inventory/CraftingPanel.unselect_all()
		panel = true
	elif Input.is_action_pressed("Crafting") && panel:
		$Camera2D/CanvasLayer/Inventory.hide()
		$Camera2D/CanvasLayer/Inventory/TablePanel.hide()
		$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
		$Camera2D/CanvasLayer/Inventory/CraftingPanel.unselect_all()
		panel = false
func _physics_process(delta):
	_fishing()
	#tool_check()
	velocity.y+=gravity*delta
	_hit()
	if can_move:
		_movement()
		move_and_slide(velocity,Vector2(0,-1))
		if is_on_floor():
			velocity.y = 0
		if velocity.x != 0:
			$AnimatedSprite.play("Run")
		else:
			if !attacking:
				$AnimatedSprite.play("Idle")
		
		if Input.is_action_just_pressed("ui_accept") && velocity.x == 0:
			attacking = true
			if has_axe && axe_selected:
				$AnimatedSprite.play("AxeAttack")
			elif has_spear && spear_selected:
				$AnimatedSprite.play("SpearAttack")
			elif has_rod && rod_selected && can_fish:
				can_move = false
				fishing = true
				$AnimatedSprite.play("Fishing")
			else:
				$AnimatedSprite.play("NormalAttack")
	pass
# fight/gather/fish
func _fishing():
	if fishing:
		if $AnimatedSprite.frame == 7:
			if randi() % 10 == 0:
				print("FISH!")
				var newfish = fish.instance()
				get_parent().add_child(newfish)
				newfish.global_position = Vector2(-2180,0)
				fishing = false
				can_move = true
				$AnimatedSprite.play("Idle")
				set_rod_dur(-1)
				pass
			else:
				$AnimatedSprite.frame = 4
			pass

func _hit():
	if $AnimatedSprite.animation == "NormalAttack" && $AnimatedSprite.frame == 2 && !hitting:
		hitting = true
		var newhit = hit.instance()
		add_child(newhit)
		if $AnimatedSprite.flip_h == false:
			newhit.position = Vector2(13,9.5)
		else:
			newhit.position = Vector2(-13,9.5)
	elif $AnimatedSprite.animation == "AxeAttack" && $AnimatedSprite.frame == 2 && !hitting:
		hitting = true
		var newhit = hit.instance()
		add_child(newhit)
		if $AnimatedSprite.flip_h == false:
			newhit.position = Vector2(13,9.5)
		else:
			newhit.position = Vector2(-13,9.5)
	elif $AnimatedSprite.animation == "SpearAttack" && $AnimatedSprite.frame == 4 && !hitting:
		hitting = true
		var newhit = hit.instance()
		add_child(newhit)
		newhit.get_node("CollisionShape2D").scale.x = 2
		if $AnimatedSprite.flip_h == false:
			newhit.position = Vector2(13,9.5)
		else:
			newhit.position = Vector2(-13,9.5)
	pass

func take_damage(input):
	if can_move:
		if HP <= 0:
			HP = 0
			can_move = false
			$Camera2D/CanvasLayer/GameOver.show()
			$Camera2D/CanvasLayer/GameOver/GameOverAnimaiton.play("gameover")
			$SFX/GameOver.play()
		else:
			print("player took dmg")
			set_hp(-input)
			$SFX/TookHit.play()
			pass

# Stat operations
func set_hp(val):
	HP += val
	$Camera2D/CanvasLayer/Stats/HPbar/HPLabel.text = var2str(HP)
	$Camera2D/CanvasLayer/Stats/HPbar/HP.value = HP
	pass

func set_hunger(val):
	hunger += val
	$Camera2D/CanvasLayer/Stats/HungerBar/HungerLabel.text = var2str(hunger)
	$Camera2D/CanvasLayer/Stats/HungerBar/Hunger.value = hunger
	pass

func _on_HungerTimer_timeout():
	if HP >= 10 || (hunger <= 50 && hunger > 0):
		set_hunger(-1)
	elif HP < 10 && HP > 0 && hunger > 50:
		set_hunger(-5)
		set_hp(1)
	else:
		set_hp(-1)
		pass

func _on_Eat_pressed():
	if food_count > 0 && hunger <= 90:
		set_hunger(10)
		set_food(-1)
		pass

# Inventory operations
func set_axe_dur(value):
	if axe_dur > 0:
		axe_dur += value
	elif axe_dur <= 0 && has_axe:
		has_axe = false
		axe_selected = false
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(0,true)
		$SFX/ToolBroken.play()

func set_rod_dur(value):
	if rod_dur > 0:
		rod_dur += value
	elif rod_dur <= 0 && has_rod:
		has_rod = false
		rod_selected = false
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(1,true)
		$SFX/ToolBroken.play()

func set_spear_dur(value):
	if spear_dur > 0:
		spear_dur += value
	elif spear_dur <= 0 && has_spear:
		has_spear = false
		spear_selected = false
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(2,true)
		$SFX/ToolBroken.play()

func set_wood(wood):
	wood_count += wood
	$Camera2D/CanvasLayer/Inventory/Wood/woodcount.text = var2str(wood_count)

func set_stone(stone):
	stone_count += stone
	$Camera2D/CanvasLayer/Inventory/Stone/stonecount.text = var2str(stone_count)

func set_fiber(fiber):
	fiber_count += fiber
	$Camera2D/CanvasLayer/Inventory/Fiber/fibercount.text = var2str(fiber_count)

func set_food(food):
	food_count += food
	$Camera2D/CanvasLayer/Inventory/Food/foodcount.text = var2str(food_count)
	pass

func set_plank(plank):
	plank_count += plank
	$Camera2D/CanvasLayer/Inventory/Plank/plankcount.text = var2str(plank_count)

func set_rope(rope):
	rope_count += rope
	$Camera2D/CanvasLayer/Inventory/Rope/ropecount.text = var2str(rope_count)


func _on_CraftingPanel_item_selected(index):
	match index:
		0:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"This tool will help me to harvest resources faster!\nRequires: 10 Wood 10 Stone"
			pass
		1:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"This will help me to catch fish!\nRequires: 10 Wood 10 Stone 10 Fiber"
			pass
		2:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"I can defend myself better with this.\nRequires: 10 Wood 10 Stone 10 Fiber"
			pass
		3:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"I need this to craft planks for my ship!\nRequires: 50 Wood 50 Stone 50 Fiber\nI need to be near sea."
			pass

func _on_TablePanel_item_selected(index):
	match index:
		0:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"These will be the hull of my ship!\nRequires: 10 Wood"
			pass
		1:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"I need these to hold the planks together!\nRequires: 10 Fiber"
		2:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"Base of my ship.\nRequires: 20 Plank 10 Rope"
			pass
		3:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"Hull of my ship.\nRequires: 5 Plank 5 Rope"
			pass
		4:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"Rudder of my ship.\nRequires: 5 Plank 5 Rope 1 Wood"
			pass
		5:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"Frame of my ship.\nRequires: 10 Plank 20 Rope 10 Wood"
			pass
		6:
			$Camera2D/CanvasLayer/Inventory/Label.text = \
			"Roof of my ship.\nRequires: 10 Plank 10 Rope 30 Fiber"
			pass
func _on_Button_pressed():
	if $Camera2D/CanvasLayer/Inventory/CraftingPanel.is_anything_selected():
		var _item = $Camera2D/CanvasLayer/Inventory/CraftingPanel.get_selected_items()[0]
		match _item:
			0:
				if wood_count>=10 && stone_count>=10 && !has_axe:
					has_axe = true
					axe_dur = durability
					self.set_wood(-10)
					self.set_stone(-10)
					$Camera2D/CanvasLayer/Control/Tools.show()
					$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(0,false)
				pass
			1:
				if wood_count>=10 && stone_count>=10 && fiber_count >= 10 && !has_rod:
					has_rod = true
					rod_dur = 10
					self.set_wood(-10)
					self.set_stone(-10)
					self.set_fiber(-10)
					$Camera2D/CanvasLayer/Control/Tools.show()
					$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(1,false)
					if $Camera2D/CanvasLayer/Control/Tools.max_columns < 2:
						$Camera2D/CanvasLayer/Control/Tools.max_columns = 2
				pass
			2:
				if wood_count>=10 && stone_count>=10 && fiber_count >= 10 && !has_spear:
					has_spear = true
					spear_dur = durability
					self.set_wood(-10)
					self.set_stone(-10)
					self.set_fiber(-10)
					$Camera2D/CanvasLayer/Control/Tools.show()
					$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(2,false)
					if $Camera2D/CanvasLayer/Control/Tools.max_columns < 3:
						$Camera2D/CanvasLayer/Control/Tools.max_columns = 3
				pass
			3:
				if wood_count>=50 && stone_count>=50 && fiber_count >= 50 && !has_table && near_sea:
					has_table = true
					Global.table.show()
					self.set_wood(-50)
					self.set_stone(-50)
					self.set_fiber(-50)
					$Camera2D/CanvasLayer/Control/Tools.show()
					if $Camera2D/CanvasLayer/Control/Tools.max_columns < 3:
						$Camera2D/CanvasLayer/Control/Tools.max_columns = 3
				pass
	if $Camera2D/CanvasLayer/Inventory/TablePanel.is_anything_selected() && near_sea:
		var _item = $Camera2D/CanvasLayer/Inventory/TablePanel.get_selected_items()[0]
		match _item:
			0:
				if wood_count>=10:
					self.set_plank(1)
					self.set_wood(-10)
				pass
			1:
				if fiber_count >= 10:
					self.set_rope(1)
					self.set_fiber(-10)
				pass
			2:
				# base
				if plank_count >= 20 && rope_count >= 10:
					self.set_plank(-20)
					self.set_rope(-10)
					Global.table.get_node("Ship").frame = 0
					Global.table.get_node("Ship").show()
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(2, true)
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(3, false)
					$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
				pass
			3:
				# hull
				if plank_count >= 5 && rope_count >= 5:
					self.set_plank(-5)
					self.set_rope(-5)
					Global.table.get_node("Ship").frame = 1
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(3, true)
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(4, false)
					$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
				pass
			4:
				# rudder
				if plank_count >= 5 && rope_count >= 5 && wood_count>=1:
					self.set_plank(-5)
					self.set_rope(-5)
					self.set_wood(-1)
					Global.table.get_node("Ship").frame = 2
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(4, true)
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(5, false)
					$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
				pass
			5:
				# frame
				if plank_count >= 10 && rope_count >= 20 && wood_count >= 10:
					self.set_plank(-10)
					self.set_rope(-20)
					self.set_wood(-10)
					Global.table.get_node("Ship").frame = 3
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(5, true)
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(6, false)
					$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
				pass
			6:
				# roof
				if plank_count >= 10 && rope_count >= 10 && fiber_count >= 30:
					self.set_plank(-10)
					self.set_rope(-10)
					self.set_fiber(-30)
					Global.table.get_node("Ship").frame = 4
					$Camera2D/CanvasLayer/Inventory/TablePanel.set_item_disabled(6, true)
					$Camera2D/CanvasLayer/Inventory/TablePanel.unselect_all()
					can_sail = true
					$Camera2D/CanvasLayer/SetSail.show()
				pass


func _on_Tools_item_selected(index):
	match index:
		0:
			if has_axe:
				axe_selected = true
				rod_selected = false
				spear_selected = false

			#$Camera2D/CanvasLayer/Control/Tools.select(0,true)
		1:
			if has_rod:
				axe_selected = false
				rod_selected = true
				spear_selected = false

			#$Camera2D/CanvasLayer/Control/Tools.select(1,true)
		2:
			if has_spear:
				axe_selected = false
				rod_selected = false
				spear_selected = true

			#$Camera2D/CanvasLayer/Control/Tools.select(2,true)

func tool_check():
	if has_axe:
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(0,false)
	elif !has_axe:
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(0,true)
	if has_rod:
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(1,false)
	elif !has_rod:
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(1,true)
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()
	if has_spear:
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(2,false)
	elif !has_spear:
		$Camera2D/CanvasLayer/Control/Tools.set_item_disabled(2,true)
		$Camera2D/CanvasLayer/Control/Tools.unselect_all()

var dia = 0
func _on_DialogueTimer_timeout():
	match dia:
		0:
			$Camera2D/CanvasLayer/Dialogues/Wake2.show()
			dia += 1
		1: 
			$Camera2D/CanvasLayer/Dialogues/Wake2.queue_free()
			$Camera2D/CanvasLayer/Dialogues/Wake3.show()
			dia += 1
		2:
			$Camera2D/CanvasLayer/Dialogues/Wake3.queue_free()
			$Camera2D/CanvasLayer/Dialogues/Wake4.show()
			dia += 1
		3:
			$Camera2D/CanvasLayer/Dialogues/Wake4.queue_free()
			$Camera2D/CanvasLayer/Dialogues/Wake5.show()
			dia += 1
		4:
			$Camera2D/CanvasLayer/Dialogues.queue_free()
		


func _on_TryAgain_pressed():
	Global.try_again()


func _on_GameOverAnimaiton_animation_finished(anim_name):
	$Camera2D/CanvasLayer/GameOver/GameOverAnimaiton.stop()


func _on_SetSail_pressed():
	can_move = false
	$Camera2D/CanvasLayer/GameOver.show()
	$Camera2D/CanvasLayer/GameOver/GameOverAnimaiton.play("gameover")
	$Camera2D/CanvasLayer/GameOver/GameOverText.text = "I SURVIVED!"
	$SFX/Victory.play()


func _on_GameOver_finished():
	$SFX/GameOver.play()


func _on_Victory_finished():
	$SFX/Victory.play()


func _on_MusicTimer_timeout():
	$SFX/MusicTimer.start(600)
	match music:
		0:
			$SFX/Music2.play()
			if music < 3:
				music += 1
			else:
				music = 1
		1:
			$SFX/Music1.play()
			if music < 3:
				music += 1
			else:
				music = 1
		2:
			$SFX/Music3.play()
			if music < 3:
				music += 1
			else:
				music = 1
		3: 
			$SFX/Music2.play()
			if music < 3:
				music += 1
			else:
				music = 1
