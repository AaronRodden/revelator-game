extends Node

var current_song

var MUSIC_PATH = "res://assets/music/"
var rng = RandomNumberGenerator.new()

var BMAGE_START_POS = Vector2(343, 457)
var WMAGE_START_POS = Vector2(684, 121)

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
	$Bmage.hit.connect(victory)
	
	$Wmage.connect("spell_input", $HUD.spell_display, 0)
	$Wmage.connect("spell_cast", $HUD.clear_spell_inputs, 0)
	$Wmage.hit.connect(victory)
	
	# TODO: connect button here to new_game
	$HUD.start_game.connect(new_game)
	
func new_game():
	current_song = null # new song
	start_music()
	$Bmage.start(BMAGE_START_POS)
	$Wmage.start(WMAGE_START_POS)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id))
	else:
		print("Keyboard")

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
