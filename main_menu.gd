extends MarginContainer

signal training_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/VBoxContainer/VersusButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Add Menuing sound FX
	# P1 Menuing
	if Input.is_action_just_released("down_spell"):
		focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	if Input.is_action_just_released("up_spell"):
		focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")	
		
	# P2 Menuing
	if Input.is_action_just_released("down_spell_p2"):
		focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	if Input.is_action_just_released("up_spell_p2"):
		focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")


func _on_versus_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_training_button_pressed():
	Global.training_mode = true
	get_tree().change_scene_to_file("res://main.tscn")
