extends Control


var resource_path: String = "user://"

@onready var grid_container = $GridContainer
@export var item_button: PackedScene

@onready var return_button: Button = $GridContainer/ReturnButton

signal buttons_ready
signal disconnect_button

func _ready():
	hide()
	

func open_item_screen(type: int, test: bool = false):
	show()
	var resources = DirAccess.get_files_at(resource_path)
	for r in resources:
		if !r.contains(".tres"):
			continue
		var res = load(str(resource_path, r))
		if res is MenuItem and res.item_type == type:
			add_menu_item_button(res)
	update_button_order(test)
	

func update_button_order(test: bool):
	for i in range(grid_container.get_child_count()):
		for c in grid_container.get_children():
			if c.name == "ReturnButton":
				continue
			if c.menu_item.location == i:
				grid_container.move_child(c, i)
		grid_container.move_child(return_button, 0)
	if test:
		return
	buttons_ready.emit()
	
	
func add_menu_item_button(res: MenuItem):
	var button = item_button.instantiate() as ItemButton
	grid_container.add_child(button)
	button.menu_item = res
	button.update_button()
	
	
func _on_back_button_pressed():
	hide()
	for c in grid_container.get_children():
		if c.name != "ReturnButton":
			disconnect_button.emit()
			c.queue_free()
