extends CanvasLayer

@onready var panel_container = %PanelContainer

var options_menu_scene = preload("res://scenes/ui/options_screen.tscn")

var is_closing:bool = false


func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	$AnimationPlayer.play("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	get_tree().paused = false
	queue_free()

func _on_quit_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")


func _on_options_button_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.close_option_menu.connect(on_close_options_menu.bind(options_menu_instance))


func _on_resume_button_pressed():
	close()


func on_close_options_menu(options_menu: Node):
	options_menu.queue_free()
