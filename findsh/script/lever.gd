extends Node3D

@onready var up_button = $Up_Button
@onready var down_button = $Down_Button

var moveable = true

func move_submarine(state: int):
	var submarine = get_tree().get_first_node_in_group("submarine")
	var tween_submarine = get_tree().create_tween()
	moveable = false
	match state:
		1:
			tween_submarine.tween_property(submarine,"global_position:y",submarine.global_position.y + 15,3)
		2:
			tween_submarine.tween_property(submarine,"global_position:y",submarine.global_position.y - 15,3)
	await tween_submarine.finished
	moveable = true
	
func pressed_up(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable:
				move_submarine(1)
	
func pressed_down(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable:
				move_submarine(2)
