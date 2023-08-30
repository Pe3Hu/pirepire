extends MarginContainer


@onready var preachers = $VBox/Preachers
@onready var chalice = $VBox/Сhalice

var abbey = null
var turn = -1
var speaker = null
var listener = null
var phases = []
var end = false


func set_attributes(input_: Dictionary) -> void:
	abbey = input_.abbey
	chalice.sermon = self
	
	for preacher in input_.preachers:
		preachers.add_child(preacher)
		preacher.init_meeple()
		speaker = preacher
		preacher.sermon = self


func start() -> void:
	print("_____")
	while !end:
		follow_phase()


func reset_phases() -> void:
	turn += 1
	phases.append_array(Global.arr.phase)


func follow_phase() -> void:
	if phases.is_empty() and !end:
		reset_phases()
	
	print(["turn " + str(turn), phases.front(), "speaker " + speaker.index.text])
	match phases.front():
		"tribune transfer phase":
			var order = speaker.get_index()
			listener = preachers.get_child(order)
			order = (order + 1) % preachers.get_child_count()
			speaker = preachers.get_child(order)
		"chalice filling phase":
			chalice.roll_dices(speaker.verses)
		"sequence selection phase":
			var substitution = speaker.choose_substitution()
			chalice.flip_dices(substitution)
			
			for dice in chalice.dices.get_children():
				var step = dice.get_current_facet_value()
				speaker.rosary.move_meeple_by_step(step)
				var bead = speaker.rosary.get_bead_with_meeple()
				
				for ornament in bead.ornaments.get_children():
					var input = {}
					input.intentions = listener.indicators.intentions
					input.gist = ornament.gist
					input.value = ornament.value
					
					match ornament.target:
						"speaker":
							speaker.indicators.intentions.add_intention(input)
						"listener":
							listener.indicators.intentions.add_intention(input)
		"barrier-building phase":
			speaker.indicators.intentions.carry_out_intentions(phases.front())
		"wounding phase":
			speaker.indicators.intentions.carry_out_intentions(phases.front())
		"chalice emptying phase":
			chalice.crush_dices()
	
	phases.pop_front()
