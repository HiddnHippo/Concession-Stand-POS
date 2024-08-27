extends Control

@onready var label = $ColorRect/ScrollContainer/Label

var report_text: String = ""

signal main_menu

func print_report():
	report_text = ""
	var file = FileAccess.open(str("user://", Time.get_date_string_from_system(), "-report.dat"),FileAccess.READ)
	var report = file.get_var()
	if report is Dictionary:
		for sale in report:
			report_text += (str("\n", sale, ": ", report[sale]))
	file.close()
	label.text = str(report_text)


func _on_button_pressed() -> void:
	hide()
	main_menu.emit()
