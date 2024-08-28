extends Button

@export var button_amount: String
@export var button_sound :AudioStreamMP3

signal cash_input_entry

func _ready():
	text = str(button_amount)
	
	
func _on_button_pressed():
	cash_input_entry.emit(button_amount)
	
	SoundEngine.play_sound(button_sound)
