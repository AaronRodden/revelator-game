extends Node

signal start_game

var screen_size
var p1_input_display = []
var p2_input_display = []
#var curr_offset = 0.0
var p1_offset = 0.0
var p2_offset = 0.0
var p1_score = 0
var p2_score = 0

# Auto Attack Timers
var p1_auto_attack_timer = Timer.new()
var p2_auto_attack_timer = Timer.new()
var AUTO_ATTACK_PROGRESS_BAR_TRANSFORM = 66.7

@export var spell_input_ui: PackedScene

func _on_auto_attack_timeout(player):
	if player == 0:
		p1_auto_attack_timer.stop()
	if player == 1:
		p2_auto_attack_timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	p1_auto_attack_timer.wait_time = Global.AUTO_ATTACK_TIMEOUT
	p1_auto_attack_timer.connect("timeout", _on_auto_attack_timeout.bind(0), 0)
	add_child(p1_auto_attack_timer)
	p2_auto_attack_timer.wait_time = Global.AUTO_ATTACK_TIMEOUT
	p2_auto_attack_timer.connect("timeout", _on_auto_attack_timeout.bind(1), 0)
	add_child(p2_auto_attack_timer)
	

func _time_left_transform(time):
	if time >= 1.5:
		return 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.start_flag == false:
		if Input.is_action_just_released("start"):
			_on_start_game()
			start_game.emit()
			Global.start_flag = true
	$P1AutoAttackCooldown.value = p1_auto_attack_timer.time_left * AUTO_ATTACK_PROGRESS_BAR_TRANSFORM
	$P2AutoAttackCooldown.value = p2_auto_attack_timer.time_left * AUTO_ATTACK_PROGRESS_BAR_TRANSFORM


func spell_display(input, player):
	var new_spell_input_ui
	if player == 0:
		new_spell_input_ui = $P1SpellInputUI.new_spell_input_ui(input)
		add_child(new_spell_input_ui)
		p1_input_display.append(new_spell_input_ui)
	elif player == 1:
		new_spell_input_ui = $P2SpellInputUI.new_spell_input_ui(input)
		add_child(new_spell_input_ui)
		p2_input_display.append(new_spell_input_ui)
	
	
func clear_spell_inputs(player):
	if player == 0:
		for ui_input in p1_input_display:
			ui_input.queue_free()
		p1_input_display = []  # Clear input display
		$P1SpellInputUI.h_offset = 0.0
	elif player == 1:
		for ui_input in p2_input_display:
			ui_input.queue_free()
		p2_input_display = []  # Clear input display
		$P2SpellInputUI.h_offset = 0.0

func round_win(player):
	if player == 0:
		p1_score += 1
		$P1Score.text = str(p1_score)
	elif player == 1:
		p2_score += 1
		$P2Score.text = str(p2_score)


#TODO: Logic for resetting game, "closing the loop"		
func victory(player):
	if player == 0:
		$VictoryText.text = "Red Mage wins!"
	elif player == 1:
		$VictoryText.text = "Blue Mage wins!"
	$VictoryText.visible = true

func round_countdown(time):
	$RoundStartTimer.visible = true
	$RoundStartTimer.text = str(time)
	
	if time == 0:
		$RoundStartTimer.text = "GO!!"
		await get_tree().create_timer(1).timeout
		$RoundStartTimer.visible = false

func auto_attack_timer_UI(caster):
	if caster == 0: # rmage auto attack
		p1_auto_attack_timer.start()
	elif caster == 1: # bmage auto attack
		p2_auto_attack_timer.start()

func _on_start_game():
	$Button.visible = false
