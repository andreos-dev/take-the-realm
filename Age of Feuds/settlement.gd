extends Node2D

@export var faction = "Iberia"
@export var size = 3
@export var friendly = false
@export var naam = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body.name == "player":
		if self.get_parent().get_parent().has_method("settlementEntered"):
			self.get_parent().get_parent().settlementEntered(self)

func _on_area_2d_body_exited(body):
	if body.name == "player":
		if self.get_parent().get_parent().has_method("settlementExit"):
			self.get_parent().get_parent().settlementExit(self)
			print("settlement sees player exits!")
