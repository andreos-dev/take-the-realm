extends Node
#data presentented below is changed when loading in a safe file. Else these are the values when starting a new game
var battle = "random"
var victorious = false #resets after each battle

var temp = {
	"victorious": false,
	"xp":0,
	"gold":0
}

var playerarmy = [
	{
		"Red": 25,
		"Green":250,
		"Blue": 25,
		"health": 50,
		"damage": 10,
},
	{
		"Red": 25,
		"Green":200,
		"Blue": 25,
		"health": 50,
		"damage": 10,
},
	{
		"Red": 25,
		"Green":180,
		"Blue": 25,
		"health": 50,
		"damage": 10,
},

]

var enemyarmy = [
	{
		"Red": 250,
		"Green":25,
		"Blue": 25,
		"health": 100,
		"damage": 20,
},
	{
		"Red": 200,
		"Green":25,
		"Blue": 25,
		"health": 100,
		"damage": 20,
},
	{
		"Red": 180,
		"Green":25,
		"Blue": 25,
		"health": 100,
		"damage": 20,
},

]

var player = {
	"level": 1,
	"health": 999,
	"damage": 999,
	"experience": 0,
	"posx": 176,
	"posy": 192,
	"gold": 99000
}



var friendlycities = ["Nima"]
