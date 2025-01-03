extends Area2D

@export var speed = 175
@export var target_type = "red"

var normal_target_path = "res://assets/target.png"
var gold_target_path = "res://assets/target_gold.png"

var velocity = Vector2(0,0)
var caster = "target"

var screen_size

signal hit
signal hit_mage

func set_target(type, velocity_vector, speed_modifier):
	match type:
		"normal":
			$TargetRed.visible = true
		"gold":
			$TargetGold.visible = true
			target_type = "gold"
	self.velocity = velocity_vector
	self.speed = speed_modifier
	
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# TODO: Can I give gold targets more interesting behavior
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta
	

func _on_area_entered(area):
	# TODO: This hurtbox stuff is a mess :)
	if area.name == "RmageHurtbox" or area.name == "WmageHurtbox":
		hide()
		hit_mage.emit()
		$MageHitSound.play()
		return
	if area.caster.contains("mage"):
		hide()  # Target disappears after being hit.
		hit.emit()
		$TargetHitSound.play()
		$CollisionShape2D.set_deferred("disabled", true)

