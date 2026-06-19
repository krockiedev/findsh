extends Node3D

@onready var up_button = $Up_Button
@onready var down_button = $Down_Button


var button_that_mouse_is_on = ""


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_1"):
		print(button_that_mouse_is_on)


func _on_up_button_mouse_entered() -> void:
	print("mouse is on up!!!")
	button_that_mouse_is_on = "up"
	
	
func _on_up_button_mouse_exited() -> void:
	button_that_mouse_is_on = ""


func _on_down_button_mouse_entered() -> void:
	print("mouse is on down!!!")
	button_that_mouse_is_on = "down"


func _on_down_button_mouse_exited() -> void:
	button_that_mouse_is_on = ""
