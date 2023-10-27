extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		var playerposx
		var playerposy
		
		if int(Data.player.posx) == body.global_position.x && int(Data.player.posy) == body.global_position.y:
			print("player pos like data!: ",Data.player.posx,"(x,y)", Data.player.posy)
			print("body pos!: ",body.global_position.x,"(x,y)", body.global_position.y)
			return
		else:
			randomize()
			
			if randf() <= 0.05:
				Data.battle = "random" #to be changed if it is a city
				playerposx = body.position.x
				playerposy = body.position.y
				Data.player.posx = playerposx
				Data.player.posy = playerposy
				print("set playerpos: ",playerposx,"(x,y)", playerposy)
				randomize()
				self.get_tree().change_scene_to_file("res://battlegenerator.tscn")
			else:
				print("Evaded battle")
				pass
