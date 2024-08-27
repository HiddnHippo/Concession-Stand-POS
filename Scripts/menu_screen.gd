extends Control

signal open_register
signal open_reports


var file_path: String = str("user://", Time.get_date_string_from_system(), "-report.dat")
var previous_text: String = ""

func _ready():
	show()
	
	
func _on_register_button_press():
	hide()
	open_register.emit()
	
func _on_reports_button_press():
	hide()
	open_reports.emit()
	
	
func _on_manage_button_press():
	pass
	
	
func _on_quit_button_press():
	get_tree().quit()
	
	
func save_reports(report, total, count):
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
		print(previous_report)
	else:
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		file.store_var(report)
		file.close()
	report = {}
