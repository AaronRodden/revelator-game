extends MarginContainer

signal resume_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO: Add Menuing sound FX
	# P1 Menuing
	if Input.is_action_just_released("down_spell"):
		focus_neighbor_bottom = NodePath("ButtonContainer/MainMenuButton")
		#$ButtonContainer/MainMenuButton.grab_focus()
	if Input.is_action_just_released("up_spell"):
		focus_neighbor_top = NodePath("ButtonContainer/ResumeButton")
		#$ButtonContainer/ResumeButtom.grab_focus()
		
	# P2 Menuing
	if Input.is_action_just_released("down_spell_p2"):
		focus_neighbor_bottom = NodePath("ButtonContainer/MainMenuButton")
	if Input.is_action_just_released("up_spell_p2"):
		focus_neighbor_top = NodePath("ButtonContainer/ResumeButton")


func _on_resume_button_pressed():
	self.visible = false
	Global.pause_flag = false
	get_tree().paused = false


func _on_main_menu_button_pressed():
	get_tree().paused = false
	Global.pause_flag = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
