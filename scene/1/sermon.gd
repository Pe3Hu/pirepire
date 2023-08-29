extends MarginContainer


@onready var preachers = $VBox/Preachers
@onready var chalice = $VBox/Сhalice

var abbey = null
var turn = 0
var tribune = null


func set_attributes(input_: Dictionary) -> void:
	abbey = input_.abbey
	chalice.sermon = self
	
	for preacher in input_.preachers:
		preachers.add_child(preacher)
		preacher.init_meeple()
		tribune = preacher
		preacher.sermon = self


func start() -> void:
	pass_word()


func pass_word() -> void:
	var order = tribune.get_index()
	order = (order + 1) % preachers.get_child_count()
	tribune = preachers.get_child(order)
	chalice.roll_dices(tribune.verses)
	
	for dice in chalice.dices.get_children():
		var step = dice.get_current_facet_value()
		tribune.rosary.move_meeple(step)
