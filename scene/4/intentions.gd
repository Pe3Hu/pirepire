extends MarginContainer


@onready var vbox = $VBox
@onready var wounds = $VBox/Wounds
@onready var barriers = $VBox/Barriers

var indicators = null


func _ready() -> void:
	var icon = wounds.get_node("Icon")
	icon.label.text = "W"
	icon = barriers.get_node("Icon")
	icon.label.text = "B"


func add_intention(input_: Dictionary) -> void:
	var intention = Global.scene.intention.instantiate()
	
	match input_.gist:
		"wound":
			wounds.add_child(intention)
			wounds.visible = true
		"barrier":
			barriers.add_child(intention)
			barriers.visible = true
	
	intention.set_attributes(input_)


func get_incoming_damage() -> int:
	var damage = 0
	
	for intention in wounds.get_children():
		if intention.name != "Icon":
			damage += intention.value
	
	for intention in barriers.get_children():
		if intention.name != "Icon":
			damage -= intention.value
	
	damage = max(damage, 0)
	
	return damage


func carry_out_intentions(phase_: String) -> void:
	var intentions = null
	
	match phase_:
		"barrier-building phase":
			intentions = barriers
		"wounding phase":
			intentions = wounds
	
	for intention in intentions.get_children():
		if intention.name != "Icon":
			match intention.gist:
				"barrier":
					var gap = intention.value + indicators.barrier.bar.value - indicators.barrier.bar.max_value
					
					print([intention.value, gap])
					if gap > 0:
						indicators.barrier.update_value("maximum", gap)
					
					indicators.barrier.update_value("current", intention.value)
				"wound":
					indicators.barrier.update_value("current", -intention.value)
		
			intentions.remove_child(intention)
			intention.queue_free()
	
	intentions.visible = false
