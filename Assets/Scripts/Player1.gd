extends KinematicBody2D

const UP = Vector2(0,-1); #this is up, duh
const SPEED = 400; #maximum movement speed
const ACCELERATION = 110; #maximum acceleration
const JUMPFORCE = -550; #maximum jump force. negative because up is negative
const GRAVITY = 27; #personalized player gravity. N SHIT

var WEAPON #pseudo-constante  WORKAROUND FFFFUCKERS
var weapon
var motion = Vector2(); #motion vector which determines player move direction. used in func "move_in_slide()"
var friction = false; #friction
#steptimer?
var flip = false;  ###maybe for weapons? extra object?
var jumpforce = 0; #variable. jumpforce should be dynamically decreased by GRAVITY
#var dead = false;


func _ready():
	WEAPON = global.weapon0;
	#iNiTiAlIsIeRe deinen Shit hier!!
	weapon = WEAPON.instance()
	$GunPosition.add_child(weapon)
	#weapon.position = $GunPosition.position
	pass

func getPlayerNum():
	return 1

func move():
	
	#sprite speed scale
	$AnimatedSprite.speed_scale = 1   #using input strength animation speed can be regulated. see note 1
	
	if Input.is_action_pressed("right1"):
		flip = true
		if sign($GunPosition.position.x) == -1:
			$GunPosition.position.x *= -1;
			print($GunPosition.position.x)
		motion.x = min(motion.x+ACCELERATION, SPEED)*Input.get_action_strength("right1") #note 1
		if is_on_floor():
			$AnimatedSprite.play("run")#walk
			$AnimatedSprite.speed_scale = Input.get_action_strength("right1")
		$AnimatedSprite.flip_h = 1
	elif Input.is_action_pressed("left1"):
		flip = false
		if sign($GunPosition.position.x) == +1:
			$GunPosition.position.x *= -1;
			print($GunPosition.position.x)
		motion.x = max(motion.x-ACCELERATION, -SPEED)*Input.get_action_strength("left1") # note 1
		if is_on_floor():
			$AnimatedSprite.play("run")#walk
			$AnimatedSprite.speed_scale = Input.get_action_strength("left1")
		$AnimatedSprite.flip_h = 0
	else:
		friction = true
		$AnimatedSprite.play("idle")
	pass
	
func _physics_process(delta):
	
	motion.y += GRAVITY #Grtavity n sSIOHTiukswareh ölotis
	motion.y = min(motion.y, 800)	
	
	
	
	move()
	if is_on_floor():
		if Input.is_action_just_pressed("jump1"):
			jumpforce = -40
			motion.y = JUMPFORCE
		if friction == true:
			motion.x = lerp(motion.x,0,0.3)
	else:
		if Input.is_action_pressed("jump1"):
			motion.y += jumpforce
		jumpforce = lerp(jumpforce, 0, 0.1)
		if friction == true:
			motion.x = lerp(motion.x,0,0.1)
		if motion.y < 0:
			$AnimatedSprite.play("jumpUp")
			
		if motion.y > 0:
			$AnimatedSprite.play("jumpDown")
	
	
	if is_on_wall() and !is_on_floor(): #and !Input.is_action_pressed("ui_accept"):  #wall jump stuff. maybe climbing stuff as well. code not stuff. sorry
		motion.y = 100
		$AnimatedSprite.play("wall")
		weapon.enable(false)
		if flip == true:
			if Input.is_action_just_pressed("jump1") and Input.is_action_pressed("right1"):
				motion.y = JUMPFORCE*1.5
				motion.x = -SPEED*1.8
		else:
			if Input.is_action_just_pressed("jump1") and Input.is_action_pressed("left1"):
				motion.y = JUMPFORCE*1.5
				motion.x = SPEED*1.8
	else: 
		weapon.enable(true)
	
	if is_on_ceiling():
		motion.y += -JUMPFORCE/3
	
	
	friction = false  #FRICTION! Lets Grind baby
	

	
	motion = move_and_slide(motion, UP) # move and slide BITCH
	
	pass