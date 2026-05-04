extends Control

var item = {
	"Sword": {
		"StoneSword": {
			"Name": "Stone Sword",
			"Cost" : 5,
			"Stats": 10,
			"Crafting": {
				"Stone": 10,
				"Wood": 10,
			}
		}
	},
	"Armor": {
		"StoneArmor": {
			"Name": "Stone Armor",
			"Cost": 10,
			"Stats": 15,
			"Crafting": {
				"Stone": 15,
				"Leather": 20
			}
		}
	}
}

var player_inventory = {
	"Wood": 0,
	"Stone": 0,
	"Leather": 0
}

var item_selected: String

func _ready() -> void:
	get_player_data()
	bind_button()


func bind_button() -> void:
	for child in $PlayerInven/ColorRect/VBoxContainer.get_children():
		if child is Button and child.name.begins_with("Add"):
			child.pressed.connect(set_player_inventory.bind(child.name.trim_prefix("Add"), 10))


func get_player_data() -> void:
	var label_text: String
	for key in player_inventory.keys():
		label_text += str(key) + " = " + str(player_inventory[key]) + "\n"
	
	$PlayerInven/ColorRect/InventoryLabel.text = label_text
	

func set_player_inventory(material_name: String, value: int):
	player_inventory[material_name] += value
	get_player_data()
	

func get_item_data(item_type: String, item_name: String) -> Dictionary:
	var item_data = {}
	item_data["ItemName"] = item[item_type][item_name]["Name"]
	item_data["ItemCost"] = item[item_type][item_name]["Cost"]
	item_data["ItemStats"] = item[item_type][item_name]["Stats"]
	item_data["ItemCrafting"] = item[item_type][item_name]["Crafting"]
	return item_data

func _on_stone_sword_pressed() -> void:
	item_selected = "StoneSword"
	var stone_sword_data = get_item_data("Sword", "StoneSword")
	var label_text: String
	label_text += "Item Name = %s\n" % [stone_sword_data["ItemName"]]
	label_text += "Item Cost = %s\n" % [stone_sword_data["ItemCost"]]
	label_text += "Item Stats = %s\n" % [stone_sword_data["ItemStats"]]
	label_text += "Item Crafting Recipe: \n"
	for key in stone_sword_data["ItemCrafting"].keys():
		label_text += str(key) + " = " + str(stone_sword_data["ItemCrafting"][key]) + "\n"
	$ColorRect/CraftingSection/ColorRect/Label.text = label_text

		
func _on_stone_armor_pressed() -> void:
	item_selected = "StoneArmor"
	var stone_armor_data = get_item_data("Armor", "StoneArmor")
	var label_text: String
	label_text += "Item Name = %s\n" % [stone_armor_data["ItemName"]]
	label_text += "Item Cost = %s\n" % [stone_armor_data["ItemCost"]]
	label_text += "Item Stats = %s\n" % [stone_armor_data["ItemStats"]]
	label_text += "Item Crafting Recipe: \n"
	for key in stone_armor_data["ItemCrafting"].keys():
		label_text += str(key) + " = " + str(stone_armor_data["ItemCrafting"][key]) + "\n"
	$ColorRect/CraftingSection/ColorRect/Label.text = label_text


func _on_craft_button_pressed() -> void:
	match item_selected:
		"StoneSword":
			if player_inventory["Stone"] >= 10 and player_inventory["Wood"] >= 10:
				$CrarftingStatus.text = "Berhasil Craft Stone Sword!"
				player_inventory["Stone"] -= 10
				player_inventory["Wood"] -= 10
				
			else:
				$CrarftingStatus.text = "Bahan Tidak Cukup!!!"
	get_player_data()
