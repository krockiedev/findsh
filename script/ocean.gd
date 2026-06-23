extends Node3D

@onready var ocean_environment: WorldEnvironment = $OceanEnvironment

var environment_tween: Tween

func transition_ocean_depth(target_color: Color, target_end_distance: float, duration: float) -> void:
	if environment_tween and environment_tween.is_running():
		environment_tween.kill()
		
	environment_tween = create_tween()
	environment_tween.set_parallel(true)
	
	# Using CUBIC + EASE_IN makes colors stay light at first, then drop to black at the end
	environment_tween.tween_property(
		ocean_environment, 
		"environment:fog_light_color", 
		target_color, 
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	# Keep the fog distance pushed out wide for longer before it closes in tightly
	environment_tween.tween_property(
		ocean_environment, 
		"environment:fog_depth_end", 
		target_end_distance, 
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# Make sure the background color matches the exact same curve!
	environment_tween.tween_property(
		ocean_environment,
		"environment:background_color",
		target_color,
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
