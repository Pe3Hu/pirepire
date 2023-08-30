extends MarginContainer


@onready var label = $Label

var intentions = null
var gist = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	intentions = input_.intentions
	gist = input_.gist
	value = input_.value
	
	label.text = str(value)
