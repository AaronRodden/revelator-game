extends MarginContainer

signal training_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/VBoxContainer/VersusButton.grab_focus()
	$MainMenuMusic.play()
	
	# Reset Globals
	Global.start_flag = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO: Add Menuing sound FX
	# P1 Menuing
	if Input.is_action_just_released("ui_down"):
		focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	if Input.is_action_just_released("ui_up"):
		focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")
		
	# P2 Menuing
	if Input.is_action_just_released("ui_down"):
		focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	if Input.is_action_just_released("ui_up"):
		focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")


func _on_versus_button_pressed():
	$MainMenuMusic.stop()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_training_button_pressed():
	Global.training_mode = true
	$MainMenuMusic.stop()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

# TODO: Implement this transition
func _on_break_the_targets_button_pressed():
	Global.break_the_targets = true
	$MainMenuMusic.stop()
	get_tree().change_scene_to_file("res://main.tscn")
