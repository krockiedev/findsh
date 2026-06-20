extends Node3D
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var playercam: Camera3D = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if camera_3d.current == false:
			playercam.current = false
			camera_3d.current = true
		else:
			playercam.current = true
			camera_3d.current = false
	
