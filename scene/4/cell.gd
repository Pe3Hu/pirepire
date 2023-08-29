extends MarginContainer


@onready var label = $Label
@onready var bg = $BG

var value = 0
var edge = null


#func _ready():
#	edge = get_parent().get_child_count()

func shift_value(shift_: int) -> void:
	value += shift_
	label.text = str(value)

