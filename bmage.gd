extends PhysicsBody2D

signal hit
signal spell_input
signal spell_completed 
signal spell_cast
signal auto_attack_cast

var screen_size
var velocity
var spell_book_position
var curr_spell

@export var controller_lock = true
@export var speed = 275
var lookvector = Vector2.ZERO
var input_buffer = []
var input_count = 0
var max_input_count = 4

# Auto Attack timer and variables
var auto_attack_timer = Timer.new()
var auto_attack_flag = true

var rmage_moves = {
	"light_fireball": ["down", "right", "square"], 
	"medium_fireball": ["down", "left", "triangle"], 
	"interim_dp_input": ["right", "down", "right"],  # TODO: This is kinda hacky
	"heavy_fireball": ["right", "down", "right", "cross"], 
	"interim_half_circle_input": ["left", "down", "right"],  # TODO: This is kinda hacky
	"special_move": ["left", "down", "right", "circle"], 
	"ice_punch": ["right", "down", "right", "square"]
	}


## B-Mage Control Scheme
# L-stick: movement
# R-stick: aiming
# D-Pad: Spell Casting Directional Inputs
# Face Buttons: Spell Casting Button Inputs
# R1: Auto-attack
# R3: Shoot Preped Spell
# L1: Dodge
# L2: <>

func _on_auto_attack_timeout():
	auto_attack_flag = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	spell_book_position = $SpellBook.position
	auto_attack_timer.connect("timeout", _on_auto_attack_timeout, 0)
	auto_attack_timer.wait_time = Global.AUTO_ATTACK_TIMEOUT
	add_child(auto_attack_timer)

func _process(delta):
	
	if controller_lock:
		return
	
	# Player Movement
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right_move"):
		velocity.x += 1
	if Input.is_action_pressed("left_move"):
		velocity.x -= 1
	if Input.is_action_pressed("down_move"):
		velocity.y += 1
	if Input.is_action_pressed("up_move"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Character Animations
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x > 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
	
	# Player aiming
	lookvector.x = (Input.get_action_strength("right_aim") - Input.get_action_strength("left_aim"))
	lookvector.y = (Input.get_action_strength("down_aim") - Input.	get_action_strength("up_aim"))
	$SpellBook.position = spell_book_position + lookvector * 20
	
	# Player aiming rotations
	var deadzone = 0.5
	var controllerangle = Vector2.ZERO.angle()
	var xAxisRL = (Input.get_action_strength("right_aim") - Input.get_action_strength("left_aim"))
	var yAxisUD = (Input.get_action_strength("down_aim") - Input.	get_action_strength("up_aim"))

	if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
		controllerangle = Vector2(xAxisRL, yAxisUD).angle()
		if $SpellBook.get_children().size() > 0:
			$SpellBook.get_children()[0].rotation = controllerangle
	
	# Player Casting
	if Input.is_action_just_pressed("shoot_spell") or Input.is_action_just_pressed("shoot_spell_alt"):
		emit_signal("spell_cast")
		$SpellBook.cast_spell(lookvector, controllerangle,  self.name)
		input_buffer = []
		input_count = 0
		
	if Input.is_action_just_released("shoot_spell") or Input.is_action_just_released("shoot_spell_alt"):
		$SpellBook.release_spell(lookvector, controllerangle,  self.name)
	
	# Player Auto-Attacking	
	if Input.is_action_just_pressed("auto_attack"):
		if auto_attack_flag:
			$SpellBook.cast_auto_attack(lookvector, controllerangle, self.name)
			auto_attack_flag = false
			emit_signal("auto_attack_cast")
			auto_attack_timer.start()
	
	# Player Spellcasting
	if input_count < max_input_count:
		if Input.is_action_just_released("right_spell"):
			input_buffer.push_back("right")
			emit_signal("spell_input", "right")
			input_count += 1
		if Input.is_action_just_released("left_spell"):
			input_buffer.push_back("left")
			emit_signal("spell_input", "left")
			input_count += 1
		if Input.is_action_just_released("down_spell"):
			input_buffer.push_back("down")
			emit_signal("spell_input", "down")
			input_count += 1
		if Input.is_action_just_released("up_spell"):
			input_buffer.push_back("up")
			emit_signal("spell_input", "up")
			input_count += 1
		
		if Input.is_action_just_released("triangle"):
			input_buffer.push_back("triangle")
			emit_signal("spell_input", "triangle")
			input_count += 1
		if Input.is_action_just_released("circle"):
			input_buffer.push_back("circle")
			emit_signal("spell_input", "circle")
			input_count += 1
		if Input.is_action_just_released("cross"):
			input_buffer.push_back("cross")
			emit_signal("spell_input", "cross")
			input_count += 1
		if Input.is_action_just_released("square"):
			input_buffer.push_back("square")
			emit_signal("spell_input", "square")
			input_count += 1
	
	# Insta-clear when you mess up inputs
	if input_buffer.size() >= 3:
		var spell_match = false
		for move in rmage_moves:
			if rmage_moves[move] == input_buffer:
				if move.contains("interim"):
					spell_match = true
					break
				input_buffer = []
				emit_signal("spell_completed")  # TODO: Add load sound FX
				$SpellBook.new_spell(move, self.name)
				$CorrectSpell.play()
				spell_match = true
		if spell_match == false:
			input_buffer = []
			input_count = 0
			$SpellBook.new_spell(null, self.name)
			$SpellBook.cast_spell(null, null,  self.name)
			$WrongSpell.play()
			emit_signal("spell_cast")
		spell_match = false
			
	
func start(pos):
	position = pos
	show()
	if Global.training_mode: # Hurtboxes turned off
		$RmageHurtbox.get_child(0).set_deferred("disabled", true)
	else: # Hurtboxes turned on
		$RmageHurtbox.get_child(0).set_deferred("disabled", false)
	$CollisionShape2D.disabled = false
	$CollisionShape2D.set_deferred("disabled", false)

func _physics_process(_delta):
	move_and_collide(Vector2(0, 0)) # Move down 1 pixel per physics frame
	
	
func turn_off_hurtbox():
	$RmageHurtbox.get_child(0).set_deferred("disabled", true)

# TODO: Add hit sound FX
func _on_hurtbox_area_entered(area):
	## TODO: Tech debt, can we avoid cases for every hurtbox interaction?
	if area.caster == "target":
		return
	elif area.caster != self.name and area.caster != null:
		hide()  # Player disappears after being hit.
		hit.emit()
		$HitSound.play()
		$CollisionShape2D.set_deferred("disabled", true)
		turn_off_hurtbox()
