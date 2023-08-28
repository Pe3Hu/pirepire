extends MarginContainer


@onready var preachers = $Preachers
@onready var sermons = $Sermons


func _ready() -> void:
	for _i in 2:
		add_preacher("zebra")
	
	add_sermon()


func add_preacher(kind_: String) -> void:
	var input = {}
	input.abbey = self
	input.kind = kind_
	var preacher = Global.scene.preacher.instantiate()
	preachers.add_child(preacher)
	preacher.set_attributes(input)


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
