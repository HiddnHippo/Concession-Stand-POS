extends Node


@onready var register_screen: Control = $RegisterScreen
@onready var menu_screen: Control = $MenuScreen
@onready var after_screen: Control = $AfterScreen
@onready var reports_screen: Control = $ReportsScreen
@onready var management_screen: Control = $ManagementScreen
@onready var password_panel: Control = $PasswordPanel

var sales_total : float = 0.0
var customer_count: int

func _ready():
	menu_screen.open_register.connect(_on_open_register_screen)
	menu_screen.open_reports.connect(_on_open_reports_screen)
	menu_screen.open_management.connect(_on_open_management_screen)
	
	register_screen.main_menu.connect(_on_open_main_menu)
	register_screen.insufficient_funds.connect(_on_insufficient_funds)
	register_screen.return_change.connect(_on_return_change)
	register_screen.thank_you.connect(_on_thank_you)
	register_screen.save_sales_report.connect(save_reports)
	register_screen.add_to_customer_total.connect(add_customer)
	
	reports_screen.main_menu.connect(_on_open_main_menu)

	management_screen.main_menu.connect(_on_open_main_menu)
	
	password_panel.main_menu.connect(_on_open_main_menu)
	
func _on_open_main_menu():
	menu_screen.show()
	
	
func _on_open_register_screen():
	register_screen.show()
	
	
func _on_insufficient_funds():
	after_screen.set_after_screen("Not enough money")
	
	
func _on_return_change(amt):
	after_screen.set_after_screen(str("Your change is: ", amt).pad_decimals(2))
	
	
func _on_thank_you():
	after_screen.set_after_screen("Thank you!")

	
func _on_open_reports_screen():
	password_panel.ask_for_password()
	reports_screen.open_screen()
	
	
func _on_open_management_screen():
	password_panel.ask_for_password()
	management_screen.open_screen()
	

func save_reports(sales_report):
	menu_screen.save_reports(sales_report)


func add_customer():
	menu_screen.add_customer()
