extends MarginContainer


@onready var rosary = $Rosary


var kind = null
var abbey = null
var verses = 3
var interpretations = 2


func set_attributes(input_: Dictionary) -> void:
	kind = input_.kind
	
	var input = {}
	input.preacher = self
	rosary.set_attributes(input)

