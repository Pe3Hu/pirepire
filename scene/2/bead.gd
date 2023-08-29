extends MarginContainer


@onready var bg = $BG
@onready var meeple = $VBox/Meeple
@onready var index = $VBox/Index
@onready var ornaments = $VBox/Ornaments

var rosary = null
var socket = null
var color = null


func set_attributes(input_: Dictionary) -> void:
	rosary = input_.rosary
	socket = input_.socket
	color = input_.color
	socket.add_child(self)
	index.text = str(input_.index)
	socket.bead = self
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	
	match color:
		"red":
			style.bg_color = Color.from_hsv(0, 0.8, 0.9)
		"blue":
			style.bg_color = Color.from_hsv(210.0/360, 0.8, 0.9)
	
	
	custom_minimum_size = Global.vec.size.bead
	meeple.label.text = "!"


func switch_meeple() -> void:
	meeple.visible = !meeple.visible
	index.visible = !index.visible
