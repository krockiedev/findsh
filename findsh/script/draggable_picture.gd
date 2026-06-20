extends Node2D

var draggable = false
var is_inside_holder
var body_ref: StaticBody2D
var offset: Vector2
var pictured_fish

@onready var original_parent = get_parent()

func _process(_delta: float) -> void:
	# name label title
	var full_name_for_the_label = ""
	for i in range(FishInfo.logged_fish[pictured_fish].size()):
		if i == 0: 
			full_name_for_the_label += str(FishInfo.logged_fish[pictured_fish][i])
		else:
			full_name_for_the_label += " / " + str(FishInfo.logged_fish[pictured_fish][i])
		
	$Label.text = full_name_for_the_label
	
	if draggable:
		if Input.is_action_just_pressed("mouse_1"):
			offset = get_global_mouse_position() - global_position
			GlobalDraggingHandler.is_dragging = true
			$Label.hide()
		if Input.is_action_pressed("mouse_1"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("mouse_1"):
			GlobalDraggingHandler.is_dragging = false
			
			if is_inside_holder:
				var tween = create_tween()
				var size_tween = create_tween()
				size_tween.tween_property(self, "scale", Vector2(0.54,0.54), 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "global_position", body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				
				# check if the body (image frame) already has a picture
				var found_draggable_picture: Node2D = null
				for i in body_ref.get_children():
					if i.find_child("SubViewportContainer"):
						found_draggable_picture = i
				
				reparent(body_ref)
				
				# found a draggable picture in the body
				if found_draggable_picture != null:
					found_draggable_picture.reparent(FishInfo)
					found_draggable_picture._tween_back()
					if FishInfo.logged_fish[found_draggable_picture.pictured_fish].size() == 1:
						print("ho")
						FishInfo.logged_fish[found_draggable_picture.pictured_fish][0] = "???"
					else:
						FishInfo.logged_fish[found_draggable_picture.pictured_fish].erase(FishInfo.book_pages[int(get_parent().name)][0])
				
				#FishInfo.get_node("Confirm").show()
				#FishInfo.get_node("Undo").show()
				FishInfo.confirming = true
				#FishInfo.get_node("Log_Book").get_node("Previous_Page").hide()
				#FishInfo.get_node("Log_Book").get_node("Next_Page").hide()
				if FishInfo.logged_fish[pictured_fish][0] == "???":
					FishInfo.logged_fish[pictured_fish][0] = FishInfo.book_pages[int(get_parent().name)][0]
				elif FishInfo.logged_fish[pictured_fish].find(FishInfo.book_pages[int(get_parent().name)][0]) == -1:
					FishInfo.logged_fish[pictured_fish].append(FishInfo.book_pages[int(get_parent().name)][0])
			else:
				_tween_back()
				reparent(original_parent)


func _tween_back():
	$Label.show()
	var tween = create_tween()
	var size_tween = create_tween()
	size_tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(888.0,189),0.2).set_ease(Tween.EASE_OUT)


func _on_draggable_mouse_entered() -> void:
	if not GlobalDraggingHandler.is_dragging and not is_inside_holder:
		draggable = true
		if !is_inside_holder: scale = Vector2(1.02,1.02)
		else: scale = Vector2(0.55,0.55)


func _on_draggable_mouse_exited() -> void:
	if not GlobalDraggingHandler.is_dragging:
		draggable = false
		if !is_inside_holder: scale = Vector2(1,1)
		else: scale = Vector2(0.54,0.54)


func _on_draggable_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable") and FishInfo.get_node("Log_Book").visible:
		is_inside_holder = true
		body.get_node("ColorRect").modulate = Color(Color.GRAY)
		body_ref = body


func _on_draggable_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_holder = false
		body.get_node("ColorRect").modulate = Color(Color.WHITE)
		body_ref = body
