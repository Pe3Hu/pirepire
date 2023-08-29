extends MarginContainer

@onready var index = $VBox/Index
@onready var rosary = $VBox/Rosary
@onready var indicators = $VBox/Indicators

var kind = null
var abbey = null
var sermon = null
var verses = 3
var interpretations = 2


func set_attributes(input_: Dictionary) -> void:
	index.text = str(Global.num.index.preacher)
	Global.num.index.preacher += 1
	kind = input_.kind
	
	var input = {}
	input.preacher = self
	rosary.set_attributes(input)
	indicators.set_attributes(input)


func init_meeple() -> void:
	var bead = rosary.beads[Vector2()]
	bead.switch_meeple()

