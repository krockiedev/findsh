extends Node3D

var spawn_fish = false

func _physics_process(delta: float) -> void:
	if FishInfo.fish_running:
		$Fish_Spawn_Timer.stop()


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not FishInfo.feeding_debouce and not FishInfo.submarine_moving and not FishInfo.fish_running and not $GPUParticles3D.emitting:
				FishInfo.feeding_debouce = true
				$GPUParticles3D.emitting = true
				await get_tree().create_timer(2.0).timeout
				$Fish_Spawn_Timer.start()
				await get_tree().create_timer(2.0).timeout
				$GPUParticles3D.emitting = false
				


var coral_fishes = {
	"Whale_Shark" = ["Whale_Shark",preload("uid://clyvaorjeacdb")]
	, "Sunfish" = ["Sunfish", preload("uid://d4h7ar3h2a1ke")]
	, "Clown_Fish" = ["Clown_Fish", preload("uid://c45klm7n10mfd")]
	, "Jellyfish" = ["Jellyfish", preload("uid://xcmaihnilmgx")]
	, "Scale_Fish" = ["Scale_Fish", preload("uid://dtvqrpryiafwv")]
	, "Mandarin_Fish" = ["Mandarin_Fish",preload("uid://blk853cbb6qfl")]
}

var mid_ocean_fishes = {
	"Sunfish" = ["Sunfish",preload("uid://d4h7ar3h2a1ke")]
	, "Whale_Shark" = ["Whale_Shark",preload("uid://clyvaorjeacdb")]
	, "Mandarin_Fish" = ["Mandarin_Fish",preload("uid://blk853cbb6qfl")]
	,"Milk_Fish" = ["Milk_Fish",preload("uid://btts0evqg6nd3")]
	,"F_Sunfish" = ["F_Sunfish",preload("uid://xergoasaqwfd")]
	
}

var abyss_fishes = {
	"Anglerfish" = ["Anglerfish",preload("uid://b31mgblwlr0nj")]
	,"F_Anglerfish" = ["F_Anglerfish",preload("uid://daexeyu477f0m")]
}


func _on_fish_spawn_timer_timeout() -> void:
	if FishInfo.fish_running: return
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
	
	
