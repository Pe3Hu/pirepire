extends MarginContainer


@onready var beads = $Beads

var rosary = null
var direction = null


func set_attributes(input_: Dictionary) -> void:
	rosary = input_.rosary
	direction = input_.direction
	
	for bead in input_.beads:
		add_icon(bead)


func add_icon(bead_: MarginContainer) -> void:
	var icon = Global.scene.icon.instantiate()
	beads.add_child(icon)
	icon.data.bead = bead_
	icon.label.text = bead_.index.text


func add_residual(bead_: MarginContainer) -> void:
	add_icon(bead_)
	var residual = beads.get_children().back()
	beads.move_child(residual, 0)

