extends Node

var screen_size
var input_display = []
var curr_offset = 0.0

@export var spell_input_ui: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spell_display(input):
	var new_spell_input_ui
	new_spell_input_ui = $SpellInputUI.new_spell_input_ui(input, curr_offset)
	add_child(new_spell_input_ui)
	input_display.append(new_spell_input_ui)
	curr_offset += 50
	

func clear_spell_inputs():
	for ui_input in input_display:
		ui_input.queue_free()
	input_display = []  # Clear input display
	curr_offset = 0.0