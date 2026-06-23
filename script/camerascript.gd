extends Camera3D

@export var look_intensity_up: float = 15.0     
@export var look_intensity_down: float = 50.0   
@export var look_intensity_horizontal: float = 15.0

@export var max_look_angle: float = 20.0
@export var max_look_down_angle: float = 50.0
@export var smoothness: float = 5.0
@export var initial_rotation: Vector3

func _ready():
	initial_rotation = rotation_degrees
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(delta: float):
	var view_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	var mouse_x_normalized = (mouse_pos.x / view_size.x) * 2.0 - 1.0
	var mouse_y_normalized = (mouse_pos.y / view_size.y) * 2.0 - 1.0
	
	mouse_x_normalized = clamp(mouse_x_normalized, -1.0, 1.0)
	mouse_y_normalized = clamp(mouse_y_normalized, -1.0, 1.0)
	
	var target_yaw = -mouse_x_normalized * look_intensity_horizontal
	
	var target_pitch: float = 0.0
	if mouse_y_normalized > 0.0:
		
		target_pitch = mouse_y_normalized * look_intensity_down
	else:
		target_pitch = mouse_y_normalized * look_intensity_up
	
	target_yaw = clamp(target_yaw, -max_look_angle, max_look_angle)
	target_pitch = clamp(target_pitch, -max_look_angle, max_look_down_angle)

	var final_target_y = initial_rotation.y + target_yaw
	var final_target_x = initial_rotation.x + -target_pitch
	
	rotation_degrees.y = lerp(rotation_degrees.y, final_target_y, smoothness * delta)
	rotation_degrees.x = lerp(rotation_degrees.x, final_target_x, smoothness * delta)
