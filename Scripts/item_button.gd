@tool
extends Button


@export var button_sound: AudioStreamMP3
@export var menu_item: MenuItem

	
signal selected_item


func _ready():
	if menu_item:
		if Engine.is_editor_hint():
			text = menu_item.item_name
		text = menu_item.item_name
		
			
func _on_pressed() -> void:
	selected_item.emit(menu_item.item_name, menu_item.item_price)
	SoundEngine.play_sound(button_sound)
