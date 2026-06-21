extends Area3D

#@onready var original_albedo = $Mesh.get_active_material(0).albedo_color

@export var image_camera_pos: Vector3
@export var image_camera_rot: Vector3
@export var model = false

var y_escape = 0
var z_escape = 0
var x_escape = 0.5

var running_rotation = randi_range(0,20)

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
	
	if FishInfo.fish_running:
		y_escape = randf_range(-3,3)
		z_escape = randf_range(3,5)
		x_escape = randf_range(2,4)
		running_rotation = randf_range(0,20)
	
	if dir_mode == 1:
		global_rotation_degrees = Vector3(0,-90-running_rotation,0)
		global_position += Vector3(-x_escape*randf_range(1,4)*delta,y_escape*randf_range(1,4)*delta,z_escape*randf_range(1,4)*delta)
		#print(global_position)
	if dir_mode == 2:
		global_rotation_degrees = Vector3(0,90+running_rotation,0)
		global_position += Vector3(x_escape*randf_range(1,4)*delta,y_escape*randf_range(1,4)*delta,x_escape*randf_range(1,4)*delta)
		
	#if global_position.x > 18 and not model:
		#print("destroyed: " + name)
		#queue_free()
	
	#if FishInfo.pressed_fish != base_name:
		#
		##$Mesh.get_active_material(0).albedo_color = original_albedo
	#if FishInfo.previous_pressed_fish == base_name:
		#if FishInfo.current_fish != FishInfo.previous_pressed_fish:
			#$Mesh.get_active_material(0).next_pass.grow = false
	#if FishInfo.pressed_fish != base_name:
		#$Mesh.get_active_material(0).next_pass.grow = false
	#if FishInfo.pressed_fish == base_name:
		#$Mesh.get_active_material(0).next_pass.grow = false
	#if FishInfo.current_fish == base_name and FishInfo.current_fish != FishInfo.pressed_fish:
		#$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_entered() -> void:
	#if FishInfo.confirming: return
	FishInfo.current_fish = base_name
	#$Mesh.get_active_material(0).next_pass.grow = true


func _on_mouse_exited() -> void:
	#if FishInfo.confirming: return
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish != "":
		FishInfo.current_fish = FishInfo.pressed_fish
		#$Mesh.get_active_material(0).next_pass.grow = false
	if FishInfo.pressed_fish != base_name and FishInfo.pressed_fish == "":
		FishInfo.current_fish = ""
		#$Mesh.get_active_material(0).next_pass.grow = false


func _on_fish_pressed(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		#if FishInfo.confirming: return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			FishInfo.previous_pressed_fish = FishInfo.pressed_fish
			FishInfo.pressed_fish = base_name
			FishInfo.get_node("Camera_Flash").color = Color("ffffff")
			var camera_flash_tween = create_tween()
			camera_flash_tween.tween_property(FishInfo.get_node("Camera_Flash"),"color",Color("ffffff00"),0.7)
			FishInfo.fish_running = true
			await get_tree().create_timer(3.0).timeout
			
			FishInfo.create_draggable_picture()
			
			await get_tree().create_timer(5.0).timeout
			for child in get_tree().get_first_node_in_group("ocean").get_node("Fishes").get_children():
				child.queue_free()
			


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("DIED")
	queue_free()
