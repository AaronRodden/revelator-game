#class_name SpellBook
extends Sprite2D

var curr_spell

var Fireball = preload("res://fireball.tscn")
var BigFireball = preload("res://big_fireball.tscn")
var LaserCharge = preload("res://laser_charge.tscn")
var Landmine = preload("res://landmine.tscn")
var HomingArrow = preload("res://homing_arrow.tscn")
var AutoAttack = preload("res://auto_attack.tscn")
var LIGHT_FIREBALL_COUNT = 3
var MEDIUM_FIREBALL_COUNT = 3

var spell_queue = []

# ** TODO ** Much of the P1 v P2 logic is baked into this script as well as Rmage / Bage.
# When a refactor comes this script will need to be looked at as well

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
				new_spell = Fireball.instantiate()
				new_spell.set_caster(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
		"medium_fireball":
			for i in range(0, MEDIUM_FIREBALL_COUNT):	
				new_spell = LaserCharge.instantiate()
				new_spell.set_caster(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
		"heavy_fireball":
			new_spell = BigFireball.instantiate()
			new_spell.set_caster(caster)
			add_child(new_spell)
			spell_queue.append(new_spell)
		"special_move":
			if caster == "Rmage": # Fireball mines special move
				new_spell = Landmine.instantiate()
				new_spell.set_caster(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
			elif caster == "Bmage": # Re-direction special move
				new_spell = HomingArrow.instantiate()
				new_spell.set_caster(caster)
				add_child(new_spell)
				spell_queue.append(new_spell)
	return spell_queue

# TODO: Move casting logic into respective classes
func cast_spell(lookvector, controllerangle, caster):
	# Can't cast non special spells witout aiming
	if curr_spell:
		if abs(lookvector.x + lookvector.y) == 0 and curr_spell.contains("special") == false:
			return
	
	match curr_spell:
		"light_fireball":
				for spell in spell_queue:
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
					await get_tree().create_timer(0.075).timeout
		"medium_fireball":
			var lookvector_copy = lookvector
			for i in spell_queue.size():
				var spell = spell_queue[i]
				# TODO: Deadzones and stuff?
				if i == 0:
					lookvector.x -= 0.45
					lookvector.y += 0.45
				elif i == 1:
					lookvector.x = lookvector_copy.x
					lookvector.y = lookvector_copy.y
				elif i == 2:
					lookvector.x += 0.45
					lookvector.y -= 0.45
				spell.cast(lookvector)
				spell.reparent(get_parent().get_parent())
		"heavy_fireball":
			for spell in spell_queue:
				spell.cast(lookvector)
				spell.reparent(get_parent().get_parent())
		"special_move":
			if caster == "Rmage": # Fireball mines special move
				for spell in spell_queue:
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
			elif caster == "Bmage": # Re-direction special move
				print(spell_queue)
				for spell in spell_queue:
					spell.rotation = controllerangle
					spell.cast(lookvector)
					spell.reparent(get_parent().get_parent())
				return # Allows for re-direction
	spell_queue = []
	curr_spell = null

# The auto attack should bypass the spell queue and hense have its own function
func cast_auto_attack(lookvector, controllerangle, caster):
	if abs(lookvector.x + lookvector.y) != 0:
		var auto = AutoAttack.instantiate()
		auto.rotation = controllerangle
		auto.set_caster(caster)
		add_child(auto)
		auto.cast(lookvector)
		auto.reparent(get_parent().get_parent())

func _process(_delta):
	pass

func start():
	for N in self.get_children():
		N.queue_free()
