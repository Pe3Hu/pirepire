extends MarginContainer


@onready var sockets = $Sockets

var preacher = null
var meeple = 0
var beads = {}
var chain = []


func set_attributes(input_: Dictionary) -> void:
	preacher = input_.preacher
	init_sockets()
	init_beads()


func init_sockets() -> void:
	var n = 4
	var m = 4
	sockets.columns = m
	
	for _i in n:
		for _j in m:
			var input = {}
			input.grid = Vector2(_j, _i)
			input.rosary = self
			input.border = _i == 0 or _j == 0 or _i == n-1 or _j == m-1
			var socket = Global.scene.socket.instantiate()
			sockets.add_child(socket)
			socket.set_attributes(input)


func init_beads() -> void:
	for socket in sockets.get_children():
		if socket.border:
			var bead = Global.scene.bead.instantiate()
			bead.socket = socket
			beads[bead.socket.grid] = bead
	
	set_beads_an_index()
	set_beads_an_ornament()


func set_beads_an_index() -> void:
	var index = 0
	var grid = Vector2()
	var directions = []
	directions.append_array(Global.dict.neighbor.linear2)
	directions.pop_front()
	directions.append(Global.dict.neighbor.linear2[0])
	
	while !directions.is_empty():
		var bead = beads[grid]
		var input = {}
		input.socket = bead.socket
		input.rosary = self
		input.parity = index % 2
		
		match input.parity:
			0:
				input.parity = "even"
			1:
				input.parity = "odd"
		
		match preacher.kind:
			"zebra":
				match input.parity:
					"even":
						input.color = "red"
					"odd":
						input.color = "blue"
		
		input.index = index
		index += 1
		bead.set_attributes(input)
		chain.append(grid)
		
		grid += directions.front()
		
		if grid == Vector2():
			directions = []
		
		if !beads.has(grid):
			grid -= directions.front()
			directions.pop_front()
			
			if !directions.is_empty():
				grid += directions.front()


func set_beads_an_ornament() -> void:
	for grid in beads:
		var input = {}
		input.bead = beads[grid]
		
		match input.bead.color:
			"red":
				input.gist = "damage"
			"blue":
				input.gist = "shield"
		
		match preacher.kind:
			"zebra":
				var integer = int(input.bead.index.text) / 2
				input.value = integer * 2 + 5
				
				if input.bead.color == "blue":
					input.value -= 3
		
		var ornament = Global.scene.ornament.instantiate()
		input.bead.ornaments.add_child(ornament)
		ornament.set_attributes(input)


func move_meeple(step_: int) -> void:
	var bead = null
	
	if meeple == null:
		meeple = 0
	else:
		bead = beads[chain[meeple]].switch_meeple()
	
	meeple = (meeple + step_ + chain.size()) % chain.size()
	bead = beads[chain[meeple]].switch_meeple()
