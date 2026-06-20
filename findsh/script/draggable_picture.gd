extends Node2D

var draggable = false
var is_inside_holder
var body_ref: StaticBody2D
var offset: Vector2

@onready var original_parent = get_parent()

func _process(_delta: float) -> void:
	if draggable and FishInfo.logged_fish.find(name) == -1:
		if Input.is_action_just_pressed("mouse_1"):
			offset = get_global_mouse_position() - global_position
			GlobalDraggingHandler.is_dragging = true
		if Input.is_action_pressed("mouse_1"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("mouse_1"):
			GlobalDraggingHandler.is_dragging = false
			var tween = create_tween()
			var size_tween = create_tween()
			if is_inside_holder:
				var found_draggable_picture: Node2D = nil
				for i in body_ref.get_children():
					if i.name.contains("Draggable_Picture"):
						found_draggable_picture = i
				
				# found a draggable picture in the
				#if found_draggable_picture != nil:
					#found_draggable_picture
					
				size_tween.tween_property(self, "scale", Vector2(0.54,0.54), 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "global_position", body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				reparent(body_ref)
				FishInfo.get_node("Confirm").show()
				FishInfo.get_node("Undo").show()
				FishInfo.confirming = true
				FishInfo.get_node("Log_Book").get_node("Previous_Page").hide()
				FishInfo.get_node("Log_Book").get_node("Next_Page").hide()
			else:
				size_tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", Vector2(888.0,189),0.2).set_ease(Tween.EASE_OUT)
				reparent(original_parent)


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
	if body.is_in_group("dropable"):
		is_inside_holder = true
		body.get_node("ColorRect").modulate = Color(Color.GRAY)
		body_ref = body


func _on_draggable_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_holder = false
		body.get_node("ColorRect").modulate = Color(Color.WHITE)
		body_ref = body
