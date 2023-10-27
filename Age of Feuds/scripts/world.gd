extends Node

var icon_resource = preload("res://sprites/circle.png")
var town
var buymax = false
@export var soldiers = ["scout","outcast","mercenary","squire","noble", "knight","champion"]
var selindex
var generatedprice
# Called when the node enters the scene tree for the first time.
func _ready():
	$player.position = Vector2(int(Data.player.posx), int(Data.player.posy))
	
	$CanvasLayer/UI/CityPanel.visible = false
	$CanvasLayer/UI/BarracksPanel.visible = false
	$CanvasLayer/UI/BlacksmithPanel.visible = false
	$CanvasLayer/UI/TemplePanel.visible = false
	$CanvasLayer/UI/CityHallPanel.visible = false
	
	if Data.victorious == true:
		var vcpanel = $CanvasLayer/UI/VictoryPanel
		vcpanel.visible = true
		vcpanel.grab_focus()
		
		var earnedgold = Data.temp.gold
		var earnedexperience = Data.temp.xp
		
		Data.player.gold = Data.player.gold + earnedgold
		Data.player.experience = Data.player.experience + earnedexperience
		
		Data.temp.gold = 0
		Data.temp.xp = 0
		
		var earnedgear = "wip"
		
		$CanvasLayer/UI/VictoryPanel/Label2.text = String("
		You gained: \n" + 
		str(earnedgold) + " gold \n" +
		str(earnedexperience) +  " experience \n" +
		str(earnedgear) + " gear"
		)
		
	else:
		$CanvasLayer/UI/VictoryPanel.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func settlementEntered(settlement):
	#open UI
	print("open UI")
	town = settlement
	$CanvasLayer/UI/CityPanel.visible = true
	
	var titletext = String()
	var size = String()
	if settlement.size == 1:
		size = "village"
	elif settlement.size == 2:
		size = "town"
	elif settlement.size == 3:
		size = "city"
	
	
	$CanvasLayer/UI/CityPanel/TitleLabel.text = String("Welcome to the " + size + " of " + settlement.naam + " under the kingdom of " + settlement.faction)

func settlementExit(settlement):
	#close UI
	print("closeUI")
	$CanvasLayer/UI/CityPanel.visible = false
	$CanvasLayer/UI/CityPanel.visible = false
	$CanvasLayer/UI/BarracksPanel.visible = false
	$CanvasLayer/UI/BlacksmithPanel.visible = false
	$CanvasLayer/UI/TemplePanel.visible = false
	$CanvasLayer/UI/CityHallPanel.visible = false

func _on_settlement_button_button_up():
	print("closeUI")
	$CanvasLayer/UI/CityPanel.visible = false
	$CanvasLayer/UI/BarracksPanel.visible = false
	$CanvasLayer/UI/BlacksmithPanel.visible = false
	$CanvasLayer/UI/TemplePanel.visible = false
	$CanvasLayer/UI/CityHallPanel.visible = false

func onvictory():
	pass


func _on_close_button_button_up():
	$CanvasLayer/UI/VictoryPanel.visible = false

func _on_blacksmith_button_up():
	$CanvasLayer/UI/BlacksmithPanel.visible = false
	$CanvasLayer/UI/CityPanel.visible = true

func _on_barracks_button_up():
	$CanvasLayer/UI/BarracksPanel.visible = false
	$CanvasLayer/UI/CityPanel.visible = true

func _on_blacksmith_button_button_up():
	$CanvasLayer/UI/BlacksmithPanel.visible = true
	$CanvasLayer/UI/CityPanel.visible = false

func _on_barracks_button_button_up(): #opens barracksmenu
	$CanvasLayer/UI/BarracksPanel.visible = true
	$CanvasLayer/UI/CityPanel.visible = false
	$CanvasLayer/UI/BarracksPanel/Container/BUYButton.disabled = true
	$CanvasLayer/UI/BarracksPanel/Container/SELLButton.disabled = true
	
	get_myarmy()
	get_soldarmy()
	update_money()

func update_money():
	$CanvasLayer/UI/BarracksPanel/Container/GHLabel.text = "my gold: " + str(Data.player.gold) + "\nhealth: " + str("-")

func get_myarmy(): #BarracksPanel
	
	var icon = icon_resource
	$CanvasLayer/UI/BarracksPanel/Container/myArmylist.clear()
	
	var count = 0
	for i in Data.playerarmy: #for everysoldier in army -> outputs dictionary
		count = count + 1
		print("getting myarmy: ", i)
		
		var r = i.Red
		var g = i.Green
		var b = i.Blue
		var health = i.health
		var damage = i.damage
		
