extends Control

@onready var label = $ColorRect/ScrollContainer/Label
@onready var grid_container: GridContainer = $ColorRect/GridContainer

var report_text: String = ""
var resource_path = "res://Menu/MenuItems/"
var sales_total: float = 0.0
var res_loader = ResourcePreloader.new()
var count: int = 0

signal main_menu


func _ready():
	label.hide()
	
	
func hide_text():
	label.hide()
	
	
func add_button(file):
	var b = Button.new()
	grid_container.add_child(b)
	b.text = file
	b.pressed.connect(sort_report.bind(file))
	
	
func print_report(requested_report: Dictionary):
	label.show()
	report_text = ""
	sales_total = 0
	
	for sale in requested_report:
		if sale != "Customer Count":
			var resources = DirAccess.get_files_at(resource_path)
			for r in resources:
				var res = load(str(resource_path, r))
				if res.item_name == sale:
					var quantity = requested_report[sale]
					sales_total += (quantity * res.item_price)
					report_text += (str("\n", sale, ": ", requested_report[sale], " - $", (quantity * res.item_price))).pad_decimals(2)
		elif sale == "Customer Count":
			count = requested_report[sale]
			
	report_text += (str("\n \n Total Sales: $", sales_total)).pad_decimals(2)
	report_text += (str("\n Customer Count: ", count))
	label.text = str(report_text)


func _on_button_pressed() -> void:
	hide()
	main_menu.emit()
	for each in grid_container.get_children():
		each.queue_free()


func load_reports():
	var dir_access = DirAccess.open("user://")
	var files = dir_access.get_files()
	for f in files:
		add_button(f)


func sort_report(requested_report):
	var file = FileAccess.open(str("user://", requested_report),FileAccess.READ)
	var report = file.get_var()
	file.close()
	var report_values = report.values() as Array
	report_values.sort()
	var sorted_report = {}
	for rv in report_values:
		for r in report:
			if rv == report[r]:
				sorted_report[r] = rv
	print_report(sorted_report)
