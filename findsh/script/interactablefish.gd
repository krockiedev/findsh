extends Area3D

@onready var original_albedo = $Mesh.get_active_material(0).albedo_color

@export var image_camera_pos: Vector3
@export var image_camera_rot: Vector3

var dir_mode = 0

var base_name: String

func _ready() -> void:
	base_name = name.replace("_"," ")
	for i in range(10):
		base_name = base_name.replace(str(i),"")


func _physics_process(delta: float) -> void:
	#name fix
	if base_name.contains("@"):
		base_name = name.replace("_"," ")
		for i in range(10):
			base_name = base_name.replace(str(i),"")
	
	if dir_mode == 1:
		global_rotation_degrees = Vector3(0,-90,0)
		global_position += Vector3(-0.5*randf_range(1,4)*delta,0,0)
		#print(global_position)
	if dir_mode == 2:
		global_rotation_degrees = Vector3(0,90,0)
		global_position += Vector3(0.5*randf_range(1,4)*delta,0,0)
		
	if FishInfo.pressed_fish != base_name:
		$Mesh.get_active_material(0).albedo_color = original_albedo
	if FishInfo.previous_pressed_fish == base_name:
		if FishInfo.current_fish != FishInfo.previous_pressed_fish:
			$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.pressed_fish != base_name:
		$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.pressed_fish == base_name:
		$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.current_fish == base_name and FishInfo.current_fish != FishInfo.pressed_fish:
		$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_entered() -> void:
	#if FishInfo.confirming: return
	FishInfo.current_fish = base_name
	$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_exited() -> void:
	#if FishInfo.confirming: return
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish != "":
		FishInfo.current_fish = FishInfo.pressed_fish
		$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish == "":
		FishInfo.current_fish = ""
		$Mesh.get_active_material(0).next_pass.grow = false


func _on_fish_pressed(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		#if FishInfo.confirming: return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			FishInfo.previous_pressed_fish = FishInfo.pressed_fish
			FishInfo.pressed_fish = base_name
			
			$Mesh.get_active_material(0).albedo_color = Color("00ffff7e")
			
			FishInfo.create_draggable_picture()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("DIED")
	queue_free()
