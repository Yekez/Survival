extends TouchScreenButton

var open = false


func _ready():
	Global.table = self

func _on_Table_pressed():
	if !open:
		Global.player.get_node("Camera2D/CanvasLayer/Inventory").show()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/TablePanel").show()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/TablePanel").unselect_all()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/CraftingPanel").unselect_all()
		open = true
	else:
		Global.player.get_node("Camera2D/CanvasLayer/Inventory").hide()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/TablePanel").hide()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/TablePanel").unselect_all()
		Global.player.get_node("Camera2D/CanvasLayer/Inventory/CraftingPanel").unselect_all()
		open = false



