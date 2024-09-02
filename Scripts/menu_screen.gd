extends Control

signal open_register
signal open_reports
signal open_management

var resource_path = "res://Menu/MenuItems/"
var file_path: String = str("user://", Time.get_date_string_from_system(), "-report.dat")


func _ready():
	show()
	
	
func _on_register_button_press():
	open_register.emit()
	
	
func _on_reports_button_press():
	open_reports.emit()
	
	
func _on_manage_button_press():
	open_management.emit()
	
	
func _on_quit_button_press():
	get_tree().quit()
	
	
func save_reports(report):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var previous_report = file.get_var()
		if previous_report is Dictionary:
			for item in report:
				if previous_report.has(item):
					var previous_quantity = previous_report[item]
					var quantity_to_add = report[item]
					previous_report[item] = previous_quantity + quantity_to_add
				else:
					previous_report.merge(report)
					
		file = FileAccess.open(file_path, FileAccess.WRITE)
		file.store_var(previous_report)
		file.close()
	else:
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		file.store_var(report)
		file.close()
		print(report)
	report = {}


func add_customer():
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var previous_report = file.get_var()
		if previous_report is Dictionary:
			for item in previous_report:
				if item == "Customer Count":
					previous_report[item] += 1
					file = FileAccess.open(file_path, FileAccess.WRITE)
					file.store_var(previous_report)
					file.close()
	else:
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		var starting_dictionary = {"Customer Count": 1}
		file.store_var(starting_dictionary)
		file.close()
