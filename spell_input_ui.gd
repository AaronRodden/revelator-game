class_name SpellInputUI
extends Sprite2D

var spell_texture

# TODO: Make these work on export
var right_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_right.svg")
var left_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_left.svg") 
var up_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_up.svg") 
var down_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_dpad_down.svg") 
var square_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_square.svg")
var triangle_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_triangle.svg")
var cross_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_cross.svg")
var circle_tex = Image.load_from_file("res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_circle.svg")

var right_p2_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Pro D-Pad Right.svg")
var left_p2_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Pro D-Pad Left.svg")
var up_p2_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Pro D-Pad Up.svg")
var down_p2_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Pro D-Pad Down.svg")
var a_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/A.svg")
var b_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/B.svg")
var x_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/X.svg")
var y_tex = Image.load_from_file("res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Y.svg")

# TODO: This is all hard coded right now!
var P1_X_STARTING_POSITON = 56
var P1_Y_STARTING_POSITION = 208

var P2_X_STARTING_POSITON = 936
var P2_Y_STARTING_POSITION = 208
var p2_face_buttons = ["a", "b", "x", "y"]

var h_offset = 0.0

func new_spell_input_ui(spell_input: String):
	var new_spell_input_ui = SpellInputUI.new()
	new_spell_input_ui.spell_texture = spell_input
	new_spell_input_ui.h_offset = h_offset
	h_offset += 50
	return new_spell_input_ui
	
func _ready():
	var texture
	var p2 = false
	if spell_texture:
		if "p2" in spell_texture:
			p2 = true
		for face_button in p2_face_buttons:
			if face_button == spell_texture:
				p2 = true
				
		match spell_texture:
			"right":
				texture = right_tex
			"left":
				texture = left_tex
			"up":
				texture = up_tex
			"down":
				texture = down_tex
			"cross":
				texture = cross_tex
			"circle":
				texture = circle_tex
			"triangle":
				texture = triangle_tex
			"square":
				texture = square_tex
			"right_p2":
				texture = right_p2_tex
			"left_p2":
				texture = left_p2_tex
			"up_p2":
				texture = up_p2_tex
			"down_p2":
				texture = down_p2_tex
			"a":
				texture = a_tex
			"b":
				texture = b_tex
			"x":
				texture = x_tex
			"y":
				texture = y_tex
		self.texture = ImageTexture.create_from_image(texture)
		if p2:
			self.position.x = P2_X_STARTING_POSITON + h_offset
			self.position.y = P2_Y_STARTING_POSITION
			self.scale.x = 0.15
			self.scale.y = 0.15
		else:
			self.position.x = P1_X_STARTING_POSITON + h_offset
			self.position.y = P1_Y_STARTING_POSITION
		self.visible = true
	else:
		self.visible = false
