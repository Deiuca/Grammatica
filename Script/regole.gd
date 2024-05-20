extends Node2D

var regole = [
	#Nome; Trigger; Condizioni Aggiuntive; Sostituzione; Probabilità (deve essere ultima, modica in applica_regole)
	["regola1", "T", [], ["TTT"], 100.0],
	["regola2", "A", ["+wA", "-wA","-w+1A", "+w+1A", "-w-1A", "+w-1A"], ["P"], 2.5],
	["regola6", "P", ["+wA", "-wA", "-w+1A", "+w+1A" ,"+1A", "-w+2A", "+w+2A"], ["PP"], 80.0],
	["regola4", "PA", ["+wA", "-wA"], ["PE"], 50.0],
	["regola5", "AP", ["+wA", "-wA"], ["eP"], 50.0],
] 

var lettere_to_texture ={
	"A": preload("res://Textures/aria_debug.png"),
	"T": preload("res://Textures/nero.png"),
	"P": preload("res://Textures/piattaforma.png"),
	"E": preload("res://Textures/Edge_Sx.png"),
	"e" :preload("res://Textures/Edge_Dx.png")
}
