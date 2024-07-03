class_name SpellInputUI
extends Sprite2D

var spell_texture
var h_offset

var right_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_right.svg")
var left_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_left.svg") 
var up_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_up.svg") 
var down_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_down.svg") 
var square_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_square.svg")
var triangle_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_triangle.svg")
var x_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_cross.svg")
var circle_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_circle.svg")

var X_STARTING_POSITON = 83
var Y_STARTING_POSITION = 99

func new_spell_input_ui(spell_input: String, h_offset := 50.0):
	var new_spell_input_ui = SpellInputUI.new()
	new_spell_input_ui.spell_texture = spell_input
	new_spell_input_ui.h_offset = h_offset
	return new_spell_input_ui
	
func _ready():
	var texture
	if spell_texture:
		match spell_texture:
			"right":
				texture = right_tex
			"left":
				texture = left_tex
			"up":
				texture = up_tex
			"down":
				texture = down_tex
			"x":
				texture = x_tex
			"circle":
				texture = circle_tex
			"triangle":
				texture = triangle_tex
			"square":
				texture = square_tex
		self.texture = ImageTexture.create_from_image(texture)
		self.position.x = X_STARTING_POSITON + h_offset
		self.position.y = Y_STARTING_POSITION
		self.visible = true
	else:
		self.visible = false
