extends Node

var training_mode = false
var current_song

var MUSIC_PATH = "res://assets/music/"
var rng = RandomNumberGenerator.new()

var RMAGE_START_POS = Vector2(343, 457)
var BMAGE_START_POS = Vector2(684, 121)
var ROUND_WINS_MAX = 3

var p1_score = 0
var p2_score = 0

## **TODO** Add an input manager / controller organizer. This could be a stretch goal.

func _set_training_mode():
	training_mode = true

func get_all_songs():
	var dir = DirAccess.open(MUSIC_PATH)
	var contents = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".mp3"):
				contents.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the music.")
	return contents

# Called when the node enters the scene tree for the first time.
func _ready():
	# Controller Connections
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	$Rmage.connect("spell_input", $HUD.spell_display.bind(0), 0)
	$Rmage.connect("spell_cast", $HUD.clear_spell_inputs.bind(0), 0)

	
	$Bmage.connect("spell_input", $HUD.spell_display.bind(1), 0)
	$Bmage.connect("spell_cast", $HUD.clear_spell_inputs.bind(1), 0)


	$HUD.start_game.connect($Arena.set_arena)
		
	if Global.training_mode:
		$HUD.start_game.connect(start_training_mode)
	else:
		$HUD.start_game.connect(new_game)
		
	$MainMenu/MainMenuMusic.stop()
	
func _process(_delta):
	if Global.start_flag:
		if Input.is_action_just_released("start"):
			_on_pause_button_pressed()
	#if Global.pause_flag:
		#$ResumeButton.grab_focus()
		#if Input.is_action_just_released("down_spell"):
			#$MainMenuButton.grab_focus()
		#if Input.is_action_just_released("up_spell"):
			#$ResumeButton.grab_focus()
		#
		## P2 Menuing
		#if Input.is_action_just_released("down_spell_p2"):
			#$MainMenuButton.grab_focus()
		#if Input.is_action_just_released("up_spell_p2"):
			#$ResumeButton.grab_focus()
	
func new_round():
	$Rmage.controller_lock = true
	$Bmage.controller_lock = true
	
	# Remove all existing fireballs 
	for N in self.get_children():
		if N.name.contains("Area2D") or N.name.contains("Landmine"):
			N.queue_free()
	
	$Rmage.start(RMAGE_START_POS)
	$Bmage.start(BMAGE_START_POS)
	
	for i in range(3, -1, -1):
		$HUD.round_countdown(i)
		if i > 0:
			await get_tree().create_timer(1).timeout
	
	$Rmage.controller_lock = false
	$Bmage.controller_lock = false
	
func new_game():
	current_song = null # new song
	$TrainingModeMusic.stop()
	start_music()
	new_round()
	
	$Rmage.hit.connect(bmage_round_win)
	$Bmage.hit.connect(rmage_round_win)
	
func start_training_mode():
	$TrainingModeMusic.play()
	
	$Rmage.start(RMAGE_START_POS)
	$Bmage.start(BMAGE_START_POS)
	
	Global.training_mode = false
	$HUD.start_game.connect(new_game)
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#funcr _process(delta):
	#pass
	
func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id))
	else:
		print("Keyboard")

func rmage_round_win():
	p1_score += 1
	$HUD.round_win(0)
	
	if p1_score == ROUND_WINS_MAX:
		victory()
		$HUD.victory(0)
		# Basic victory condition logic, return to main menu
		await get_tree().create_timer(8).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
		return
	
	await get_tree().create_timer(2).timeout
	new_round()
	
func bmage_round_win():
	p2_score += 1
	$HUD.round_win(1)
	
	if p2_score == ROUND_WINS_MAX:
		victory()
		$HUD.victory(1)
		# Basic victory condition logic, return to main menu
		await get_tree().create_timer(8).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
		

	await get_tree().create_timer(2).timeout
	start_round()

func start_round():
	$Rmage.start(RMAGE_START_POS)
	$Bmage.start(BMAGE_START_POS)

func victory():
	$MainMusic.stop()
	$VictoryTheme.play()

func start_music():
	var songs = get_all_songs()
	var rand_nb = rng.randi_range(0, songs.size()-1)
	if current_song == null:
		current_song = load(MUSIC_PATH + songs[rand_nb])
	$MainMusic.set_stream(current_song)
	$MainMusic.play()

func _on_audio_stream_player_finished():
	start_music()

# BUG: When leaving pause menu game recognizes cross / B input
# Pause Menu Functionallity
func _on_pause_button_pressed():
	$PauseMenu.visible = true
	$PauseMenu/ButtonContainer/ResumeButton.grab_focus()
	Global.pause_flag = true
	get_tree().paused = true
