extends Node

var current_song

var MUSIC_PATH = "res://assets/music/"
var rng = RandomNumberGenerator.new()

var BMAGE_START_POS = Vector2(343, 457)
var WMAGE_START_POS = Vector2(684, 121)
var ROUND_WINS_MAX = 3

var p1_score = 0
var p2_score = 0

## **TODO** Add an input manager / controller organizer. This could be a stretch goal.

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
	
	$Bmage.connect("spell_input", $HUD.spell_display, 0)
	$Bmage.connect("spell_cast", $HUD.clear_spell_inputs, 0)
	$Bmage.hit.connect(wmage_round_win)
	
	$Wmage.connect("spell_input", $HUD.spell_display, 0)
	$Wmage.connect("spell_cast", $HUD.clear_spell_inputs, 0)
	$Wmage.hit.connect(bmage_round_win)
	
	$HUD.start_game.connect(new_game)
	
func new_round():
	$Bmage.controller_lock = true
	$Wmage.controller_lock = true
	
	# Remove all existing fireballs 
	for N in self.get_children():
		if N.name.contains("Area2D"):
			N.queue_free()
	
	$Bmage.start(BMAGE_START_POS)
	$Wmage.start(WMAGE_START_POS)
	
	for i in range(3, -1, -1):
		$HUD.round_countdown(i)
		if i > 0:
			await get_tree().create_timer(1).timeout
	
	$Bmage.controller_lock = false
	$Wmage.controller_lock = false
	
func new_game():
	current_song = null # new song
	start_music()
	new_round()
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id))
	else:
		print("Keyboard")

func bmage_round_win():
	p1_score += 1
	$HUD.round_win(0)
	
	if p1_score == ROUND_WINS_MAX:
		victory(0)
		$HUD.victory(0)
	
	await get_tree().create_timer(2).timeout
	new_round()
	
func wmage_round_win():
	p2_score += 1
	$HUD.round_win(1)
	
	if p2_score == ROUND_WINS_MAX:
		victory(1)
		$HUD.victory(1)

	await get_tree().create_timer(2).timeout
	start_round()

func start_round():
	$Bmage.start(BMAGE_START_POS)
	$Wmage.start(WMAGE_START_POS)

func victory(player):
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
