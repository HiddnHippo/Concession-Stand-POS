extends Control

@onready var item_name: LineEdit = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/ItemName
@onready var item_price: LineEdit = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/ItemPrice
@onready var option_button: OptionButton = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/OptionButton
@onready var color_picker_button: ColorPickerButton = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/Control/HBoxContainer/ColorPickerButton
@onready var location_edit: LineEdit = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/LocationEdit
@onready var console_label: Label = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/ColorRect/ConsoleLabel
@onready var resource_button_container: GridContainer = $ColorRect/VBoxContainer/HBoxContainer/ColorRect/ScrollContainer/ResourceButtonContainer
@onready var item_visible_button = $ColorRect/VBoxContainer/HBoxContainer/Panel/GridContainer/ItemVisibility
@onready var res_button = preload("res://Scenes/resource_button.tscn")
@onready var item_screen: Control = $ItemScreen

var resource: MenuItem
var resource_path: String = "user://"

signal main_menu


func _ready():
	item_screen.update_resource_location_to_management_screen.connect(_on_resource_location_update)


func open_screen():
	show()
	clear_item_data()
	load_menu_items()
	
	
func create_blank_item():
	resource = MenuItem.new()
	resource.item_name = "New Item"
	item_name.text = "New Item"
	update_console_text()
	

func save_resource_file(res_file):
	var success = ResourceSaver.save(res_file, str(resource_path, res_file.item_name.to_snake_case(), ".tres"), 0)
	if success == 0:
		var console_string = "Resource Saved Successfully"
		res_file = null
		console_label.text = console_string
		resource = null
		load_menu_items()
		
	
func update_item_information():
	if resource != null:
		var temp_resource = resource as MenuItem
		delete_resource()
		temp_resource.item_name = item_name.text
		temp_resource.item_price = item_price.text.to_float()
		temp_resource.item_type = option_button.selected as MenuItem.ITEM_TYPE
		temp_resource.location = int(location_edit.text)
		temp_resource.item_visible = item_visible_button.button_pressed
		var style = StyleBoxFlat.new()
		style.bg_color = color_picker_button.get_picker().color
		temp_resource.button_color = style
		save_resource_file(temp_resource)
	else:
		return
	
	
func update_console_text():
	var console_string = str("Item: ", item_name.text, "\nItem Price: ", item_price.text, "\nItem Type: ", convert_type(option_button.selected), "\nLocation: ")
	console_label.text = console_string
	
	
func clear_item_data():
	console_label.text = ""
	item_name.text = ""
	item_price.text = ""
	option_button.selected = 0
	
	
func convert_type(type):
	if type == 0:
		return "Drink"
	elif type == 1:
		return "Food"
	elif type == 2:
		return "Candy"
		

func load_menu_items():
	for c in resource_button_container.get_children():
		c.queue_free()
		
	var files = DirAccess.get_files_at(resource_path)
	for f in files:
		if !files.is_empty():
			if f.contains(".tres"):
				var button = res_button.instantiate() as ResourceButton
				resource_button_container.add_child(button)
				button.resource_file = ResourceLoader.load(str(resource_path, f))
				button.update_button()
				button.read_resource_file.connect(_on_resource_button_pressed)
			
			
func _on_resource_button_pressed(res_file: MenuItem):
	resource = res_file
	item_name.text = res_file.item_name
	item_price.text = str(res_file.item_price)
	location_edit.text = str(res_file.location)
	var style = res_file.button_color
	if style:
		color_picker_button.color = style.bg_color
	option_button.selected = int(res_file.item_type)
	item_visible_button.button_pressed = res_file.item_visible
	update_console_text()
	
	
func _on_button_pressed() -> void:
	hide()
	main_menu.emit()
	

func delete_resource():
	if resource == null:
		return
	for children in resource_button_container.get_children():
		children.queue_free()
	var dir = DirAccess.open(str(resource_path))
	dir.remove(str(resource_path, resource.item_name.to_snake_case(), ".tres"))
	load_menu_items()


func on_food_button_pressed():
	item_screen.open_item_screen(1, true)
	
	
func on_drink_button_pressed():
	item_screen.open_item_screen(0, true)
	
	
func on_candy_button_pressed():
	item_screen.open_item_screen(2, true)
	

func _on_resource_location_update(updated_resource):
	var files = DirAccess.get_files_at(resource_path)
	for f in files:
		if !files.is_empty():
			if f.contains(".tres"):
				var loaded_res = ResourceLoader.load(str(resource_path, f))
				if loaded_res.item_name == updated_resource.menu_item.item_name:
					loaded_res.location = updated_resource.menu_item.location
					save_resource_file(loaded_res)
