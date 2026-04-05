extends Node2D

func go_back():
	get_tree().change_scene_to_file("res://main.tscn")
func _input(event):
	if(Input.is_action_pressed("ui_cancel")):
		go_back()

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	go_back()
