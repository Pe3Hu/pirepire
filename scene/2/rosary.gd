extends MarginContainer


@onready var sockets = $VBox/Sockets
@onready var fringes = $VBox/Fringes

var preacher = null
var meeple = 0
var beads = {}
var chain = []
var rows = null


func set_attributes(input_: Dictionary) -> void:
	preacher = input_.preacher
	rows = input_.rows
	
	sockets.columns = 12 / input_.rows
	
	if rows > 2:
		sockets.columns += 1
	
	init_sockets()
	init_beads()
	complete_fringes()


func init_sockets() -> void:
	for _i in rows:
		for _j in sockets.columns:
			var input = {}
			input.grid = Vector2(_j, _i)
			input.rosary = self
			input.border = _i == 0 or _j == 0 or _i == rows - 1 or _j == sockets.columns - 1
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
	var fringe_beads = []
	var index = 0
	var grid = Vector2()
	var directions = []
	directions.append_array(Global.dict.neighbor.linear2)
	directions.pop_front()
	directions.append(Global.dict.neighbor.linear2[0])
	
	var suns = []
	var n = 12 / Global.arr.sun.size()
	
	for sun in Global.arr.sun:
		for _i in n:
			suns.append(sun)
	
	while !directions.is_empty():
		var bead = beads[grid]
		var input = {}
		input.socket = bead.socket
		input.rosary = self
		input.parity = index % 2
		input.sun = suns[index]
		
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
		
		fringe_beads.append(bead)
		input.index = index
		index += 1
		bead.socket.add_child(bead)
		bead.set_attributes(input)
		chain.append(grid)
		
		grid += directions.front()
		
		if !beads.has(grid):
			var fringe = Global.scene.fringe.instantiate()
			fringes.add_child(fringe)
			input.direction = directions.front()
			input.beads = fringe_beads
			fringe.set_attributes(input)
			fringe_beads = []
			
			grid -= directions.front()
			directions.pop_front()
			
			if !directions.is_empty():
				grid += directions.front()
		
		if grid == Vector2():
			var fringe = Global.scene.fringe.instantiate()
			fringes.add_child(fringe)
			input.direction = directions.front()
			input.beads = [beads[grid]]
			fringe.set_attributes(input)
			directions = []
		
		print(index, grid, directions.front())


func set_beads_an_ornament() -> void:
	for grid in beads:
		var input = {}
		input.bead = beads[grid]
		
		match input.bead.color:
			"red":
				input.gist = "wound"
				input.target = "listener"
			"blue":
				input.gist = "barrier"
				input.target = "speaker"
		
		match preacher.kind:
			"zebra":
				var integer = int(input.bead.index.text) / 2
				input.value = integer * 2 + 5
				
				if input.bead.color == "blue":
					input.value -= 2
		
		var ornament = Global.scene.ornament.instantiate()
		input.bead.ornaments.add_child(ornament)
		ornament.set_attributes(input)


func complete_fringes() -> void:
	for _i in fringes.get_child_count():
		if _i > 0:
			var fringe = fringes.get_child(_i)
			var index = int(fringe.beads.get_child(0).data.bead.index.text)
			var residual = ( index - 1 + chain.size() ) % chain.size()
			var grid = chain[residual]
			print(fringe.direction, fringe.beads.get_child(0).data.bead.index.text)
			var bead = beads[grid]
			fringe.add_residual(bead)


func move_meeple_by_step(step_: int) -> void:
	var bead = null
	
	if meeple == null:
		meeple = 0
	else:
		bead = get_bead_with_meeple().switch_meeple()
	
	meeple = (meeple + step_ + chain.size()) % chain.size()
	bead = get_bead_with_meeple().switch_meeple()


func get_bead_with_meeple() -> MarginContainer:
	return beads[chain[meeple]]


func move_meeple_on_spot(spot_: int) -> void:
	for grid in beads:
		var bead = beads[grid]
		
		if bead.meeple.visible:
			bead.switch_meeple()
	
	meeple = spot_
	var bead = get_bead_with_meeple()
	bead.switch_meeple()
