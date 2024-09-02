extends Control


var resource_path: String = "user://"

@onready var grid_container = $ColorRect/GridContainer
@export var item_button: PackedScene

@onready var return_button: Button = $ColorRect/GridContainer/ReturnButton
@onready var line_edit: LineEdit = $ColorRect/ColorRect/LineEdit
@onready var line_box: ColorRect = $ColorRect/ColorRect

var selected_button: ItemButton = null
var starting_slot: int

signal buttons_ready
signal disconnect_button
signal update_resource_location_to_management_screen

func _ready():
	hide()
	line_box.hide()
	

func open_item_screen(type: int, test: bool = false):
	show()
	var resources = DirAccess.get_files_at(resource_path)
	for r in resources:
		if !r.contains(".tres"):
			continue
		var res = load(str(resource_path, r))
		if res is MenuItem and res.item_type == type:
			add_menu_item_button(res, test)
	update_button_order(test)
	

func update_button_order(test: bool):
	for c in grid_container.get_children():
		if c.name == "ReturnButton":
			continue
		else:
			c.update_button()
			grid_container.move_child(c, c.menu_item.location)
		grid_container.move_child(return_button, 0)
	if !test:
		buttons_ready.emit()
	
	
func add_menu_item_button(res: MenuItem, test: bool):
	var button = item_button.instantiate() as ItemButton
	grid_container.add_child(button)
	button.menu_item = res
	if test:
		button.can_move = true
		button.selected_to_move.connect(_on_button_selected_to_move)
	button.update_button()
	
	
func _on_back_button_pressed():
	hide()
	for c in grid_container.get_children():
		if c.name != "ReturnButton":
			disconnect_button.emit()
			c.queue_free()
			
			
func _on_button_selected_to_move(button: ItemButton):
	if selected_button == null:
		selected_button = button
		line_box.show()
		line_edit.text = ""
		
	
func _on_line_edit_text_submitted(submitted_text: String):
	line_box.hide()
	selected_button.menu_item.location = int(submitted_text)
	update_resource_location_to_management_screen.emit(selected_button)
	update_button_order(true)
	selected_button = null
