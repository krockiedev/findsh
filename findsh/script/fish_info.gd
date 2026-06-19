extends Control

var current_fish = ""
var previous_pressed_fish = ""
var pressed_fish = ""

var book_pages = {
	0: ["big fih", "This fih is big and it is found in mid level. It is also pruple."]
	,1: ["mid fih", "This fih is medium sized yuhhhhhhhhhh"]
	,2: ["san diego", "Killer fish"]
}

var logged_fish = []

func _physics_process(delta: float) -> void:
	if current_fish != "": 
		var current_fish_name_text = current_fish
		if logged_fish.find(current_fish) == -1:
			current_fish_name_text = "???"
		$Label.text = current_fish_name_text
		$Label.visible = true 
	else: $Label.visible = false
	
	$Log_Book/Fish_Name.text = book_pages[page][0]
	$Log_Book/Fish_Description.text = book_pages[page][1]


var page = 0
func _on_previous_page_pressed() -> void:
	if page == 0: page = 2
	else: page -= 1

func _on_next_page_pressed() -> void:
	if page == 2: page = 0
	else: page += 1


func _on_open_book_pressed() -> void:
	if $Open_Book.text == "Open Log Book":
		$Log_Book.show()
		$Open_Book.text = "Close Log Book"
	else:
		$Log_Book.hide()
		$Open_Book.text = "Open Log Book"
