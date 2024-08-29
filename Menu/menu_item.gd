extends Resource

class_name MenuItem


enum ITEM_TYPE {
	Drink,
	Food,
	Candy
	}
	
@export var item_name: String
@export var item_price: float
@export var item_image: Texture2D
@export var item_type: ITEM_TYPE
