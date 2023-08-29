extends MarginContainer


@onready var bars = $VBox/Bars
@onready var title = $VBox/Title
@onready var ultimate = $VBox/Ultimate

var preacher = null


func set_attributes(input_: Dictionary) -> void:
	preacher = input_.preacher
	title.text = preacher.index.text
	#add_bars()
	update_bars()


func add_bars() -> void:
	for key in Global.dict.indicator:
		if Global.dict.indicator[key].has(preacher.specialization):
			var indicator = Global.scene.indicator.instantiate()
			indicator.name = key.capitalize()
			bars.add_child(indicator)


func update_bars() -> void:
	for indicator in bars.get_children():
		indicator.type = indicator.name.to_lower()
		var value = 100#Global.dict.specialization.title[sinner.specialization][indicator.type]
		indicator.update_value("maximum", value)
		indicator.update_color()


func get_indicator_based_on_name(name_: String) -> Variant:
	for indicator in bars.get_children():
		if indicator.name.to_lower() == name_:
			return indicator
	
	return null
