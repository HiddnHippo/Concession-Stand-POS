extends Button
class_name ResourceButton

var resource_file: MenuItem

signal read_resource_file


func update_button():
	if resource_file:
		text = resource_file.item_name
		set("theme_override_styles/normal", resource_file.button_color)

func _on_button_pressed():
	read_resource_file.emit(resource_file)
