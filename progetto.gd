extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_R):
		for c in self.get_children():
			self.remove_child(c)
			c.queue_free()
		add_child(preload("res://generatore_livello.tscn").instantiate())
