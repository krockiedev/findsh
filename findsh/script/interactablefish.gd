extends Area3D

@export var fish_name = "bih fih"
@onready var original_albedo = $Mesh.get_active_material(0).albedo_color

func _ready() -> void:
	$Mesh.get_active_material(0).next_pass.grow = 0

func _physics_process(delta: float) -> void:
	if FishInfo.pressed_fish != fish_name:
		$Mesh.get_active_material(0).albedo_color = original_albedo
		



func _on_mouse_entered() -> void:
	FishInfo.current_fish = fish_name
	$Mesh.get_active_material(0).next_pass.grow = true
	$Mesh.get_active_material(0).next_pass.grow = 0.03


func _on_mouse_exited() -> void:
	if FishInfo.pressed_fish != fish_name:
		FishInfo.current_fish = ""
		$Mesh.get_active_material(0).next_pass.grow = false
		$Mesh.get_active_material(0).next_pass.grow = 0.0


func _on_fish_pressed(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			FishInfo.pressed_fish = fish_name
			$Mesh.get_active_material(0).albedo_color = Color("00ffff7e")
