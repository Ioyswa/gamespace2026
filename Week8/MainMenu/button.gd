extends Control

@onready var start_button: TextureButton = $StartButton
@onready var setting_button: TextureButton = $SettingButton
@onready var exit_button: TextureButton = $ExitButton

# Pengaturan parameter animasi (Silakan ubah angka ini jika efeknya kurang terasa)
var ukuran_normal: Vector2 = Vector2(1.0, 1.0)
var ukuran_hover: Vector2 = Vector2(1.05, 1.05) # Membesar 5%
var ukuran_klik: Vector2 = Vector2(0.95, 0.95)  # Mengecil (squish) saat ditekan

var warna_normal: Color = Color(1.0, 1.0, 1.0, 1.0)
var warna_hover: Color = Color(1.1, 1.1, 1.1, 1.0)
var warna_klik: Color = Color(0.8, 0.8, 0.8, 1.0) 

func _ready() -> void:
	_tambahkan_efek_juice(start_button)
	_tambahkan_efek_juice(setting_button)
	_tambahkan_efek_juice(exit_button)

# Fungsi bantuan untuk menyambungkan semua sinyal otomatis ke satu tombol
func _tambahkan_efek_juice(btn: TextureButton) -> void:
	if not btn: return
	
	btn.pivot_offset = btn.size / 2.0
	
	btn.mouse_entered.connect(_animasi_hover.bind(btn))
	btn.mouse_exited.connect(_animasi_normal.bind(btn))
	btn.button_down.connect(_animasi_klik.bind(btn))
	btn.button_up.connect(_animasi_hover.bind(btn))


func _animasi_hover(btn: TextureButton) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", ukuran_hover, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(btn, "modulate", warna_hover, 0.1)

func _animasi_normal(btn: TextureButton) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", ukuran_normal, 0.15).set_trans(Tween.TRANS_SINE)
	tween.tween_property(btn, "modulate", warna_normal, 0.15)

func _animasi_klik(btn: TextureButton) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", ukuran_klik, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(btn, "modulate", warna_klik, 0.05)
