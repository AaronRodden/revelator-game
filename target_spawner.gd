extends Sprite2D

var Target = preload("res://target.tscn")

var TARGET_BUFFER_MIN = 1
var TARGET_BUFFER_MAX = 5

signal gold_target_hit
signal red_target_hit
signal hit_mage

# TODO: Mess around with / try to find one seed 
var rng = RandomNumberGenerator.new()
var target_lock = true

var target_buffer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_lock: # Don't start targets until told
		return
		
	if $Timer.time_left <= 0:
		spawn_target()
		var target_buffer = rng.randi_range(TARGET_BUFFER_MIN, TARGET_BUFFER_MAX)
		$Timer.wait_time = target_buffer
		$Timer.one_shot = true
		$Timer.start()
		
func target_hit(target_val):
	if target_val == Global.GOLD_TARGET_VAL:
		gold_target_hit.emit()
	elif target_val == Global.RED_TARGET_VAL:
		red_target_hit.emit()
		
func mage_collision():
	hit_mage.emit()

func spawn_target():
	var new_target = Target.instantiate()
	# Radian Math:
	# -6.26 to 6.28 is the range of motion
	
	# -45 degree to 45 degree
	# -0.785 to 0.785
	var rotation_modifier = deg_to_rad(rng.randf_range(-45, 45))
	var velocity_vec = Vector2(150, 0).rotated(rotation_modifier)
	
	var special_target = rng.randi_range(0,4) # Decides if red or gold
	if special_target == 0:
		new_target.set_target("gold", velocity_vec)
		new_target.connect("hit", target_hit.bind(Global.GOLD_TARGET_VAL))
		new_target.connect("hit_mage", mage_collision)
	else:
		new_target.set_target("normal", velocity_vec)
		new_target.connect("hit", target_hit.bind(Global.RED_TARGET_VAL))
		new_target.connect("hit_mage", mage_collision)
	add_child(new_target)
	#new_target.reparent(get_parent().get_parent())
