extends MarginContainer


@onready var label = $Label


var data = {}


func _ready():
	custom_minimum_size = Vector2(Global.vec.size.letter)
