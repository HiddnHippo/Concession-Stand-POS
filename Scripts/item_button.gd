extends Button

@export var item_name: String
@export var item_price: float
@export var button_sound: AudioStreamMP3

signal selected_item


func _ready():
	text = item_name

func _on_pressed() -> void:
	selected_item.emit(item_name, item_price)
	SoundEngine.play_sound(button_sound)
