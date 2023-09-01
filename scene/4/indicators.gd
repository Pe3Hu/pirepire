extends MarginContainer


@onready var bars = $VBox/Bars
@onready var title = $VBox/Title
@onready var intentions = $VBox/Intentions
@onready var ultimate = $VBox/Ultimate
@onready var health = $VBox/Bars/Health
@onready var barrier = $VBox/Bars/Barrier

var preacher = null


func set_attributes(input_: Dictionary) -> void:
	preacher = input_.preacher
	title.text = preacher.index.text
	intentions.indicators = self
	reset_bars()


func reset_bars() -> void:
	for indicator in bars.get_children():
		indicator.type = indicator.name.to_lower()
		var value = Global.num.indicator[indicator.type]
		#Global.dict.specialization.title[sinner.specialization][indicator.type]
		indicator.update_value("maximum", value)
		
		match indicator.type:
			"health":
				indicator.update_value("current", indicator.bar.max_value)
			"barrier":
				indicator.bar.value = 0
				indicator.update_value("current", 0)
				#indicator.bar.visible = false
		
		indicator.update_color()


func get_indicator_based_on_name(name_: String) -> Variant:
	for indicator in bars.get_children():
		if indicator.name.to_lower() == name_:
			return indicator
	
	return null


func half_barrier() -> void:
	barrier.update_value("current", -barrier.bar.value / 2)
