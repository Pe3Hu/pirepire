extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	
	init_dice_substitutions()


func init_dice_substitutions() -> void:
	arr.dice = {}
	arr.dice.substitution = {}
	
	var n = 6 
	
	for _i in 2:
		var l = _i + 2
		
		var cubes = []
		
		for _j in l:
			cubes.append(n)
			
		var substitutions = get_all_substitutions(cubes)
		arr.dice.substitution[l] = {}
		var sum = 0
		
		for substitution in substitutions:
			substitution.sort()
			
			if !arr.dice.substitution[l].has(substitution):
				arr.dice.substitution[l][substitution] = {}
				arr.dice.substitution[l][substitution].repeats = 0
				arr.dice.substitution[l][substitution].edges = []
				
				for index in substitution:
					var edge = arr.edge[index]
					arr.dice.substitution[l][substitution].edges.append(edge)
			
			arr.dice.substitution[l][substitution].repeats += 1
			sum += 1


func init_num() -> void:
	num.index = {}


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/1/sketch.tscn")
	scene.abbey = load("res://scene/1/abbey.tscn")
	scene.preacher = load("res://scene/1/preacher.tscn")
	scene.sermon = load("res://scene/1/sermon.tscn")
	scene.chalice = load("res://scene/1/chalice.tscn")
	
	
	scene.rosary = load("res://scene/2/rosary.tscn")
	scene.socket = load("res://scene/2/socket.tscn")
	scene.bead = load("res://scene/2/bead.tscn")
	scene.ornament = load("res://scene/2/ornament.tscn")
	
	scene.icon = load("res://scene/3/icon.tscn")
	scene.dice = load("res://scene/3/dice.tscn")
	scene.facet = load("res://scene/3/facet.tscn")
	pass


func init_vec():
	vec.size = {}
	
	vec.size.socket = Vector2(50, 50)
	vec.size.bead = Vector2(50, 50)
	vec.size.facet = Vector2(40, 40)
	
	vec.size.letter = Vector2(10, 10)
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_all_substitutions(array_: Array):
	var result = [[]]
	
	for _i in array_.size():
		var slot_options = array_[_i]
		var next = []
		
		for arr_ in result:
			for option in slot_options:
				var pair = []
				pair.append_array(arr_)
				pair.append(option)
				next.append(pair)
		
		result = next
		for _j in range(result.size()-1,-1,-1):
			if result[_j].size() < _i+1:
				result.erase(result[_j])
	
	return result
