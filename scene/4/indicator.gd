extends MarginContainer


@onready var value = $Value
@onready var bar = $ProgressBar
@onready var indicators = $"../../.."

var type = null


func update_color() -> void:
	var keys = ["fill", "background"]
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.indicator[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func update_value(limit_: String, value_: int) -> void:
	match limit_:
		"current":
			var arrear = null
			
			if bar.value + value_ > bar.min_value:
				bar.value += value_
			else:
				arrear = value_ + bar.value - bar.min_value
				bar.value = bar.min_value
			
			bar.value = min(bar.value, bar.max_value)
			
			if arrear != null:
				match type:
					"barrier":
						#var indicator = indicators.get_indicator_based_on_name("health")
						indicators.health.update_value("current", arrear)
					"health":
						indicators.preacher.knockout()
			
			print([indicators.preacher.index.text, type, value_, bar.value, bar.max_value])
			
			value.text = type + ": " + str(bar.value)
		"maximum":
			bar.max_value += value_


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)
