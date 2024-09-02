@tool
extends Button
class_name ItemButton

@export var button_sound: AudioStreamMP3
@export var menu_item: MenuItem

signal selected_item
signal selected_to_move

var can_move: bool = false

	
func update_button():
	text = menu_item.item_name
	set("theme_override_styles/normal", menu_item.button_color)
	if can_move:
		text += str("\n[", menu_item.location, "]")
	
	
func _on_pressed() -> void:
	if can_move:
		selected_to_move.emit(self)
	else:
		selected_item.emit(menu_item.item_name, menu_item.item_price)
		SoundEngine.play_sound(button_sound)
