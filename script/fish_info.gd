extends Control

var draggable_picture_scene = preload("res://scenes/draggable_picture.tscn")

var current_depth_level = "coral"
var feeding_debouce = false

var current_fish = ""
var previous_pressed_fish = ""
var pressed_fish = ""

var fish_running = false

var submarine_moving = false

var confirming: bool

var book_pages = {
	0: ["Whale Shark", "In the twilight and shallows", "Depressed, and flat head.","Large"]
	,1: ["Sunfish", "In the shallows and twilight zone", "Scale-less with rubbery skin.", "Medium"]
	,2: ["Anglerfish", "In the abyss", "Dorsal spine that acts as a fishing rod.","Medium"]
	,3: ["Clown Fish", "Corals", "Bright orange color with three white bands", "Small"]
	,4: ["Jellyfish", "Corals", "Invertebrate with multiple tentacles","Small"]
	,5: ["Scale Fish", "In the shallows", "Predominantly orange", "Very Small"]
	,6: ["Mandarin Fish", "Shallows and twilight", "Bright orange skin, bulbous eyes", "Medium"]
	,7: ["Milk Fish", "Twilight", "Elongated and compressed, small mouth", "Small"]
	,8: ["F Sunfish", "Twilight", "Mutated sunfish, has protuding bones", "Medium"]
	,9: ["F Anglerfish", "Abyss", "Anglerfish that produces more light.","Medium"]
}

var logged_fish = {
	"Whale Shark": ["???"]
	,"Sunfish": ["???"]
	, "Anglerfish": ["???"]
	, "Clown Fish": ["???"]
	, "Jellyfish": ["???"]
	, "Scale Fish": ["???"]
	, "Mandarin Fish": ["???"]
	, "Milk Fish": ["???"]
	, "F Sunfish": ["???"]
	, "F Anglerfish": ["???"]
	}

func _physics_process(_delta: float) -> void: 
	# 1. Fetch the Fishes node globally from the tree group
	var fishes_node = get_tree().get_first_node_in_group("Fishes")
	
	# 2. Always verify it was safely found before checking its children size!
	if fishes_node:
		var fish_count = fishes_node.get_children().size()
		
		if fish_count == 0:
			if not submarine_moving:
				feeding_debouce = false
				fish_running = false
		elif fish_count > 0:
			feeding_debouce = true
	
	$Log_Book/Fish_Name.text = book_pages[GlobalDraggingHandler.current_book_page][0]
	$Log_Book/Where_To_Find.text = book_pages[GlobalDraggingHandler.current_book_page][1]
	$Log_Book/Where_To_Find2.text = book_pages[GlobalDraggingHandler.current_book_page][2]
	$Log_Book/Where_To_Find3.text = book_pages[GlobalDraggingHandler.current_book_page][3]
	
	for picture_holder_index in range(max_pages + 1):
		var current_holder = $Log_Book.get_node(str(picture_holder_index))
		if picture_holder_index != GlobalDraggingHandler.current_book_page:
			current_holder.hide()
			current_holder.remove_from_group("dropable")
		else:
			current_holder.show()
			current_holder.add_to_group("dropable")
	
	if Input.is_action_just_pressed("left"):
		if GlobalDraggingHandler.current_book_page == 0: GlobalDraggingHandler.current_book_page = max_pages
		else: GlobalDraggingHandler.current_book_page -= 1
	
	if Input.is_action_just_pressed("right"):
		if GlobalDraggingHandler.current_book_page == max_pages: GlobalDraggingHandler.current_book_page = 0
		else: GlobalDraggingHandler.current_book_page += 1


var max_pages = 9
func _on_previous_page_pressed() -> void:
	if GlobalDraggingHandler.current_book_page == 0: GlobalDraggingHandler.current_book_page = max_pages
	else: GlobalDraggingHandler.current_book_page -= 1


func _on_next_page_pressed() -> void:
	if GlobalDraggingHandler.current_book_page == max_pages: GlobalDraggingHandler.current_book_page = 0
	else: GlobalDraggingHandler.current_book_page += 1


func _on_open_book_pressed() -> void:
	if $Open_Book.text == "Open Log Book":
		$Log_Book.show()
		$Open_Book.text = "Close Log Book"
	else:
		$Log_Book.hide()
		$Open_Book.text = "Open Log Book"


func create_draggable_picture():
	$Print.play(5.0)
	for i in self.get_children():
		if i.find_child("SubViewportContainer"): i.queue_free()
	
	var draggable_picture = draggable_picture_scene.instantiate()
	draggable_picture.position = Vector2(888,189)
	draggable_picture.name = "Draggable_Picture"
	var fish_in_3d = $Fishes.get_node(str(pressed_fish.replace(" ", "_")))
	
	draggable_picture.get_node("%Camera3D").position = fish_in_3d.image_camera_pos
	draggable_picture.get_node("%Camera3D").rotation_degrees = fish_in_3d.image_camera_rot
	draggable_picture.pictured_fish = pressed_fish
	$Timer.start() 
	await $Timer.timeout
	
	self.add_child(draggable_picture)


# not in use :P
func _on_confirm_pressed() -> void:
	confirming = false
	#logged_fish.append(pressed_fish)
	$Confirm.hide()
	$Undo.hide()
	$Log_Book.get_node(str(GlobalDraggingHandler.current_book_page)).remove_from_group("dropable")
	$Log_Book/Previous_Page.show()
	$Log_Book/Next_Page.show()
