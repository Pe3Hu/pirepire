extends MarginContainer


@onready var bg = $BG


var rosary = null
var bead = null
var grid = null
var border = null


func set_attributes(input_: Dictionary) -> void:
	rosary = input_.rosary
	grid = input_.grid
	border = input_.border
	
	custom_minimum_size = Global.vec.size.socket
	
	if border:
		var style = bg.get("theme_override_styles/panel")
		style.bg_color = Color(Color.BLACK, 0)
