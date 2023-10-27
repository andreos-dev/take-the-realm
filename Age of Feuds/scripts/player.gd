extends CharacterBody2D

@export var SPEED = 100.0
@export var VERTICAL_SPEED = 50

@export var hp = 100
var damage
var canattack = true

enum {
	MOVE, #MOVE around with keyboard keys, open for input to attack state
	ATTACK, #try to attack, and then keep MOVE-ing
	DEAD #show game over screen,.. end of the road!
}

var state = MOVE

func _ready():
	hp = Data.player["health"]
	damage = Data.player.damage

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		DEAD:
			dead_state()
		ATTACK:
			attack_state()


func move_state(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_direction = Input.get_axis("ui_left", "ui_right")
	var vertical_direction = Input.get_axis("ui_up", "ui_down")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if vertical_direction:
		velocity.y = vertical_direction * VERTICAL_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, VERTICAL_SPEED)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func _process(_delta):
	animate()

func animate():
	if state == ATTACK or Input.is_action_pressed("attack") && canattack:
		$AnimationPlayer2.play("slash")
	
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
	

func dead_state():
	$Sprite2D.self_modulate = Color(255, 0, 0, 255)
	#game over screen

func attack_state():
	var candidates = $AttackArea2D.get_overlapping_bodies()
	
	for i in candidates:
		if i.name != self.name && i.has_method("damaged") && i.is_in_group("team2") && canattack:
			i.damaged(damage, self)
			canattack = false
			$attackTimer.start()
	
	state = MOVE

func damaged(attack_damage, _culprit):
	hp -= attack_damage
	
	if self.get_parent().has_method("change_healthbar"):
		self.get_parent().change_healthbar(hp)
	
	if hp <= 0:
		state = DEAD
	

func _on_timer_timeout():
	canattack = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "slash":
		print("slashed!")
