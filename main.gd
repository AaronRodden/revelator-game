extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bmage.connect("spell_input", $HUD.spell_display, 0)
	#$Bmage.connect("spell_completed", $HUD.clear_spell_inputs, 0)
	$Bmage.connect("spell_cast", $HUD.clear_spell_inputs, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
