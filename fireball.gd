extends Area2D

signal hit

var screen_size
var caster 

var velocity = Vector2(0.0, 0.0)
var speed = 475
var castFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if castFlag:
		velocity.x += velocity.x
		velocity.y += velocity.y
		velocity = velocity.normalized() * speed
		position += velocity * delta

func cast(lookvector):
	# set velocity at time of cast then pass too process to carry it to end of screen
	velocity = lookvector
	castFlag = true
	$FireballCast.play()

func set_caster(current_caster):
	caster = current_caster
	if caster == "Rmage":
		$MagicMissleDieRed.visible = true
	elif caster == "Bmage":
		$MagicMissleDieBlue.visible = true

func _on_body_entered(_body):
	emit_signal("hit")
	$HitSound.play()

func _on_area_entered(_area):
	emit_signal("hit")
	$HitSound.play()