#		icon.self_modulate = Color8(r,g,b)
		
		var soldiername = String("Soldier "+ str(count))
		
		$CanvasLayer/UI/BarracksPanel/Container/myArmylist.add_item(soldiername, icon)
		$CanvasLayer/UI/BarracksPanel/Container/myArmylist.set_item_icon_modulate(count - 1, Color8(r,g,b))

func get_soldarmy(): #BarracksPanel
	var soldlist = $CanvasLayer/UI/BarracksPanel/Container/ShopList
	soldlist.clear()
	
	if town.size == 1:
		for i in soldiers:
			if i <= 2:
				soldlist.add_item(i)
	if town.size == 2:
		for i in soldiers:
			if i <= 3:
				soldlist.add_item(i)
	if town.size == 3:
		for i in soldiers:
			soldlist.add_item(i)
	


func _on_shop_list_item_selected(index): #BarracksPanel
	$CanvasLayer/UI/BarracksPanel/Container/BUYButton.disabled = false
	$CanvasLayer/UI/BarracksPanel/Container/SELLButton.disabled = true
	
	print(index)
	## THIS IS ESSENTIALLY THE DIFFICULTY FORMULA OF THE GAME. PRONE TO BALANCING YET
	var price = 50 + 100 * index * 1.2
	var health = 50 + 100 * index * 0.7
	var damage = 10 + 20 * index * 1.3
	
	$CanvasLayer/UI/BarracksPanel/Container/Label3.text = "price: " + str(price) + "\ndamage: " + str(damage)
	$CanvasLayer/UI/BarracksPanel/Container/GHLabel.text = "my gold: " + str(Data.player.gold) + "\nhealth: " + str(health)


func _on_buy_button_up(): #BarracksPanel
	var shoplist = $CanvasLayer/UI/BarracksPanel/Container/ShopList
	var selecteditemindex 
	
	if shoplist.is_anything_selected():
		selecteditemindex = shoplist.get_selected_items()[0]
	else:
		printerr("no item was selected")
		return
	
	var itemtext = shoplist.get_item_text(selecteditemindex)
	print("Buying index in list:", selecteditemindex, "buying index in array: ", soldiers[selecteditemindex])
	
	var index = selecteditemindex
	
	var price = 50 + 100 * index * 1.2
	var health = 50 + 100 * index * 0.7
	var damage = 10 + 20 * index * 1.3
	
	if Data.player.gold >= price:
		Data.player.gold = Data.player.gold - price
		print(Data.playerarmy)
		Data.playerarmy.append({
			"Red": randi_range( 0, 250),
			"Green":randi_range( 0, 250),
			"Blue": randi_range( 0, 250),
			"health": health,
			"damage": damage,
		})
	else:
		printerr("SKEERE BOEF JE HEBT GEEN GELD")
	
	get_myarmy()
	get_soldarmy()


func _on_shop_list_focus_exited():
	$CanvasLayer/UI/BarracksPanel/Container/ShopList.grab_focus()


func _on_my_armylist_item_selected(index):
	$CanvasLayer/UI/BarracksPanel/Container/SELLButton.disabled = false
	$CanvasLayer/UI/BarracksPanel/Container/BUYButton.disabled = true
	selindex = index
	
	var selecteditem = Data.playerarmy[index-1]
	
	generatedprice = selecteditem.health * 0.75 + selecteditem.damage + 20
	var health = selecteditem.health
	var damage = selecteditem.damage

	
	$CanvasLayer/UI/BarracksPanel/Container/Label3.text = "price: " + str(generatedprice) + "\ndamage: " + str(damage)
	$CanvasLayer/UI/BarracksPanel/Container/GHLabel.text = "my gold: " + str(Data.player.gold) + "\nhealth: " + str(health)


func _on_sell_button_up():
	#get index
	var shoplist = $CanvasLayer/UI/BarracksPanel/Container/myArmylist
	var selecteditemindex 
	
	if shoplist.is_anything_selected():
		selecteditemindex = shoplist.get_selected_items()[0]
		print(Data.playerarmy[selecteditemindex])
	else:
		printerr("no item was selected")
		return
	
	var price
	var damage = Data.playerarmy[selecteditemindex].damage
	var health = Data.playerarmy[selecteditemindex].health
	
	if generatedprice:
		price = generatedprice
	else:
		printerr("ERROR: no price was calculated")
	#subject to balancing!
	
	Data.player.gold = Data.player.gold + price
	Data.playerarmy.pop_at(selecteditemindex)
	
	#calculate apropriate selling price
	#remove from database
	#update money
	$CanvasLayer/UI/BarracksPanel/Container/Label3.text = "price: " + str(price) + "\ndamage: " + str(damage)
	$CanvasLayer/UI/BarracksPanel/Container/GHLabel.text = "my gold: " + str(Data.player.gold) + "\nhealth: " + str(health)
	
	get_myarmy()
	get_soldarmy()

