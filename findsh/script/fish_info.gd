extends Control

var draggable_picture_scene = preload("res://scenes/draggable_picture.tscn")

var current_fish = ""
var previous_pressed_fish = ""
var pressed_fish = ""

var book_pages = {
	0: ["Large Fish", "This fih is big and it is found in mid level. It is also pruple."]
	,1: ["Medium Fish", "This fih is medium sized yuhhhhhhhhhh"]
	,2: ["Small Fish", "Killer fish"]
}

var logged_fish = []

func _physics_process(_delta: float) -> void:
	if current_fish != "": 
		var current_fish_name_text = current_fish.replace("_"," ")
		if logged_fish.find(current_fish) == -1:
			current_fish_name_text = "???"
		$Label.text = current_fish_name_text
		$Label.visible = true 
	else: $Label.visible = false
	
	$Log_Book/Fish_Name.text = book_pages[GlobalDraggingHandler.current_book_page][0]
	$Log_Book/Fish_Description.text = book_pages[GlobalDraggingHandler.current_book_page][1]
	
	for picture_holder_index in range(max_pages + 1):
		var current_holder = $Log_Book.get_node(str(picture_holder_index))
		if picture_holder_index != GlobalDraggingHandler.current_book_page:
			current_holder.hide()
			current_holder.remove_from_group("dropable")
		else:
			current_holder.show()
			current_holder.add_to_group("dropable")
		
var max_pages = 2

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
	var draggable_picture = draggable_picture_scene.instantiate()
	self.add_child(draggable_picture)
	draggable_picture.position = Vector2(888,189)
	
	pressed_fish = 
