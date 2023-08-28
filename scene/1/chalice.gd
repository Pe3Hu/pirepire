extends MarginContainer


@onready var dices = $Dices

var sermon = null


func roll_dices(count_: int) -> void:
	for _i in count_:
		var dice = Global.scene.dice.instantiate()
		dices.add_child(dice)
		dice.skip_animation()
	
