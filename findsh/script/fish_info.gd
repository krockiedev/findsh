extends Control

var current_fish = ""
var pressed_fish = ""

func _physics_process(delta: float) -> void:
	if current_fish != "": 
		$Label.text = current_fish
		$Label.visible = true 
	else: $Label.visible = false


func _on_label_theme_changed() -> void:
	pass # Replace with function body.
