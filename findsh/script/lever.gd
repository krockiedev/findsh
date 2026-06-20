extends Node3D

@onready var up_button = $Up_Button
@onready var down_button = $Down_Button
@onready var coralsfx: AudioStreamPlayer = $"../Coral"
@onready var midsfx: AudioStreamPlayer = $"../Mid"
@onready var abysssfx: AudioStreamPlayer = $"../Abyss"
@onready var moving: AudioStreamPlayer = $"../Moving"
@onready var bottom_hit: AudioStreamPlayer = $"../BottomHit"

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
			tween_volume.tween_property(SFX, "volume_db", 0, 5)\
			.set_trans(Tween.TRANS_EXPO)
	await tween_volume.finished
	if state == 1:
		SFX.playing = false
	if SFX == abysssfx and state == 2:
		bottom_hit.play()
	
func _ready() -> void:
	coralsfx.playing = true
	midsfx.playing = false
	abysssfx.playing = false
func move_submarine(state: int):
	var submarine = get_tree().get_first_node_in_group("submarine")
	var ocean_node = get_tree().get_first_node_in_group("ocean")
	var tween_submarine = get_tree().create_tween()
	
	moveable = false
	
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
				tween_submarine.tween_property(submarine, "global_position:y", submarine.global_position.y + 15, 7)
				await tween_submarine.finished
				FishInfo.current_depth_level = subposition
				
			elif subposition == "mid_ocean":
				subposition = "coral"
				volume_adjust(midsfx,1)
				volume_adjust(coralsfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("1a867aff"), 40.0, 7.0)
				tween_submarine.tween_property(submarine, "global_position:y", submarine.global_position.y + 15, 7)
				await tween_submarine.finished
				FishInfo.current_depth_level = subposition
		2:
			if subposition == "abyss":
				return
			elif subposition == "coral":
				subposition = "mid_ocean"
				volume_adjust(coralsfx,1)
				volume_adjust(midsfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("1a457aff"), 25.0, 10.0)
				tween_submarine.tween_property(submarine, "global_position:y", submarine.global_position.y - 15, 10)
				await tween_submarine.finished
				FishInfo.current_depth_level = subposition
			elif subposition == "mid_ocean":
				subposition = "abyss"
				volume_adjust(midsfx,1)
				volume_adjust(abysssfx,2)
				if ocean_node:
					ocean_node.transition_ocean_depth(Color("01090e"), 10.0, 10.0)
				tween_submarine.tween_property(submarine, "global_position:y", submarine.global_position.y - 15, 10)
				
	await tween_submarine.finished
	moveable = true
	
func pressed_up(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable and subposition != "coral":
				move_submarine(1)
	
func pressed_down(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if moveable and subposition != "abyss":
				move_submarine(2)


func change_global_level_depth(tween):
		await tween.finished
		FishInfo.current_depth_level = subposition
