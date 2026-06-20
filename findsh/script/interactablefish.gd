extends Area3D

@onready var original_albedo = $Mesh.get_active_material(0).albedo_color

@export var image_camera_pos: Vector3
@export var image_camera_rot: Vector3

var base_name

func _ready() -> void:
	base_name = name.replace("_"," ")
	for i in range(9):
		base_name = base_name.replace(str(i),"")


func _physics_process(_delta: float) -> void:
	if FishInfo.pressed_fish != base_name:
		$Mesh.get_active_material(0).albedo_color = original_albedo
	if FishInfo.previous_pressed_fish == base_name:
		if FishInfo.current_fish != FishInfo.previous_pressed_fish:
			$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.confirming and FishInfo.pressed_fish != base_name:
		$Mesh.get_active_material(0).next_pass.grow = false

func _on_mouse_entered() -> void:
	if FishInfo.confirming: return
	FishInfo.current_fish = base_name
	$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_exited() -> void:
	if FishInfo.confirming: return
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish != "":
		FishInfo.current_fish = FishInfo.pressed_fish
		$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish == "":
		FishInfo.current_fish = ""
		$Mesh.get_active_material(0).next_pass.grow = false


func _on_fish_pressed(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if FishInfo.confirming: return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			FishInfo.previous_pressed_fish = FishInfo.pressed_fish
			FishInfo.pressed_fish = base_name
			
			$Mesh.get_active_material(0).albedo_color = Color("00ffff7e")
			
			if FishInfo.logged_fish.find(base_name) == -1:
				FishInfo.create_draggable_picture()
