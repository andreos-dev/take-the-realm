extends Node

#get data
var location = Data.battle
var playerarmy = Data.playerarmy
var enemyarmy = Data.enemyarmy



# Called when the node enters the scene tree for the first time.
func _ready():
	var player_soldiercount = 0
	var enemy_soldiercount = 0
	var balance = Vector2(0,0)
	
	for i in playerarmy:
		player_soldiercount = player_soldiercount + 1
	
	for i in enemyarmy:
		enemy_soldiercount = enemy_soldiercount + 1
		
	
	print("DETECTED You're with ", player_soldiercount, " soldiers against: ", enemy_soldiercount)
	
	if player_soldiercount < 5 && enemy_soldiercount > 1:
		balance = Vector2(-1,0)
	elif player_soldiercount < 10:
		balance = Vector2(-3,2)
	else:
		balance = Vector2(-10,20)
	
	randomize()
	
	if player_soldiercount < enemy_soldiercount:
		for i in enemy_soldiercount - player_soldiercount:
			enemyarmy.erase(enemyarmy.size())
			enemy_soldiercount = enemy_soldiercount - 1
	
	elif player_soldiercount > enemy_soldiercount:
		for i in player_soldiercount - enemy_soldiercount + randi_range(0, player_soldiercount / 2):
			var newsoldier = {
				"Red": randi_range( 10, 240),
				"Green":randi_range( 10, 240),
				"Blue": randi_range( 10, 240),
				"health": randi_range( 50, 200),
				"damage": randi_range( 5, 15),
				"name": Data.names.pick_random()
			}
		
			enemyarmy.append(newsoldier)
			enemy_soldiercount = enemy_soldiercount + 1
		
		print("rebalanced enemy soldiers.. now they are ", enemy_soldiercount)
		
		Data.enemyarmy = enemyarmy
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	self.get_tree().change_scene_to_file("res://battle.tscn")
