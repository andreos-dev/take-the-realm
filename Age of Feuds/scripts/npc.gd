extends CharacterBody2D

const SPEED = 100.0
const VERTICAL_SPEED = 50

var target_position = null
var target = null

var coolingdown = false
var searchrest = false
var corpse = preload("res://corpse.tscn")
var hascorpse = false

var red = 100
var green = 100
var blue = 250

@export var attack_damage = 10
@export var hp = 100
@export var hat = ""
var myteam = ""

var strawhat1 = preload("res://sprites/strawhat.png")
var strawhat2 = preload("res://sprites/strawhat2.png")
var strawhat3 = preload("res://sprites/strawhat3.png")


var asked = false #asked a function when dead...

#simple yet all powerfull state machine <3
enum {
	SEARCH, #search closest enemy, when found proceed to MOVE
	MOVE, #move towards closest enemy until this is in ATTACK range
	ATTACK, #proceed to ATTACK enemy until it or you is dead! then move to SEARCH another one!
	DEAD #sad song... ding dong...
}

var state = SEARCH

func _ready():
	randomize()
	
	if self.is_in_group("team1"):
		$ringsprite.self_modulate = Color8(20,255,20)
		myteam = "team1"
	elif self.is_in_group("team2"):
		$ringsprite.self_modulate = Color8(255,20,20)
		myteam = "team2"
	
	
	$Sprite2D.self_modulate = Color8(red, green, blue, 255)
	$hatsprite.modulate = Color8(255,255,255,255)
	
	if hat == "": #this is a peasant with no hat
		if randf() <= 0.25:
			$hatsprite.texture = strawhat1
		elif randf() <= 0.5:
			$hatsprite.texture =  strawhat2
		elif randf() <= 0.75:
			$hatsprite.texture =  strawhat3
		else:
			$hatsprite.texture =  Sprite2D
		
		
	
	randomize()
	
	#if on team1: get data from data.gd and equip this NPC with its weapons and armor sprites!
	#if on team2: this enemy should have randomly and accurately generated equipment and damage for itself

func _physics_process(delta):
	match state:
		SEARCH:
			search_state()
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		DEAD:
			dead_state()
		
	


func search_state():
	#find and set target_position!
	var seenbodies
	$CollisionShape2D.debug_color = Color(200, 0, 130, 255)#roze
	
	if $SearchArea2D.has_overlapping_bodies():
		seenbodies = $SearchArea2D.get_overlapping_bodies()
		for i in seenbodies.size():
			
			if ((seenbodies[i].position != self.position) && seenbodies[i].is_in_group(myteam) == false):
				target_position = seenbodies[i].position
				target = seenbodies[i]
		
	else: 
		#no target_position is seen so he should move 
		target_position = null
	
	if hp <= 0:
		state = DEAD
	else:
		state = MOVE
	
func move_state(delta):
	var target_positionposition
	
	if target_position:
		target_positionposition = target_position
		var direction = (target_positionposition - global_position).normalized()
		
		if target_positionposition.distance_to(global_position) < 25:
			state = ATTACK
		else:
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * VERTICAL_SPEED
			
			#position has to update 
			if searchrest:
				state = SEARCH
					
		
		
	else:
		#no target_position was seen yet!
		target_positionposition = Vector2(randi_range(60, 160),randi_range(160,220)) #the middle of the screen
		
		var direction = (target_positionposition - position).normalized()
		velocity.x= direction.x * SPEED
		velocity.y= direction.y * VERTICAL_SPEED
		
		if(randi_range(0,25) <= 2):
			state = SEARCH
	
	$CollisionShape2D.debug_color = Color(70, 70, 255, 255)# blue
	move_and_slide()

func get_team(target):
	var targetteam = ""
	
	if target.is_in_group("team1"):
		targetteam = "team1"
	elif target.is_in_group("team2"):
		targetteam = "team2"
	
	return targetteam

func attack_state(delta):
	if target.has_method("damaged") && coolingdown == false && self.position.distance_to(target.position) <= 13:
		
		var targetteam = get_team(target)
		
		if targetteam != myteam:
			
			$CollisionShape2D.debug_color = Color(250, 130, 0, 255) #orange
			
			target.damaged(attack_damage, self)
			coolingdown = true
			$AttackTimer.start()
			$AnimationPlayer.play("slash")
			state = SEARCH
		
	else:
		state = SEARCH


func _on_search_area_2d_body_entered(body):
	state= SEARCH


func _on_attack_timer_timeout():
	coolingdown = false


func _on_searchrest_timer_timeout():
	searchrest = false

func dead_state():
	$AnimationPlayer.play("stand")
	$Sprite2D.self_modulate = Color(255,0, 0, 0)
	$CollisionShape2D.disabled = true
	$SearchArea2D/CollisionShape2D.disabled = true

	if asked == false && self.get_parent().has_method("i_died"):
		self.get_parent().i_died(self)
		asked = true
		
	
#	if corpse.can_instantiate():
#		var newcorpse = corpse.instantiate()
#		newcorpse.position = self.position
#
#		if hascorpse == false:
#			self.get_parent().add_child(newcorpse)
#			hascorpse = true
#	else:
#		printerr("could not instantiate corpse scene! ")
	

func damaged(attack_damage, culprit):
	$CollisionShape2D.debug_color = Color(255, 0, 0, 200) #red
	$CPUParticles2D.color = Color8(red, green, blue, 255)
	$CPUParticles2D.emitting = true
	hp -= attack_damage
	
	target = culprit
	target_position = culprit.position
	
	if hp <= 0:
		state = DEAD
		if self.get_parent().has_method("check_deaths"):
			self.get_parent().check_deaths()


func _process(delta):
	animate()

func animate():
	if velocity.x >= 0.1: #runs right
		$AnimationPlayer.play("run")
		$swordy.flip_v = false
		$swordy.rotation_degrees= 0
		$Sprite2D.flip_h = false
	elif velocity.x <= -0.1: #runs left
		$AnimationPlayer.play("run")
		$swordy.flip_v = true
		$swordy.rotation_degrees= -180
		$Sprite2D.flip_h = true
	elif velocity.x == 0 && velocity.y == 0:
		$AnimationPlayer.play("stand")

	if velocity.y >= 0.1:
		$AnimationPlayer.play("run")
	elif velocity.y <= -0.1:
		$AnimationPlayer.play("run")
	
	if state == ATTACK or Input.is_action_just_pressed("attack") && coolingdown:
		$AnimationPlayer2.play("slash")


func _on_closearea_body_entered(body):
	if get_team(body) != myteam:
		target = body
		state = ATTACK
