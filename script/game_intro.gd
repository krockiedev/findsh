extends Control

@onready var animation_intro = $AnimationPlayer

#Animation of Application
func _ready():
	animation_intro.play("Black_out1")
	$Main.play(39)
	get_tree().create_timer(3).timeout.connect(Black_in1)
	
func Black_in1():
	animation_intro.play("Black_in1")
	get_tree().create_timer(3).timeout.connect(Black_out2)
	
func Black_out2():
	animation_intro.play("Black_out2")
	get_tree().create_timer(4).timeout.connect(Black_in2)
	
func Black_in2():
	animation_intro.play("Black_in2")
	get_tree().create_timer(2).timeout.connect(Start)

func Start():
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/ocean.tscn")
