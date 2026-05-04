extends Control

var text_list = {
	1: "Halo",
	2: "Burger",
	3: "Nasi Padang",
	4: "Kopi",
	5: "Ayam Malay",
	6: "Es Buah"
}

var text_index: int

func _ready() -> void:
	update_text()
	$Label.text = text_list[text_index]
	$LineEdit.grab_focus()
	
func update_text() -> void:
	text_index = randi_range(text_list.keys()[0], text_list.keys()[-1])
	$LineEdit/TextOverlay.text = text_list[text_index]
	$Label.text = text_list[text_index]

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == text_list[text_index]:
		update_text() 
		$LineEdit.clear()
