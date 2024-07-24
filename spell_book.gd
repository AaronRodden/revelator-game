#class_name SpellBook
extends Sprite2D

var spell_type
var curr_spell

var Fireball = preload("res://assets/animations/fireball.tscn")
var LIGHT_FIREBALL_COUNT = 3
var MEDIUM_FIREBALL_COUNT = 3

var spell_queue = []

# ** TODO ** Much of the P1 v P2 logic is baked into this script as well as bmage / wmage.
# When a refactor comes this script will need to be looked at as well

func _instantiate_fireball(caster):
	var new_spell = Fireball.instantiate()
	new_spell.caster = caster
	if caster == "Wmage":
		new_spell.modulate = Color (0, 0, 1)
	return new_spell

func new_spell(spell_type, caster):
	# Check if there is a spell already loaded up, null it if so
	if curr_spell:
		curr_spell = null
		spell_queue = []
	var new_spell
	curr_spell = spell_type
	match spell_type:
		"light_fireball":
			for i in range(0, LIGHT_FIREBALL_COUNT):	
				new_spell = _instantiate_fireball(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
		"medium_fireball":
			for i in range(0, MEDIUM_FIREBALL_COUNT):	
				new_spell = _instantiate_fireball(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
		"heavy_fireball":
			new_spell = _instantiate_fireball(caster)
			new_spell.scale.x += 5
			new_spell.scale.y += 5
			add_child(new_spell)
			spell_queue.append(new_spell)
		"special_move":
			if caster == "Bmage": # Fireball mines special move
				new_spell = _instantiate_fireball(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
			elif caster == "Wmage": # Re-direction special move
				new_spell = _instantiate_fireball(caster)
				new_spell.speed = 150
				add_child(new_spell)
				spell_queue.append(new_spell)
	return spell_queue

func cast_spell(lookvector, caster):
	# Can't cast non special spells witout aiming
	if curr_spell:
		if abs(lookvector.x + lookvector.y) == 0 and curr_spell.contains("special") == false:
			return
	
	match curr_spell:
		"light_fireball":
				for spell in spell_queue:
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
					await get_tree().create_timer(0.05).timeout
		"medium_fireball":
			var lookvector_copy = lookvector
			for i in spell_queue.size():
				var spell = spell_queue[i]
				if i == 0:
					lookvector.x -= 0.25
					lookvector.y += 0.25
				elif i == 1:
					lookvector.x = lookvector_copy.x
					lookvector.y = lookvector_copy.y
				elif i == 2:
					lookvector.x += 0.25
					lookvector.y -= 0.25
				spell.cast(lookvector)
				spell.reparent(get_parent().get_parent())
		"heavy_fireball":
			for spell in spell_queue:
				spell.cast(lookvector)
				spell.reparent(get_parent().get_parent())
		"special_move":
			if caster == "Bmage": # Fireball mines special move
				for spell in spell_queue:
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
			elif caster == "Wmage": # Re-direction special move
				for spell in spell_queue:
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
				return # Allows for re-direction
	spell_queue = []
	curr_spell = null
	
func _process(delta):
	pass

func start():
	for N in self.get_children():
		N.queue_free()
