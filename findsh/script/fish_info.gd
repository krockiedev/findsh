extends Control

@export var current_fish = ""

func _physics_process(delta: float) -> void:
	if current_fish != "": 
		$Label.text = current_fish
		$Label.visible = true 
	else: $Label.visible = false
