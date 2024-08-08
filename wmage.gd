extends PhysicsBody2D

signal hit
signal spell_input
signal spell_completed 
signal spell_cast

var screen_size
var velocity
var spell_book_position
var curr_spell

@export var controller_lock = false
@export var speed = 225
var lookvector = Vector2.ZERO
var input_buffer = []

var bmage_moves = {
	"light_fireball": ["down", "right", "y"], 
	"medium_fireball": ["down", "left", "x"], 
	"heavy_fireball": ["right", "down", "right", "b"], 
	"special_move": ["left", "down", "right", "a"], 
	"ice_punch": ["right", "down", "right", "y"]
	}

#**NOTE**
#This script is nearly identical to the b_mage script. This is a HACK and is temporary as 
#I am learning how godot works.

# As of not I am deciding to go forward with this hackey fix, if any additions to this game are made,
# specifically with how characters work... then it may be time to refactor!


## W-Mage Control Scheme
# L-stick: movement
# R-stick: aiming
# D-Pad: Spell Casting Directional Inputs
# Face Buttons: Spell Casting Button Inputs
# R1: Ward / Shield
# R2: Shoot Preped Spell
# L1: Dodge
# L2: <>

	# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	spell_book_position = $SpellBook.position


func _process(delta):
	
	if controller_lock:
		return
	
	# Player Movement
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right_move_p2"):
		velocity.x += 1
	if Input.is_action_pressed("left_move_p2"):
		velocity.x -= 1
	if Input.is_action_pressed("down_move_p2"):
		velocity.y += 1
	if Input.is_action_pressed("up_move_p2"):
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
	lookvector.x = (Input.get_action_strength("right_aim_p2") - Input.get_action_strength("left_aim_p2"))
	lookvector.y = (Input.get_action_strength("down_aim_p2") - Input.get_action_strength("up_aim_p2"))
	$SpellBook.position = spell_book_position + lookvector * 20
	
	# TODO: Add cast sound FX
	if Input.is_action_just_pressed("shoot_spell_p2"):
		emit_signal("spell_cast")
		$SpellBook.cast_spell(lookvector, self.name)
		input_buffer = []
		
	
	# Player Spellcasting
	if Input.is_action_just_released("right_spell_p2"):
		input_buffer.push_back("right")
		emit_signal("spell_input", "right_p2")
	if Input.is_action_just_released("left_spell_p2"):
		input_buffer.push_back("left")
		emit_signal("spell_input", "left_p2")
	if Input.is_action_just_released("down_spell_p2"):
		input_buffer.push_back("down")
		emit_signal("spell_input", "down_p2")
	if Input.is_action_just_released("up_spell_p2"):
		input_buffer.push_back("up")
		emit_signal("spell_input", "up_p2")
		
	if Input.is_action_just_released("a"):
		input_buffer.push_back("a")
		emit_signal("spell_input", "a")
	if Input.is_action_just_released("b"):
		input_buffer.push_back("b")
		emit_signal("spell_input", "b")
	if Input.is_action_just_released("x"):
		input_buffer.push_back("x")
		emit_signal("spell_input", "x")
	if Input.is_action_just_released("y"):
		input_buffer.push_back("y")
		emit_signal("spell_input", "y")
	
	for move in bmage_moves:
		if bmage_moves[move] == input_buffer: 
			input_buffer = []
			emit_signal("spell_completed") # TODO: Add load sound FX
			$SpellBook.new_spell(move, self.name)
	
func start(pos):
	position = pos
	show()
	if Global.training_mode: # Hurtboxes turned off
		$Hurtbox.get_child(0).set_deferred("disabled", true)
	else: # Hurtboxes turned on
		$Hurtbox.get_child(0).set_deferred("disabled", false)
	$CollisionShape2D.disabled = false
	$CollisionShape2D.set_deferred("disabled", false)

func _physics_process(_delta):
	move_and_collide(Vector2(0, 0)) # Move down 1 pixel per physics frame

# TODO: Add hit sound FX
func _on_hurtbox_area_entered(area):
	if area.caster != self.name and area.caster != null:
		hide()  # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$Hurtbox.get_child(0).set_deferred("disabled", true)
