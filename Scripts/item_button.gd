extends Button

@export var item_name: String
@export var item_price: float

signal selected_item

@onready var button_click = $ButtonClick


func _ready():
	text = item_name

func _on_pressed() -> void:
	selected_item.emit(item_name, item_price)
	button_click.play()
