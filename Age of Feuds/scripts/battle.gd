extends Node

@export var backgroundsprite = Texture
var playerhp
var player
var npc_template = preload("res://npc.tscn")

var enemiespawned = 0
var friendsspawned = 0

var enemyarmy
var friendlyarmy
var spawnedenemies = []
var spawnedfriends = []

var earned_xp = 0
var earned_gold = 0
var defeated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = backgroundsprite
	$Label.visible = false
	$Button.visible = false
	
	spawn_player()
	
	#for all enemies
	enemyarmy = []
	for i in Data.enemyarmy.size():
		enemyarmy.append(Data.enemyarmy[i])
		print("+NEW enemy: ", Data.enemyarmy[i])

	
	for i in enemyarmy.size():
		var newcolor = Color8(enemyarmy[i].Red, enemyarmy[i].Green, enemyarmy[i].Blue)
		var newhealth = enemyarmy[i].health
		var newdamage = enemyarmy[i].damage
		
		spawn_npc(false, newhealth, newdamage, newcolor)
	
	#the same but for friendly army!
	friendlyarmy = []
	for i in Data.playerarmy.size():
		friendlyarmy.append(Data.playerarmy[i])
		print("+NEW aly: ", Data.playerarmy[i])
	
	for i in friendlyarmy.size():
		var newcolor = Color8(friendlyarmy[i].Red, friendlyarmy[i].Green, friendlyarmy[i].Blue)
		var newhealth = friendlyarmy[i].health
		var newdamage = friendlyarmy[i].damage
		
		spawn_npc(true, newhealth, newdamage, newcolor)
	
	
	##health bar
	playerhp = $player.hp
	$Control/ProgressBar.max_value = playerhp
	$Control/ProgressBar.value = playerhp

func spawn_player():
	##spawn units according to updated DATA!
	var player_template = preload("res://player.tscn")
	
	if player_template.can_instantiate():
		player = player_template.instantiate()
	else:
		printerr("ERROR: could not instantiate player :(")
		
	player.position = Vector2(24, 160)
	player.hp = Data.player.health
	player.damage = Data.player.damage
	player.add_to_group("team1")
	
	friendsspawned = friendsspawned + 1
	self.add_child(player)

func spawn_npc(friendly, health, damage, color):
	var npc
	var spawnpos
	
	if npc_template.can_instantiate():
		npc = npc_template.instantiate()
	else:
		printerr("ERROR: could not instantiate NPC")
	
	npc.hp = health
	npc.attack_damage = damage
	
	if friendly == false:
		npc.add_to_group("team2")
		spawnpos = Vector2(240, 120) #default pos
		
		earned_xp = earned_xp + health + damage * 1.22 #prone to balancing!
		earned_gold = earned_gold + health + damage * 0.69 #prone to balancing!
	
		for i in enemiespawned:
			spawnpos.y = spawnpos.y + 20
			if spawnpos.y >= 200:
				spawnpos.y = 120
				spawnpos.x = spawnpos.x - 20


		
	elif friendly:
		npc.add_to_group("team1")
		spawnpos = Vector2(20, 140) #default pos
		
		for i in friendsspawned:
			spawnpos.y = spawnpos.y + 20
			if spawnpos.y >= 200:
				spawnpos.y = 120
				spawnpos.x = spawnpos.x + 20
			
		
	npc.red = color.r8
	npc.green = color.g8
	npc.blue = color.b8

	
	npc.position = spawnpos 
	

	enemiespawned = enemiespawned + 1
	friendsspawned = friendsspawned + 1
	
	if friendly:
		spawnedfriends.append(npc)
	else:
		spawnedenemies.append(npc)
	
	self.add_child(npc)

func change_healthbar(hp):
	$Control/ProgressBar.value = $player.hp

func check_deaths():
	var team1survivors = 0
	var team2survivors = 0
	
	for i in self.get_children():
		if i.is_in_group("team1") && (i.get("hp") != null or i.get("health") != null):
			if i.get("hp") >= 1: #npc
				team1survivors = team1survivors + 1
			else: #player
				team1survivors = team1survivors + 1
			
		elif i.is_in_group("team2")  && (i.get("hp") or i.get("health")):
			if i.get("hp") > 0:
				team2survivors = team2survivors + 1
	
	print("score(team1 vs team2)=")
	print(team1survivors, " vs ", team2survivors)
	
	if team1survivors <= 0:
		#game over! OOF!
		defeat()
	
	elif team2survivors <=0:
		#victory!
		victory()
	

func defeat():
	print("defeat!")
	defeated = true
	$Button.visible = true
	$Label.visible = true
	$Label.text = str("DEFEAT")
	
	earned_gold = 0
	earned_xp = 0

func victory():
	defeated = false
	Data.playerarmy = friendlyarmy
	Data.victorious = true
	Data.temp.xp = earned_xp
	Data.temp.gold = earned_gold
	
	$Button.visible = true
	$Label.visible = true
	$Label.text = str("VICTORY")


func i_died(body):
	print("my bro ", body.name, " died!")
	if body.is_in_group("team1"):
		
		for i in spawnedfriends.size():
			if body.name == spawnedfriends[i-1].name:
				friendlyarmy.pop_at(i-1)
		
	elif body.is_in_group("team2"):
		
		for i in spawnedenemies.size():
			if body.name == spawnedenemies[i-1].name:
				print("deleted: ", spawnedenemies[i-1].name)
				spawnedenemies.pop_at(i-1)
				
#	print("Data: friendlyarmy : ", spawnedfriends)
#	print("Data: enemyarmy : ", spawnedenemies)



func _on_continue_button_up():
	if defeated:
		self.get_tree().change_scene_to_file("res://main_menu.gd")
	else:
		self.get_tree().change_scene_to_file("res://world.tscn")
