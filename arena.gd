extends StaticBody2D

#var TARGET_SPAWNERS_POS = [
	#Vector2(80,250), Vector2(80,450), Vector2(280,650),
	#Vector2(620,900), Vector2(820,900), Vector2(1480, 250),
	#Vector2(1480,450), Vector2(1480,650), Vector2(620, -50),
	#Vector2(820, -50)]
	
var TargetSpawner = preload("res://target_spawner.tscn")

signal gold_target_hit
signal red_target_hit
signal mage_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	set_arena()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(_delta):
	pass

func set_arena():
	if Global.training_mode:
		$TrainingModeWall.disabled = false
		$TrainingModeWall.visible = true
		$TrainingModeWall/WallTexture.visible = true
	else:
		$TrainingModeWall.disabled = true
		$TrainingModeWall.visible = false
		$TrainingModeWall/WallTexture.visible = false

# Arena will be in charge of counting targets due to it being the middleman between
# targets and main
func count_target_hit(target_value):
	if target_value == Global.GOLD_TARGET_VAL:
		gold_target_hit.emit()
	elif target_value == Global.RED_TARGET_VAL:
		red_target_hit.emit()
		
func count_mage_hit():
	mage_hit.emit()
		
func start_targets():
	for N in self.get_children():
		if N.name.contains("target_spawner") or N.name.contains("TargetSpawner"):
			N.connect("red_target_hit", count_target_hit.bind(Global.RED_TARGET_VAL))
			N.connect("gold_target_hit", count_target_hit.bind(Global.GOLD_TARGET_VAL))
			N.connect("hit_mage", count_mage_hit)
			N.target_lock = false  # Start targets on start game button press
