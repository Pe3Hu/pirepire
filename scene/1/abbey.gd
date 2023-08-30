extends MarginContainer


@onready var preachers = $Preachers
@onready var sermons = $Sermons


func _ready() -> void:
	var priorities = []
	var priority = {}
	priority["wound infliction"] = 1.5
	priority["wound avoidance"] = 1.2
	priorities.append(priority)
	priority = {}
	priority["wound infliction"] = 1.2
	priority["wound avoidance"] = 1.5
	priorities.append(priority)
	
	for _i in 2:
		var input = {}
		input.priority = priorities[_i]
		input.kind = "zebra"
		add_preacher(input)
	
	add_sermon()


func add_preacher(input_: Dictionary) -> void:
	input_.abbey = self
	var preacher = Global.scene.preacher.instantiate()
	preachers.add_child(preacher)
	preacher.set_attributes(input_)


func add_sermon() -> void:
	var input = {}
	input.abbey = self
	input.preachers = []
	
	for _i in 2:
		if !preachers.get_children().is_empty():
			var preacher = preachers.get_children().pick_random()
			preachers.remove_child(preacher)
			input.preachers.append(preacher)
	
	var sermon = Global.scene.sermon.instantiate()
	sermons.add_child(sermon)
	sermon.set_attributes(input)
	sermon.start()
