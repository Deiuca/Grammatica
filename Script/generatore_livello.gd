extends Node2D

@export var width = 20
@export var height = 20
@export var texture_size = Vector2(20,20)

@export var generator_seed : int = randi() % 3000

var randomGenerator : RandomNumberGenerator = RandomNumberGenerator.new()

var celle = []
var stringa = "AAAAAAAAAAAAAAAAAAAAT"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.randomGenerator.set_seed(self.generator_seed)
	print(generator_seed)
	
	inizializza_griglia()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func applica_regole():
	for regola in Regole.regole:
		var indxTrigger = trova_in_str(regola[1])
		while indxTrigger != -1:
			var daSostituire = true
			#Cond aggiuntive
			for cond in regola[2]:
				daSostituire &= verifica_cond(cond, indxTrigger)
			
			if daSostituire:
				for s in regola[3]:
					applica_sostituzioni(s)
			
			indxTrigger = trova_in_str(regola[1], indxTrigger+1)

func inizializza_griglia():
	
	var windows_size = get_viewport().size 
	var cell_scale = Vector2((windows_size.x/texture_size.x)/self.width, (windows_size.y/texture_size.y)/self.height)
	
	for h in height:
		for w in width:
			var cella = preload("res://cella.tscn").instantiate()
			cella.scale = cell_scale
			cella.position.x = texture_size.x*w*cell_scale.x
			cella.position.y = texture_size.y*h*cell_scale.y
			celle.append(cella)
			add_child(cella)

func applica_sostituzioni(sostituzioni : Array[String], trigger_index := 0):
	for sost in sostituzioni:
		var num = ""
		if sost[0] == "+":
			sost = sost.left(1)
		
		#ritorna num
		var i = 0
		while sost[i].is_valid_int() or sost[i] == "-":
			num += sost[i] 
			sost = sost.left(i)
			i += 1
		num = num.to_int()
		var index = trigger_index + num
		if index >= 0 and index < (stringa.length() - sost.length()):
			for p in range(index, index + sost.length()):
				if sost[p] != "*":
					stringa[p] = sost[p-index]
					

func verifica_cond(cond, trigger_index := 0)-> bool:
	var num = ""
	if cond[0] == "+":
		cond = cond.left(1)
	
	#ritorna num
	var i = 0
	while cond[i].is_valid_int() or cond[i] == "-":
		num += cond[i] 
		cond = cond.left(i)
		i += 1
	
	num = num.to_int()
	var index = trigger_index + num
	if index >= 0 and index < (stringa.length() - cond.length()):
		var subDaControllare = stringa.substr(index, index+cond.length())
		var compatibile = true
		for c in range(subDaControllare.length()):
			compatibile &= subDaControllare[c] == cond[c] or cond[c] == "*"
		return compatibile
	return false

func trova_in_str(daTrovare, offset = 0) -> int : 
	for i in range(offset, stringa.length, daTrovare.length()):
		var subCorrente = stringa.substr(i, i+daTrovare.length())
		var trovata = true
		for s in range(subCorrente.length()):
			trovata &= subCorrente[s] == daTrovare[s] or daTrovare[s] == "*"
		if trovata:
			return i
	return -1
	
