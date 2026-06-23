extends Node3D

@onready var up_button = $Buttons/Up_Button
@onready var down_button = $Buttons/Down_Button
@onready var coralsfx: AudioStreamPlayer = $"../Coral"
@onready var midsfx: AudioStreamPlayer = $"../Mid"
@onready var abysssfx: AudioStreamPlayer = $"../Abyss"
@onready var moving: AudioStreamPlayer = $"../Moving"
@onready var bottom_hit: AudioStreamPlayer = $"../BottomHit"
@onready var button_anims: AnimationPlayer = $Buttons/AnimationPlayer
@onready var downsfx: AudioStreamPlayer3D = $ButtonDownSFX
@onready var upsfx: AudioStreamPlayer3D = $ButtonUpSFX

var moveable = true
var subposition = "coral"

func volume_adjust(SFX:AudioStreamPlayer, state: int):
	var tween_volume = get_tree().create_tween().set_parallel(true)
	match state:
		1:
			tween_volume.tween_property(SFX, "volume_db", -40, 5)\
			.set_trans(Tween.TRANS_EXPO)
		2:
			SFX.playing = true
			tween_volume.tween_property(SFX, "volume_db", 15, 5)\
			.set_trans(Tween.TRANS_EXPO)
	await tween_volume.finished
	if state == 1:
		SFX.playing = false
	
func _ready() -> void:
	coralsfx.playing = true
	midsfx.playing = false
	abysssfx.playing = false
func move_submarine(state: int):
	var submarine = get_tree().get_first_node_in_group("submarine")
	var ocean_node = get_tree().get_first_node_in_group("ocean")
	var tween_submarine = get_tree().create_tween()
	var ui_node = get_tree().get_first_node_in_group("depth")
	moveable = false
	FishInfo.submarine_moving = true
	FishInfo.fish_running = true

	var start_y: float = submarine.global_position.y
	var target_y: float = start_y
	var move_duration: float = 7.0
	match state:
		1:
			if subposition == "coral":
				return
			elif subposition == "abyss":
				subposition = "mid_ocean"
				volume_adjust(coralsfx,1)
				volume_adjust(abysssfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("0f2e55"), 25.0, 7.0)
				target_y = start_y + 90
				move_duration = 15.0
				tween_submarine.tween_property(submarine, "global_position:y", target_y, move_duration)
			elif subposition == "mid_ocean":
				subposition = "coral"
				volume_adjust(midsfx,1)
				volume_adjust(coralsfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("1a867aff"), 40.0, 7.0)
				target_y = start_y + 90
				move_duration = 7.0
				tween_submarine.tween_property(submarine, "global_position:y", target_y, move_duration)
		2:
			if subposition == "abyss":
				return
			elif subposition == "coral":
				subposition = "mid_ocean"
				volume_adjust(coralsfx,1)
				volume_adjust(midsfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("1a457aff"), 25.0, 7.0)
				target_y = start_y - 90
				move_duration = 7.0
				tween_submarine.tween_property(submarine, "global_position:y", target_y, move_duration)
			elif subposition == "mid_ocean":
				subposition = "abyss"
				volume_adjust(midsfx,1)
				volume_adjust(abysssfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("01090e"), 15.0, 6.0)
				target_y = start_y - 90
				move_duration = 10.0
				tween_submarine.tween_property(submarine, "global_position:y", target_y, move_duration)

	# Now your UI depth indicator scales perfectly to match whatever route you chose!
	if ui_node:
		tween_submarine.parallel().tween_method(
			ui_node.update_depth_meter, 
			start_y, 
			target_y, 
			move_duration 
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	await tween_submarine.finished
	FishInfo.current_depth_level = subposition
	if subposition == "abyss":
		bottom_hit.play()
	moveable = true
	FishInfo.submarine_moving = false
	FishInfo.fish_running = false
	
func pressed_up(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable and subposition != "coral":
				move_submarine(1)
				button_anims.play("UpButtonAction")
				upsfx.play()
	
func pressed_down(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable and subposition != "abyss":
				move_submarine(2)
				button_anims.play("DownButtonAction")
				downsfx.play()


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not FishInfo.get_node("Log_Book").visible:
				FishInfo.get_node("Log_Book").show()
			else:
				FishInfo.get_node("Log_Book").hide()
