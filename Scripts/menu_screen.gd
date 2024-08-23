extends Control

signal open_register

func _ready():
	show()
	
	
func _on_register_button_press():
	hide()
	open_register.emit()
	
func _on_reports_button_press():
	pass
	
	
func _on_manage_button_press():
	pass
	

func _on_quit_button_press():
	get_tree().quit()
