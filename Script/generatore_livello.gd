extends Node2D

@export var width = 20
@export var height = 20
@export var texture_down = 20

var celle = []

# Called when the node enters the scene tree for the first time.
func _ready():
	inizializza_griglia()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func inizializza_griglia():
	for h in height:
		for w in width:
			var cella = preload("res://cella.tscn").instantiate()
			cella.position.x = texture_down*w
			cella.position.y = texture_down*h
			celle.append(cella)
			add_child(cella)
