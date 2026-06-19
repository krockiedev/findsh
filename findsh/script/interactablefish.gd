extends Area3D

@export var fish_name = "bih fih"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	FishInfo.current_fish = fish_name
