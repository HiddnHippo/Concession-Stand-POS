extends Control

@onready var label: Label = $Keypad/VBoxContainer/ColorRect/Label

var cash_entered: String = ""

var number_entry: String = "":
	set(val):
		cash_entered += val
		update_keypad(cash_entered)
		
var decimal: bool = false

signal cash_entry


func _ready():
	var cash_buttons = get_tree().get_nodes_in_group("cash_buttons")
	for b in cash_buttons:
		b.cash_input_entry.connect(_on_cash_input_entered)
		
		
func _on_cash_input_entered(entry: String):
	if entry == ".":
		if decimal == true:
			return
	number_entry += entry
	
	
func _on_key_enter_pressed() -> void:
	var cash = cash_entered.to_float()
	cash_entry.emit(cash)
	reset_keypad()
	hide()

func reset_keypad():
	decimal = false
	cash_entered = ""
	update_keypad("")


func update_keypad(n):
	label.text = n
