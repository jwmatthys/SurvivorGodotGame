extends CanvasLayer

var options_menu = preload("res://scenes/ui/options_screen.tscn")
	

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed():
	var options_instance = options_menu.instantiate()
	add_child(options_instance)
	options_instance.close_option_menu.connect(on_options_menu_closed.bind(options_instance))


func _on_quit_button_pressed():
	get_tree().quit()


func on_options_menu_closed(options_instance: Node):
	options_instance.queue_free()
