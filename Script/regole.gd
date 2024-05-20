extends Node2D

var regole = [
	#Nome; Trigger; Condizioni Aggiuntive; Sostituzione; Probabilità (deve essere ultima, modica in applica_regole)
	["regola1", "T", [], ["TTT"], 100.0],
	["regola2", "A", [], ["P"], 15.0],
	["regola3", "A", [], ["AAA"], 50.0],
	["regola4", "PA", [], ["PE"], 40.0],
	["regola5", "AP", [], ["eP"], 40.0]
] 

var lettere_to_texture ={
	"A": preload("res://Textures/aria_debug.png"),
	"T": preload("res://Textures/nero.png"),
	"P": preload("res://Textures/piattaforma.png"),
	"E": preload("res://Textures/Edge_Sx.png"),
	"e" :preload("res://Textures/Edge_Dx.png")
}
