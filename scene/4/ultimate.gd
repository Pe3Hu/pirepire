extends MarginContainer


@onready var cells = $HBox/Cells
@onready var kit = $HBox/Kit
@onready var indicators = $"../.."

var sinner = null
var priority = []


func _ready() -> void:
	for edge in Global.arr.edge:
		var cell = Global.scene.cell.instantiate()
		cells.add_child(cell)
		cell.edge = edge
	
	update_kit_value()
	prioritize_cells()


func fill_cell(edge_: int) -> void:
	for cell in cells.get_children():
		if cell.edge == edge_:
			cell.shift_value(1)
			break
	
	update_kit_value()
	prioritize_cells()


func update_kit_value() -> void:
	var min = cells.get_child(0).value
	
	for cell in cells.get_children():
		if cell.value < min:
			min = cell.value
	
	kit.value = 0
	kit.shift_value(min)


func get_impact() -> Variant:
	var impact = null
	
	match sinner.specialization:
		"runologist":
			impact = 2
		"berserk":
			var indicator = indicators.get_indicator_based_on_name("health")
			var percentage = indicator.get_percentage()
			var decimals = floor((100 - percentage) / 10)
			impact = decimals
	
	
	return impact 


func prioritize_cells() -> void:
	var datas = []
	priority = []
	
	for cell in cells.get_children():
		var data = {}
		data.edge = cell.edge
		data.value = cell.value
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.value < b.value)
	
	for data in datas:
		priority.append(data.edge)


func downgrade_kit(downgrade_: int) -> void:
	for cell in cells.get_children():
		cell.shift_value(-downgrade_) 
	
	var value = kit.value - downgrade_
	kit.value = 0
	kit.shift_value(value)
