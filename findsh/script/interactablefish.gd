extends Area3D

@export var fish_name = "bih fih"

func _ready() -> void:
	$LargeFish.get_active_material(0).next_pass.grow = 0


func _on_mouse_entered() -> void:
	FishInfo.current_fish = fish_name
	$LargeFish.get_active_material(0).next_pass.grow = true
	$LargeFish.get_active_material(0).next_pass.grow = 0.03


func _on_mouse_exited() -> void:
	FishInfo.current_fish = ""
	$LargeFish.get_active_material(0).next_pass.grow = false
	$LargeFish.get_active_material(0).next_pass.grow = 0.0
