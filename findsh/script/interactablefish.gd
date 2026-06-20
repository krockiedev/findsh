extends Area3D

@onready var original_albedo = $Mesh.get_active_material(0).albedo_color

@export var image_camera_pos: Vector3
@export var image_camera_rot: Vector3

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if FishInfo.pressed_fish != name:
		$Mesh.get_active_material(0).albedo_color = original_albedo
	if FishInfo.previous_pressed_fish == name:
		$Mesh.get_active_material(0).next_pass.grow = false
		FishInfo.previous_pressed_fish = ""


func _on_mouse_entered() -> void:
	FishInfo.current_fish = name
	$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_exited() -> void:
	if FishInfo.pressed_fish != name:
		FishInfo.current_fish = ""
		$Mesh.get_active_material(0).next_pass.grow = false


func _on_fish_pressed(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			FishInfo.previous_pressed_fish = FishInfo.pressed_fish
			FishInfo.pressed_fish = name
			$Mesh.get_active_material(0).albedo_color = Color("00ffff7e")
			
			FishInfo.create_draggable_picture()
