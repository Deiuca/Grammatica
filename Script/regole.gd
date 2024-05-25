extends Node2D

var regole = [
	#Nome; Trigger; Condizioni Aggiuntive; Sostituzione; Probabilità (deve essere ultima, modica in applica_regole)
	["regola1", "T", [], ["TTT"], 100.0],
	["regola1", "TTT", ["-wA"], ["-wT"], 60.0],
	["regola1", "TAT", [], ["TTT"], 100.0],
	["regola22", "AT", ["-wAA","+w*T"], ["ArT"], 100.0],
	["regola22", "TA", ["-wAA", "+w*T"], ["TRA"], 100.0],
	["", "A", ["-w-1AAAA", "+w-1AAAA", "+w+w+w-1AAA", "+2A", "-1A"], ["eS"], 0.5],
	["", "S", ["-w-1AAAAA","+w-1AAAAA", "+3A"], ["SSS"], 40.0],
	["", "SA", ["-w-1AAAA", "+w-1AAAA", "+2A"], ["SE"], 100.0],
	["", "S", ["+1eS"], ["+1S"], 100.0],
	["", "A", ["-w-wS"], ["P"], 100.0],
	["", "A", ["-w-wE"], ["O"], 100.0],
	["", "A", ["-w-we"], ["O"], 100.0],
	["regola2", "A", ["-w-1AAAA", "+w-1AAA", "-1A"], ["PPP"], 15.0],
	["regola5", "A", ["-w-1AAA", "+w-1AAA", "+1A", "-1P"], ["P"], 60.0], #espansione
	["regola4", "PA", ["+wA", "-w-1AAAA", "+2A"], ["PE"], 80.0],
	["regola5", "AP", ["-w-1AAA", "-1A", "+w-1AAA"], ["eP"], 80.0],
	["regola5", "AP", ["-w-1AAA", "-1A", "+w-1AAA", "+w+wP"], ["eP"], 100.0],
	["rr", "PPP", [], ["POP"], 20.0],
	["r", "PPP",[], ["PoP"], 20.0],
	["Nemico", "PO", [], ["N"], 10.0],
	["Nemico", "OP", [], ["+1N"], 10.0],
	["Nemico", "P", [], ["N"], 10.0],
	["regola6", "A", ["-wE", "+wP", "+1A"], ["V"], 90.0],
	["regola6", "A", ["-we", "+wP", "+1A"], ["V"], 90.0],
	["r", "P", ["-wV"], ["O"], 70.0],
	["regola6", "A", ["-wo", "+wA"], ["V"], 100.0],
	["sostituzione S", "S", [], ["P"], 100.0]
] 

var lettere_to_texture ={
	"A" : preload("res://Textures/trasparente.png"),
	"T" : preload("res://Textures/nero.png"),
	"P" : preload("res://Textures/piattaforma.png"),
	"E" : preload("res://Textures/Edge_Sx.png"),
	"e" :preload("res://Textures/Edge_Dx.png"),
	"R" : preload("res://Textures/muro_ramp.png"),
	"r" : preload("res://Textures/muro_rampa_up.png"),
	"V" : preload("res://Textures/verticale.png"),
	"O" : preload("res://Textures/piattaforma_ostacolo.png"),
	"o" : preload("res://Textures/piattaforma_ostacolo_down.png"),
	"N" : preload("res://Textures/nemico.png"),
}
