extends Area2D

signal hit

var screen_size
var caster 

var velocity = Vector2(0.0, 0.0)
var speed = 400
var castFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# TODO: Destroy object once off screen?
func _process(delta):
	if castFlag:
		velocity.x += velocity.x
		velocity.y += velocity.y
		velocity = velocity.normalized() * speed
		position += velocity * delta
		
#func _physics_process(delta):
	#var collision = move_and_collide(velocity * delta)
	#
	#while collision:
		#var collider = collision.get_collider()
		#
		#if collider is Player:
			#collider.hit()
			##queue.free()
			#break
		#else:
			#var normal = collision.get_normal()
			#var remainder = collision.get_remainder()
			#velocity = velocity.bounce(normal)
			##remainder = remainer.bounce(normal)
			#
			#collision = move_and_collide(remainder)

func cast(lookvector):
	# set velocity at time of cast then pass too process to carry it to end of screen
	velocity = lookvector
	castFlag = true

func _on_body_entered(body):
	print("hit something!")
	emit_signal("hit")


func _on_area_entered(area):
	print("hit something!")
	emit_signal("hit")
