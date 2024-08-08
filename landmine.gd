extends Area2D

signal hit

var screen_size
var caster 

var velocity = Vector2(0.0, 0.0)
var castFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func cast(_lookvector):
	# set velocity at time of cast then pass too process to carry it to end of screen
	castFlag = true

func set_caster(current_caster):
	caster = current_caster

func _on_body_entered(body):
	if body.name != caster:
		$LandmineSprite.visible = false
		$ExplosionSprite.visible = true
		emit_signal("hit")

func _on_area_entered(_area):
	emit_signal("hit")
