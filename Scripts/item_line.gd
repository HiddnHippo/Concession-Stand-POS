extends PanelContainer

var item_name: String
var item_price: float

signal remove_item

@onready var label = $Panel/Label

func update_item(n: String, p: float):
	label.text = str(n, ": ", p)
	item_name = n
	item_price = p

func _on_button_pressed():
	remove_item.emit(self)
