#class_name Fireball
extends Area2D

var screen_size
var velocity

var speed = 400
var castFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# TODO: Destroy object once off screen?
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

