extends Control

signal main_menu
signal insufficient_funds
signal return_change
signal thank_you
signal save_sales_report

var subtotal: float = 0.0:
	set(val):
		total += val
		subtotal = 0
		total_display.text = str("Total: ", total).pad_decimals(2)
		
var total: float = 0.0
var tendered_amount: float = 0.0

var sales_report = {}
var customer_count: int = 0
var sales_total: float

var money_given: float = 0.0:
	set(val):
		tendered_amount += val
		val = 0
		
var payment_types

@onready var item_window: VBoxContainer = $VBoxContainer/HBoxContainer/ColorRect/ScrollContainer/ItemWindow
@onready var total_display: Label = $VBoxContainer/ColorRect2/TotalDisplay


@onready var keypad: Control = $Keypad
@onready var food_screen = $FoodScreen
@onready var candy_screen = $CandyScreen
@onready var drinks_screen = $DrinksScreen

@onready var item_line_panel = preload("res://Scenes/item_line.tscn")

func _ready():
	customer_count = 0
	hide()
	clear_transaction()
	keypad.hide()
	food_screen.hide()
	keypad.cash_entry.connect(_on_keypad_cash_entry)
	
	var items = get_tree().get_nodes_in_group("items")
	for i in items:
		i.selected_item.connect(_on_add_item)
		
	payment_types = get_tree().get_nodes_in_group("payment_buttons")
	for p in payment_types:
		p.payment_key_pressed.connect(_on_payment_key_pressed)
	

func _on_payment_key_pressed(amt):
	money_given = amt.to_float()
	pay()
	
	
func _on_food_button_press():
	food_screen.show()
	
	
func _on_drink_button_press():
	drinks_screen.show()
	
	
func _on_candy_button_press():
	candy_screen.show()
	
	
func pay():
	if total == 0:
		clear_transaction()
		return
		
	if total > tendered_amount:
		insufficient_funds.emit()
		tendered_amount = 0
		money_given = 0
		return
		
	if total < tendered_amount:
		calculate_change(tendered_amount)	
		
	elif total == tendered_amount:
		thank_you.emit()
		clear_transaction()
	customer_count += 1
		
	
func _on_menu_button_pressed():
	hide()
	clear_transaction()
	main_menu.emit()
	
	
func _on_amount_input_pressed():
	if total == 0:
		return
	keypad.show()
	
	
func _on_keypad_cash_entry(val):
	money_given = val
	pay()
		
		
func _on_add_item(item_name:String, price:float):
	var p = item_line_panel.instantiate()
	item_window.add_child(p)
	p.update_item(item_name, price)
	p.remove_item.connect(_on_remove_item)
	subtotal += price
	update_context_buttons()
	
	
func _on_remove_item(item):
	item.queue_free()
	subtotal -= item.item_price
	update_context_buttons()
	

func update_context_buttons():
	for payment_buttons in payment_types:
		payment_buttons.update_context_buttons(total)
		
		
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
	customer_count += 1
	if payment_types != null:
		update_context_buttons()
	for c in item_window.get_children():
		add_to_sales_report(c)
		c.queue_free()
		
		
func add_to_sales_report(item):
	if sales_report.has(item.item_name):
		var quantity = sales_report[item.item_name]
		quantity += 1
		sales_report[item.item_name] = quantity
	else:
		var temp_dictionary = {str(item.item_name):1}
		sales_report.merge(temp_dictionary)
	sales_total += item.item_price
	save_sales_report.emit(sales_report, sales_total, customer_count)
	sales_report = {}
