extends Button

@export var exact_button: bool
@export var round_up_button: bool
@export var dollar_amount: String

@export var button_sound: AudioStreamMP3

signal payment_key_pressed


func _ready():
	if dollar_amount != "":
		text = str("$", dollar_amount)

func _on_payment_button_pressed():
	payment_key_pressed.emit(dollar_amount)
	SoundEngine.play_sound(button_sound)


func update_context_buttons(amount_due):
	if exact_button:
		text = str("$", amount_due).pad_decimals(2)
		dollar_amount = str(amount_due)
	if round_up_button:
		var amt = (int(amount_due) + 1)
		text = str("$", amt)
		dollar_amount = str(amt)
		
		
