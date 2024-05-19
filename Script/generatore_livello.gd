extends Node2D

@export var width = 20
@export var height = 20
@export var texture_size = Vector2(20,20)

@export var generator_seed : int = randi() % 3000

var randomGenerator : RandomNumberGenerator = RandomNumberGenerator.new()

var celle = []
var stringa = "AAAAAAAAAAAAAAAAARAAT"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.randomGenerator.set_seed(self.generator_seed)
	print(generator_seed)
	
	inizializza_griglia()
	applica_regole()
	print(stringa)

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
				daSostituire = daSostituire and verifica_cond(cond, indxTrigger)
			
			var correzione_indice = 0
			if daSostituire:
				applica_sostituzioni(regola[3], indxTrigger)
			
			if stringa.length() > 60:
				break
				
			indxTrigger = -1
			#indxTrigger = trova_in_str(regola[1], indxTrigger+1+correzione_indice)

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

func applica_sostituzioni(sostituzioni : Array, trigger_index := 0):
	var newTriggerIndex := trigger_index
	
	var correzione = 0
	if not sostituzioni.size() > 0:
		return 0
	for sost in sostituzioni:
		var num = ""
		if sost[0] == "+":
			sost = sost.left(1)	
		#ritorna num
		while sost[0].is_valid_int() or sost[0] == "-":
			num += sost[0] 
			sost = sost.right(sost.length()-(1))
		num = num.to_int()
		var indice = trigger_index + num
		stringa = sostituisci_in_indice(sost, indice)
		if num<0:
			correzione += sost.length()
	
	return correzione

func sostituisci_in_indice(sostituzione: String, indice: int) -> String:
	if indice < 0 or indice >= stringa.length():
		return stringa 

	var risultato = ""
	var i = 0
	
	while i < sostituzione.length():
		if indice + i < stringa.length() and sostituzione[i] == "*":
			risultato += stringa[indice + i]
		else:
			risultato += sostituzione[i]
		i += 1

	var prima_dell_indice = stringa.left(indice)
	var dopo_l_indice = ""
	if indice + sostituzione.length() < stringa.length():
		dopo_l_indice = stringa.substr(indice + sostituzione.length(), stringa.length() - (indice + sostituzione.length()))
	
	return prima_dell_indice + risultato + dopo_l_indice

func verifica_cond(cond, trigger_index := 0)-> bool:
	var num = ""
	if cond[0] == "+":
		cond = cond.left(1)
	
	#ritorna num
	while cond[0].is_valid_int() or cond[0] == "-":
		num += cond[0] 
		cond = cond.right(cond.length()-(1))
	num = num.to_int()
	var index = trigger_index + num
	if index >= 0 and index < (stringa.length() - cond.length()):
		var subDaControllare = stringa.substr(index, cond.length())
		var compatibile = true
		for c in range(subDaControllare.length()):
			compatibile = compatibile and subDaControllare[c] == cond[c] or cond[c] == "*"
		return compatibile
	return false

func trova_in_str(daTrovare, offset = 0) -> int : 
	for i in range(offset, stringa.length(), daTrovare.length()):
		var subCorrente = stringa.substr(i, daTrovare.length())
		var trovata = true
		for s in range(subCorrente.length()):
			trovata = trovata and (subCorrente[s] == daTrovare[s] or daTrovare[s] == "*")
		if trovata:
			return i
	return -1
	
