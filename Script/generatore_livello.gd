extends Node2D

@export var width = 20
@export var height = 20
@export var texture_size = Vector2(20,20)

@export var generator_seed : int = randi() % 3000

var randomGenerator : RandomNumberGenerator = RandomNumberGenerator.new()

var celle = []
var stringa = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.randomGenerator.set_seed(self.generator_seed)
	#print(generator_seed)
	
	inizializza_griglia()
	
	var room_obbligatoria = false
	
	var array_per_random = []
	# Creiamo un array con numeri da 1 a x
	for i in range(1, 100 + 1):
		array_per_random.append(i)
	array_per_random = mescola_array(array_per_random)
	
	#Inizializza griglia & posiziona a random una room
	for h in height:
		for w in width:
			if h != height-1:
				if not room_obbligatoria and  stringa.length() > 0 and array_per_random[0] == 2:
					stringa[stringa.length() -1] = "e"
					stringa += "S"
					room_obbligatoria = true
				else:
					stringa += "A"
					if array_per_random.size() > 0:
						array_per_random.pop_front()
			else:
				stringa += "T"
	
	#Algoritmo di gramamtica
	applica_regole()
	#Stringa to griglia
	str_to_grid()
	
func mescola_array(arr):
	randomGenerator.randomize()

	# Implementazione dello shuffle usando l'algoritmo di Fisher-Yates
	for i in range(arr.size() - 1, 0, -1):
		var j = randomGenerator.randi_range(0, i)
		var temp = arr[i]
		arr[i] = arr[j]
		arr[j] = temp

	return arr


func calcola_str(espressione: String) -> int:
	var risultato = 0
	var expr = Expression.new()
	var error = expr.parse(espressione)
	if error != OK:
		return risultato
	else:
		risultato = expr.execute()
	return risultato

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func str_to_grid():
	for c in range(celle.size()):
		if Regole.lettere_to_texture.has(stringa[c]):
			var texture = Regole.lettere_to_texture[stringa[c]]
			celle[c].texture = texture

func applica_regole(regole_set = Regole.regole):
	for regola in regole_set:
		var indxTrigger = trova_in_str(regola[1])
		while indxTrigger != -1:
			var daSostituire = true
			
			#Cond aggiuntive
			for cond in regola[2]:
				daSostituire = daSostituire and verifica_cond(cond, indxTrigger)
				
			var correzione_indice = 0
			if daSostituire:
				if randomGenerator.randf_range(0.0, 100.0) <= regola[4]:
					correzione_indice = applica_sostituzioni(regola[3], indxTrigger)
				
			indxTrigger = trova_in_str(regola[1], indxTrigger+1+correzione_indice)

func inizializza_griglia():
	
	var windows_size = get_viewport().size 
	var cell_scale = Vector2((windows_size.x/texture_size.x)/self.width, (windows_size.y/texture_size.y)/self.height)
	
	#Inizializza le celle di una griglia e la scala in base alla dimensione della finestra
	for h in height:
		for w in width:
			var cella = preload("res://cella.tscn").instantiate()
			cella.scale = cell_scale
			cella.position.x = texture_size.x*w*cell_scale.x
			cella.position.y = texture_size.y*h*cell_scale.y
			celle.append(cella)
			add_child(cella)

func applica_sostituzioni(sostituzioni : Array, trigger_index := 0):
	var correzione = 0
	if not sostituzioni.size() > 0:
		return 0
	for sost in sostituzioni:
		sost = sost.replace("w", str(width))
		sost = sost.replace("h", str(height))
		var num = ""
		if sost[0] == "+":
			sost = sost.right(-1)	
		
		while sost[0].is_valid_int() or sost[0] in "+-()[]{}/*.":
			num += sost[0] 
			sost = sost.right(sost.length()-(1))
		num = calcola_str(num) if num != "" else 0
		var indice = trigger_index + num
		while floori((indice / width)) != floori((indice+sost.length()-1) / width):
			if sost.length() == 0:
				return 0
			sost = sost.substr(0, sost.length() - 1)
		sostituisci_in_indice(sost, indice)
		correzione += sost.length()
	return correzione-1

func sostituisci_in_indice(sostituzione: String, indice: int):
	if indice < 0 or indice >= stringa.length():
		return stringa 

	var risultato = ""
	var i = 0
	
	while i < sostituzione.length():
		if sostituzione[i] != "#":
			stringa[indice + i] = sostituzione[i]
		i += 1

func verifica_cond(cond, trigger_index := 0)-> bool:
	cond = cond.replace("w", str(width))
	cond = cond.replace("h", str(height))
	
	var num = ""
	if cond[0] == "+":
		cond = cond.right(-1)
	
	#ritorna num
	while cond[0].is_valid_int() or cond[0] in "+-()[]{}/*.":
		num += cond[0] 
		cond = cond.right(-1)
	num = calcola_str(num) if num != "" else 0
	var index = trigger_index + num
	
	if index >= 0 and index < (stringa.length() - cond.length()):
		while floori((index / width)) != floori((index+cond.length()-1) / width):
			return false
		var subDaControllare = stringa.substr(index, cond.length())
		var compatibile = true
		for c in range(subDaControllare.length()):
			compatibile = compatibile and (subDaControllare[c] == cond[c] or cond[c] == "#")
		return compatibile
	return false

func trova_in_str(daTrovare, offset = 0) -> int : 
	for i in range(offset, stringa.length()):
		if i / width != (i+daTrovare.length()-1)/width:
			continue
		var subCorrente = stringa.substr(i, daTrovare.length())
		var trovata = true
		for s in range(subCorrente.length()):
			trovata = trovata and (subCorrente[s] == daTrovare[s] or daTrovare[s] == "#")
		if trovata:
			return i
	return -1
	
