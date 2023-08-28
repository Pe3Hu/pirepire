extends MarginContainer


@onready var bg = $BG
@onready var label = $Label

var bead = null
var gist = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	bead = input_.bead
	gist = input_.gist
	value = input_.value
	
	label.text = gist[0].capitalize() + " " + str(value)
