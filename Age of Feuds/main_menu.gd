extends Node


func _on_new_button_button_up():
	#Set some default data!
	
	Data.battle = "random"

	Data.playerarmy = [
		{
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": 100,
			"damage": 10,
			"name": Data.names.pick_random()
	},
		{
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": 100,
			"damage": 10,
			"name": Data.names.pick_random()
	},
		{
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": 100,
			"damage": 10,
			"name": Data.names.pick_random()
	},
		{
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": 100,
			"damage": 10,
			"name": Data.names.pick_random()
	},
	]

	Data.enemyarmy = [
		{
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": 100,
			"damage": 10,
			"name": Data.names.pick_random()
		}
	]

	Data.player = {
		"level": 1,
		"health": 100,
		"damage": 20,
		"experience": 0,
		"posx": 176,
		"posy": 192,
		"gold": 1000
	}

	Data.friendlycities = ["Nima"]
	
	self.get_tree().change_scene_to_file("res://world.tscn")



func _on_button_button_up():
	$Control/PanelContainer.visible = true


func _on_close_credits_button_button_up():
	$Control/PanelContainer.visible = false
