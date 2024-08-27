extends Panel

@onready var label: Label = $VBoxContainer/ColorRect/Label

var cash_entered: String = ""

var number_entry: String = "":
	set(val):
		cash_entered += val
		update_keypad(cash_entered)
		
var decimal: bool = false

signal cash_entry


func _on_key_one_pressed() -> void:
	number_entry = "1"
	

func _on_key_two_pressed() -> void:
	number_entry = "2"


func _on_key_three_pressed() -> void:
	number_entry = "3"


func _on_key_four_pressed() -> void:
	number_entry = "4"


func _on_key_five_pressed() -> void:
	number_entry = "5"


func _on_key_six_pressed() -> void:
	number_entry = "6"

func _on_key_seven_pressed() -> void:
	number_entry = "7"


func _on_key_eight_pressed() -> void:
	number_entry = "8"


func _on_key_nine_pressed() -> void:
	number_entry = "9"


func _on_key_zero_pressed() -> void:
	number_entry = "0"


func _on_key_dot_pressed() -> void:
	if decimal:
		return
	number_entry = "."
	decimal = true


func _on_key_enter_pressed() -> void:
	var cash = cash_entered.to_float()
	cash_entry.emit(cash)
	reset_keypad()


func reset_keypad():
	decimal = false
	hide()
	cash_entered = ""
	update_keypad("")


func update_keypad(n):
	label.text = n
