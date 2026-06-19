extends Control

var current_fish = ""
var previous_pressed_fish = ""
var pressed_fish = ""

var logged_fish = []

func _physics_process(delta: float) -> void:
	if current_fish != "": 
		var current_fish_name_text = current_fish
		if logged_fish.find(current_fish) == -1:
			current_fish_name_text = "???"
		$Label.text = current_fish_name_text
		$Label.visible = true 
	else: $Label.visible = false


func _on_label_theme_changed() -> void:
	pass # Replace with function body.
