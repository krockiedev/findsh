extends Node2D

var draggable = false
var is_inside_holder
var body_ref
var offset: Vector2

@onready var original_parent = get_parent()

func _process(delta: float) -> void:
	if draggable:
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
				size_tween.tween_property(self, "scale", Vector2(0.54,0.54), 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "global_position", body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				reparent(body_ref)
			else:
				size_tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", Vector2(673.576,-1.288),0.2).set_ease(Tween.EASE_OUT)
				reparent(original_parent)


func _on_draggable_mouse_entered() -> void:
	if not GlobalDraggingHandler.is_dragging:
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
		body.modulate = Color(Color.GRAY)
		body_ref = body


func _on_draggable_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_holder = false
		body.modulate = Color(Color.WHITE)
		body_ref = body
