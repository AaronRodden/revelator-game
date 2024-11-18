extends Node

var training_mode = false
var current_song

var SONG_LIST = [
	"res://assets/music/bounty.mp3",
	"res://assets/music/champions.mp3",
	"res://assets/music/dandy.mp3",
	"res://assets/music/enchantress.mp3",
	"res://assets/music/enchantress2.mp3",
	"res://assets/music/guest.mp3",
	"res://assets/music/knight.mp3",
	"res://assets/music/mole.mp3",
	"res://assets/music/plague.mp3",
	"res://assets/music/polar.mp3",
	"res://assets/music/propeller.mp3",
	"res://assets/music/rival.mp3",
	"res://assets/music/spectre.mp3",
	"res://assets/music/tinker.mp3",
	"res://assets/music/tinker2.mp3"]

var rng = RandomNumberGenerator.new()

var RMAGE_START_POS = Vector2(720, 904)
var BMAGE_START_POS = Vector2(1184, 320)
var RMAGE_BREAK_TARGETS_START_POS = Vector2(945, 595)
var BMAGE_BREAK_TARGETS_START_POS = Vector2(-1, -1) # Bmage not part of Break The Targets right now
var ROUND_WINS_MAX = 3

var p1_score = 0
var p2_score = 0

## **TODO** Add an input manager / controller organizer. This could be a stretch goal.

func _set_training_mode():
	training_mode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Controller Connections
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	$Rmage.connect("spell_input", $HUD.spell_display.bind(0), 0)
	$Rmage.connect("spell_cast", $HUD.clear_spell_inputs.bind(0), 0)
	$Rmage.connect("auto_attack_cast", $HUD.auto_attack_timer_UI.bind(0), 0)

	
	$Bmage.connect("spell_input", $HUD.spell_display.bind(1), 0)
	$Bmage.connect("spell_cast", $HUD.clear_spell_inputs.bind(1), 0)
	$Bmage.connect("auto_attack_cast", $HUD.auto_attack_timer_UI.bind(1), 0)


	$HUD.start_game.connect($Arena.set_arena)
		
	if Global.training_mode:
		$HUD.start_game.connect(start_training_mode)
	elif Global.break_the_targets:
		$Arena.connect("red_target_hit", $HUD.red_target_hit)
		$Arena.connect("gold_target_hit", $HUD.gold_target_hit)
		$Arena.connect("mage_hit", $HUD.target_mage_hit)
		$HUD.start_game.connect(start_break_the_targets)
	else:
		$HUD.start_game.connect(new_game)
		
	$MainMenu/MainMenuMusic.stop()
	
func _process(_delta):
	if Global.start_flag:
		if Input.is_action_just_released("start"):
			_on_pause_button_pressed()
	
func new_round():
	$Rmage.controller_lock = true
	$Bmage.controller_lock = true
	
	# Remove all existing fireballs 
	for N in self.get_children():
		print(N)
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
	$Rmage.visible = true
	$Bmage.visible = true
	current_song = null # new song
	$TrainingModeMusic.stop()
	start_music()
	new_round()
	
	$Rmage.hit.connect(bmage_round_win)
	$Bmage.hit.connect(rmage_round_win)
	
func start_training_mode():
	$Rmage.visible = true
	$Bmage.visible = true
	$Rmage.controller_lock = false
	$Bmage.controller_lock = false
	$TrainingModeMusic.play()
	
	$Rmage.start(RMAGE_START_POS)
	$Bmage.start(BMAGE_START_POS)
	
	Global.training_mode = false
	$HUD.start_game.connect(new_game)
	
# TODO: Should I figure out how to remove Bmage? Right now it is funny...
func start_break_the_targets():
	$Rmage.visible = true  # Only Rmage visible for break the targets
	$Rmage.controller_lock = false
	$BreakTheTargetsMusic.play()
	$BreakTheTargetsMusic.stream.loop = true
	
	$Rmage.start(RMAGE_BREAK_TARGETS_START_POS)
	$Bmage.start(BMAGE_BREAK_TARGETS_START_POS)

	$Arena.start_targets()
	Global.break_the_targets = false
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
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
	new_round()

func victory():
	$MainMusic.stop()
	$VictoryTheme.play()

func start_music():
	var rand_nb = rng.randi_range(0, SONG_LIST.size()-1)
	if current_song == null:
		current_song = load(SONG_LIST[rand_nb])
	$MainMusic.set_stream(current_song)
	$MainMusic.play()
	$MainMusic.stream.loop = true

func _on_audio_stream_player_finished():
	start_music()

# BUG: When leaving pause menu game recognizes cross / B input
# Pause Menu Functionallity
func _on_pause_button_pressed():
	$PauseMenu.visible = true
	$PauseMenu/ButtonContainer/ResumeButton.grab_focus()
	Global.pause_flag = true
	get_tree().paused = true
