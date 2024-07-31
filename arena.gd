extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_arena()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
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
