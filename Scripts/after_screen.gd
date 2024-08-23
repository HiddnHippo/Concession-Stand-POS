extends Control

@onready var after_screen_label: Label = $HBoxContainer/VBoxContainer/Button/AfterScreenLabel


func _ready():
	hide()
	
	
func set_after_screen(_text: String):
	show()
	after_screen_label.text = _text
	
	
func _on_after_screen_pressed():
	set_after_screen("")
	hide()
