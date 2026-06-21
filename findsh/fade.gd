extends CanvasLayer

signal first_fade_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition_to_scene(target_scene: String) -> void:
	animation_player.play("FADE_IN")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	animation_player.play_backwards("FADE_IN")
	
	if get_tree().paused:
		get_tree().paused = false

func first_fade() -> void:
	animation_player.play_backwards("FADE_IN")
	await animation_player.animation_finished
	first_fade_finished.emit()
