extends Control

signal main_menu
signal insufficient_funds
signal return_change
signal thank_you

var subtotal: float = 0.0:
	set(val):
		total += val
		subtotal = 0
		total_display.text = str("Total: ", total)
		
var total: float = 0.0
var tendered_amount: float = 0.0

var money_given: float = 0.0:
	set(val):
		tendered_amount += val
		val = 0
		tender_display.text = str("Tendered: ", tendered_amount)

@onready var cash_tendered: LineEdit = $VBoxContainer/HBoxContainer/CashBox/CashTendered
@onready var console_window: Label = $VBoxContainer/HBoxContainer/ColorRect/ScrollContainer/ConsoleWindow
@onready var total_display: Label = $VBoxContainer/HBoxContainer2/ColorRect/TotalDisplay
@onready var tender_display: Label = $VBoxContainer/HBoxContainer2/ColorRect/TenderDisplay


func _ready():
	hide()
	clear_transaction()
	
	
func _on_food_button_press():
	add_item("Food", 5)
	subtotal += 5
	

func _on_drink_button_press():
	add_item("Drink", 2)
	subtotal += 2
	

func _on_candy_button_press():
	add_item("Candy", 1)
	subtotal += 1
	
	
func _on_five_dollar_press():
	money_given += 5
	
	
func _on_ten_dollar_press():
	money_given += 10
	
	
func _on_twenty_dollar_press():
	money_given += 20
	
func _on_pay_press():
	if total == 0:
		clear_transaction()
		return
		
	if total > tendered_amount:
		insufficient_funds.emit()
		print("insufficient")
		tendered_amount = 0
		money_given = 0
		return
		
	if total < tendered_amount:
		calculate_change(tendered_amount)	
		
	elif total == tendered_amount:
		print("Thank You")
		thank_you.emit()
		clear_transaction()
		

func _on_tendered_amount_entered(amount):
	tendered_amount = amount.to_float()
	
	
func _on_menu_button_pressed():
	hide()
	clear_transaction()
	main_menu.emit()
	
	
func calculate_change(amt):
	var change = amt - total
	return_change.emit(change)
	clear_transaction()
	#open Change Window
	

func clear_transaction():
	total = 0.0
	subtotal = 0.0
	tendered_amount = 0.0
	money_given = 0.0
	cash_tendered.text = ""
	console_window.text = ""


func add_item(item_name:String, price:float):
	var text_to_add = str(item_name, ": ", price, "\n")
	console_window.text += text_to_add
