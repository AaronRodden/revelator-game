class_name SpellInputUI
extends Sprite2D

var spell_texture

var up_arrow_path = "res://assets/arrow_sprite_up.png"
var down_arrow_path = "res://assets/arrow_sprite_down.png"
var left_arrow_path = "res://assets/arrow_sprite_left.png"
var right_arrow_path = "res://assets/arrow_sprite_right.png"

var square_path = "res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_square.svg"
var triangle_path = "res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_triangle.svg"
var cross_path = "res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_cross.svg"
var circle_path = "res://addons/awesome_input_icons/assets/ps4_vector/playstation_button_color_circle.svg"

var a_path = "res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/A.svg"
var b_path = "res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/B.svg"
var x_path = "res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/X.svg"
var y_path = "res://assets/Switch Button Icons and Controls/Buttons Full Solid/White/SVG/Y.svg"

# TODO: This is all hard coded right now!
var P1_X_STARTING_POSITON = 45
var P1_Y_STARTING_POSITION = 208

var P2_X_STARTING_POSITON = 926
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
	var texture_path
	var scale_variable
	var p2 = false
	if spell_texture:
		if "p2" in spell_texture:
			p2 = true
		for face_button in p2_face_buttons:
			if face_button == spell_texture:
				p2 = true
				
		match spell_texture:
			"right":
				texture_path = right_arrow_path
			"left":
				texture_path = left_arrow_path
			"up":
				texture_path = up_arrow_path
			"down":
				texture_path = down_arrow_path
			"cross":
				texture_path = cross_path
			"circle":
				texture_path = circle_path
			"triangle":
				texture_path = triangle_path
			"square":
				texture_path = square_path
			"right_p2":
				texture_path = right_arrow_path
			"left_p2":
				texture_path = left_arrow_path
			"up_p2":
				texture_path = up_arrow_path
			"down_p2":
				texture_path = down_arrow_path
			"a":
				texture_path = a_path
				scale_variable = 0.15
			"b":
				texture_path = b_path
				scale_variable = 0.15
			"x":
				texture_path = x_path
				scale_variable = 0.15
			"y":
				texture_path = y_path
				scale_variable = 0.15
		self.texture = load(texture_path)
		if p2:
			self.position.x = P2_X_STARTING_POSITON + h_offset
			self.position.y = P2_Y_STARTING_POSITION
			if scale_variable:
				self.scale.x = scale_variable
				self.scale.y = scale_variable
		else:
			self.position.x = P1_X_STARTING_POSITON + h_offset
			self.position.y = P1_Y_STARTING_POSITION
		self.visible = true
	else:
		self.visible = false
