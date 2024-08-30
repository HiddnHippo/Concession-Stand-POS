@tool
extends Button
class_name ItemButton

@export var button_sound: AudioStreamMP3
@export var menu_item: MenuItem

signal selected_item

	
func update_button():
	text = menu_item.item_name
	set("theme_override_styles/normal", menu_item.button_color)
	
	
func _on_pressed() -> void:
	selected_item.emit(menu_item.item_name, menu_item.item_price)
	SoundEngine.play_sound(button_sound)
