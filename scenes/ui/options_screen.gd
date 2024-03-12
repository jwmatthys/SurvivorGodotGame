extends CanvasLayer

signal close_option_menu

@onready var window_option_button = $%WindowOptionButton
@onready var sfx_volume_slider = $%SFXVolumeSlider
@onready var music_volume_slider = $%MusicVolumeSlider


func _ready():
	update_gui()


func update_gui():
	window_option_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_option_button.text = "Fullscreen"
	sfx_volume_slider.value = get_bus_volume_percent("sfx")
	music_volume_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_db(bus_name: String, rms: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(rms)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_sfx_volume_slider_value_changed(value):
	set_bus_volume_db("sfx", value)


func _on_music_volume_slider_value_changed(value):
	set_bus_volume_db("music", value)


func _on_back_button_pressed():
	close_option_menu.emit()


func _on_window_option_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_gui()
