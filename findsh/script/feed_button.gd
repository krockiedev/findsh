extends Node3D

var spawn_fish = false

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not FishInfo.feeding_debouce:
				FishInfo.feeding_debouce = true
				$GPUParticles3D.emitting = true
				await get_tree().create_timer(4.0).timeout
				$GPUParticles3D.emitting = false
				$Fish_Spawn_Timer.start()


var coral_fishes = {
	"Small_Fish" = ["Small_Fish",preload("uid://b31mgblwlr0nj")]
	,"Medium_Fish" = ["Medium_Fish",preload("uid://d4h7ar3h2a1ke")]
}

var mid_ocean_fishes = {
	"Medium_Fish" = preload("uid://d4h7ar3h2a1ke")
}

var abyss_fishes = {
	"Large_Fish" = preload("uid://clyvaorjeacdb")
}


func _on_fish_spawn_timer_timeout() -> void:
	print("spawn fish yo")
	var fish_dict = {}
	if FishInfo.current_depth_level == "coral": fish_dict = coral_fishes
	if FishInfo.current_depth_level == "mid_ocean": fish_dict = mid_ocean_fishes
	if FishInfo.current_depth_level == "abyss": fish_dict = abyss_fishes
	
	var random_key = fish_dict[fish_dict.keys().pick_random()]
	var fish: Area3D = random_key[1].instantiate()
	var random_dir = randi_range(1,2)
	fish.dir_mode = random_dir
	get_tree().get_first_node_in_group("Fishes").add_child(fish)
	fish.global_position = get_node("SpawnSide" + str(random_dir)).get_children().pick_random().global_position
	fish.name = random_key[0]
	
	
