extends MarginContainer

@onready var index = $VBox/Index
@onready var rosary = $VBox/Rosary
@onready var indicators = $VBox/Indicators

var kind = null
var abbey = null
var sermon = null
var verses = 3
var interpretations = 2
var priority = {}


func set_attributes(input_: Dictionary) -> void:
	index.text = "Preacher #" + str(Global.num.index.preacher)
	Global.num.index.preacher += 1
	kind = input_.kind
	priority = input_.priority
	
	var input = {}
	input.preacher = self
	input.rows = input_.rows
	rosary.set_attributes(input)
	indicators.set_attributes(input)


func init_meeple() -> void:
	var bead = rosary.beads[Vector2()]
	bead.switch_meeple()


func choose_substitution() -> Array:
	var datas = []
	var anchor = int(rosary.meeple)
	var values = sermon.chalice.get_facet_value_on_dices()
	var permutations = Global.get_all_permutations(values)
	var a = indicators.intentions.name
	var incoming_damage = indicators.intentions.get_incoming_damage()
	
	for permutation in permutations:
		var assessment = {}
		var impact = {}
		rosary.meeple = anchor
		
		for step in permutation:
			rosary.move_meeple_by_step(step)
			var bead = rosary.get_bead_with_meeple()
			
			for ornament in bead.ornaments.get_children():
				if !impact.has(ornament.gist):
					impact[ornament.gist] = 0
					assessment[ornament.gist] = 0
				
				impact[ornament.gist] += ornament.value
				
				match ornament.gist:
					"wound":
						assessment[ornament.gist] += priority["wound infliction"] * ornament.value
					"barrier":
						var value = min(impact[ornament.gist], incoming_damage)
						assessment[ornament.gist] = priority["wound avoidance"] * value
		
		var data = {}
		data.permutation = permutation
		data.assessment = 0
		
		for key in assessment:
			data.assessment += assessment[key]
		
		datas.append(data)
	
	rosary.move_meeple_on_spot(anchor)
	
	datas.sort_custom(func(a, b): return a.assessment > b.assessment)
	var best = []
	
	for data in datas:
		if data.assessment == datas.front().assessment:
			best.append(data.permutation)
	
	return best.pick_random()


func knockout() -> void:
	print(index.text + " is dead")
	sermon.end = true
