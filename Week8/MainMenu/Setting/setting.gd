extends Control


# Mengambil referensi node Blur yang posisinya sejajar di luar SettingContainer
@onready var blur_bg = $"../Blur"



var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("Sfx")

var is_menu_open: bool = false
var pos_tertutup: Vector2 = Vector2(-600, 144) 
var pos_terbuka: Vector2 = Vector2(0, 144)

func _ready() -> void:
	position = pos_tertutup
	if blur_bg:
		blur_bg.modulate.a = 0.0
		blur_bg.hide()
		
func _on_setting_button_pressed() -> void:
	is_menu_open = !is_menu_open
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	if is_menu_open:
		if blur_bg:
			blur_bg.show()
			tween.tween_property(blur_bg, "modulate:a", 1.0, 0.4)
			
		# Animasikan posisi menu ke dalam layar
		tween.tween_property(self, "position", pos_terbuka, 0.8)
	else:
		# Kembalikan posisi menu ke luar layar
		tween.tween_property(self, "position", pos_tertutup, 0.4)
		
		if blur_bg:
			tween.tween_property(blur_bg, "modulate:a", 0.0, 0.4)
			tween.chain().tween_callback(blur_bg.hide)


func _on_close_button_pressed() -> void:
	is_menu_open = !is_menu_open
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	if is_menu_open:
		if blur_bg:
			blur_bg.show()
			tween.tween_property(blur_bg, "modulate:a", 1.0, 0.4)
			
		# Animasikan posisi menu ke dalam layar
		tween.tween_property(self, "position", pos_terbuka, 0.4)
	else:
		# Kembalikan posisi menu ke luar layar
		tween.tween_property(self, "position", pos_tertutup, 0.4)
		
		if blur_bg:
			tween.tween_property(blur_bg, "modulate:a", 0.0, 0.4)
			tween.chain().tween_callback(blur_bg.hide)
