extends Control

@onready var label = $ColorRect/ScrollContainer/Label
@onready var grid_container: GridContainer = $ColorRect/ScrollContainer/GridContainer

var report_text: String = ""

signal main_menu


func _ready():
	label.hide()
	var dir_access = DirAccess.open("user://")
	var files = dir_access.get_files()
	for f in files:
		add_button(f)
		

func hide_text():
	label.hide()
	
	
func add_button(file):
	var b = Button.new()
	grid_container.add_child(b)
	b.text = file
	b.pressed.connect(print_report.bind(file))
	
	
	
func print_report(requested_report: String):
	label.show()
	report_text = ""
	var file = FileAccess.open(str("user://", requested_report),FileAccess.READ)
	var report = file.get_var()
	if report is Dictionary:
		for sale in report:
			report_text += (str("\n", sale, ": ", report[sale]))
	file.close()
	label.text = str(report_text)


func _on_button_pressed() -> void:
	hide()
	main_menu.emit()
