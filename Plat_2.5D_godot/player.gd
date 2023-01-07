extends KinematicBody
 
 
const MOVE_SPEED = 5
const JUMP_FORCE = 6
const GRAVITY = 9.8
const MAX_FALL_SPEED = 30
var y_velo = 0
var facing_right = false
 
onready var anim_player = $character/AnimationPlayer
 
func _physics_process(delta):
	
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if Input.is_action_pressed("boost"):
		move_dir *= 4
		
 
	move_and_slide(Vector3(move_dir * MOVE_SPEED, y_velo, 0), Vector3(0,1,0))
 
	var just_jumped = false
	var just_crouched = false;
	var grounded = is_on_floor()
	y_velo -= GRAVITY * delta
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	if grounded:
		y_velo = 0
		
		
		if Input.is_action_pressed("jump"):
			y_velo = JUMP_FORCE
			just_jumped = true
 
	if move_dir < 0 and facing_right:
		flip()
	if move_dir > 0 and !facing_right:
		flip()
 
	if(just_jumped):
		play_anim("Jump")
		pass
	elif grounded:
		if move_dir == 0:
			if(Input.is_action_pressed("crouch")):
				play_anim("Crouch_Idle")
			else: play_anim("Standing_Idle")
			
		else:
			play_anim("Running")
 
func flip():
	$character.rotation_degrees.y *= -1
	print(rotation_degrees.y)
	facing_right = !facing_right
 
func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)
