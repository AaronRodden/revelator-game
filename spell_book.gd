#class_name SpellBook
extends Sprite2D

var spell_type
var curr_spell

var Fireball = preload("res://assets/animations/fireball.tscn")

func new_spell(spell_type):
	var new_spell
	match spell_type:
		"fireball":
			new_spell = Fireball.instantiate()
	add_child(new_spell)
	curr_spell = new_spell
	return new_spell

func cast_spell(lookvector):
	curr_spell.cast(lookvector)
	curr_spell.reparent(get_parent().get_parent())  # TODO: Is there a better way to do this??
	
func _process(delta):
	pass
