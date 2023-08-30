extends MarginContainer


@onready var bg = $BG
@onready var label = $Label

var bead = null
var gist = null
var value = null
var target = null


func set_attributes(input_: Dictionary) -> void:
	bead = input_.bead
	gist = input_.gist
	value = input_.value
	target = input_.target
	
	label.text = gist[0].capitalize() + " " + str(value)
