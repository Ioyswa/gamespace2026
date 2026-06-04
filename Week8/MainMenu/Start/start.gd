extends Control

# Referensi Node berdasarkan gambar hierarki Anda
@onready var start_button: TextureButton = $Background/StartButton
@onready var back_button: TextureButton = $Background/HBoxContainer/BackButton
@onready var next_button: TextureButton = $Background/HBoxContainer/NextButton

@onready var hold_progress: TextureProgressBar = $Background/StartButton/StartProgress

@onready var level_background: TextureRect = $Background/LevelBackground

# --- VARIABEL TOGGLE MENU ---
var is_menu_open: bool = false
var pos_terbuka: Vector2
var pos_tertutup: Vector2

# --- VARIABEL HOLD TO START ---
var hold_tween: Tween
var waktu_hold: float = 1.0 # Waktu yang dibutuhkan untuk menahan tombol (dalam detik)

var pos_awal_bg: Vector2

var level: bool = false

func _ready() -> void:
	pos_terbuka = position
	pos_tertutup = Vector2(position.x, position.y - 1000)
	
	position = pos_tertutup
	
	_button_animation(back_button)
	_button_animation(next_button)
	
	start_button.pivot_offset = start_button.size / 2.0
	start_button.button_down.connect(_on_start_button_down)
	start_button.button_up.connect(_on_start_button_up)
	
	if hold_progress:
		hold_progress.value = hold_progress.min_value
		
	if level_background:
		pos_awal_bg = level_background.position


func _on_start_button_pressed() -> void:
	is_menu_open = !is_menu_open
	
	var tween = create_tween()
	
	if is_menu_open:
		# Buka: Dari atas ke tengah
		# TRANS_BACK memberikan efek memantul (overshoot) sedikit saat menu tiba di tengah
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", pos_terbuka, 0.5)
	else:
		# Tutup: Dari tengah ke atas
		# TRANS_CUBIC memberikan pergerakan yang mulus saat keluar layar
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(self, "position", pos_tertutup, 0.4)


# ==========================================
# 2. LOGIKA JUICE NEXT & BACK BUTTON
# ==========================================
func _button_animation(btn: TextureButton) -> void:
	if not btn: return
	btn.pivot_offset = btn.size / 2.0
	btn.pressed.connect(_click_animation.bind(btn))

func _click_animation(btn: TextureButton) -> void:
	# Efek memantul (squish & stretch) yang sangat cepat agar terasa responsif
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(0.8, 0.8), 0.05)
	tween.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	
	# Panggil animasi background berdasarkan tombol mana yang ditekan
	if btn == next_button:
		_animasi_ganti_background(1)  # 1 berarti arah maju (Next)
		level = true
	elif btn == back_button:
		_animasi_ganti_background(-1) # -1 berarti arah mundur (Back)
		level = false
	
	# Catatan: Anda bisa menambahkan logika pergantian level atau gambar UI di sini.
	
	print(level)

func _animasi_ganti_background(arah: int) -> void:
	if not level_background: return
	
	# PENTING: Pindahkan titik tumpu gambar ke tengah agar saat memutar dan mengecil tidak miring ke sudut
	level_background.pivot_offset = level_background.size / 2.0
	
	var tween = create_tween()
	
	# --- PENGATURAN LINTASAN CONVEYOR ---
	# Jarak pergeseran ke samping (X)
	var jarak_geser = 150.0 * arah 
	# Seberapa tinggi gambar naik ke atas layar saat diputar (Y)
	var tinggi_putaran = 120.0 
	# Derajat kemiringan kartu saat berputar (menggunakan arah agar miringnya dinamis)
	var derajat_miring = 15.0 * arah 
	
	# 1. Animasi Keluar: Gambar bergeser berlawanan arah, NAIK ke atas, miring, mengecil (menjauh), dan memudar
	tween.set_parallel(true)
	tween.tween_property(level_background, "position:x", pos_awal_bg.x - jarak_geser, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(level_background, "position:y", pos_awal_bg.y - tinggi_putaran, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(level_background, "rotation", deg_to_rad(-derajat_miring), 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(level_background, "scale", Vector2(0.6, 0.6), 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(level_background, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_LINEAR)
	
	# 2. Eksekusi kode saat gambar sedang tidak terlihat (Alpha 0)
	tween.chain().tween_callback(func():
		# Pindahkan posisi gambar ke sisi sebaliknya, posisikan tetap di atas dan dalam keadaan mengecil serta miring
		level_background.position.x = pos_awal_bg.x + jarak_geser
		level_background.position.y = pos_awal_bg.y - tinggi_putaran
		level_background.rotation = deg_to_rad(derajat_miring)
		level_background.scale = Vector2(0.6, 0.6)
		
		$Background/LevelBackground/LevelImage.texture = load("res://Assets/MainMenu/Start/Background/TestBG_" + str(int(level)) + ".png")
	)
	
	# 3. Animasi Masuk: Gambar TURUN kembali ke tengah, membesar, tegak lurus kembali, dan muncul
	var tween_masuk = tween.chain().set_parallel(true)
	# Menggunakan TRANS_BACK untuk X, Y, Rotasi, dan Skala agar ada efek memantul/mengunci (snap into place) saat tiba di tengah
	tween_masuk.tween_property(level_background, "position:x", pos_awal_bg.x, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_masuk.tween_property(level_background, "position:y", pos_awal_bg.y, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_masuk.tween_property(level_background, "rotation", 0.0, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_masuk.tween_property(level_background, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_masuk.tween_property(level_background, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_LINEAR)

func _on_start_button_down() -> void:
	if hold_tween and hold_tween.is_valid():
		hold_tween.kill()
		
	hold_tween = create_tween().set_parallel(true)
	
	# Animasi mengecil dan menggelap pada tombol
	hold_tween.tween_property(start_button, "scale", Vector2(0.85, 0.85), waktu_hold).set_trans(Tween.TRANS_LINEAR)
	hold_tween.tween_property(start_button, "modulate", Color(0.5, 0.5, 0.5, 1.0), waktu_hold).set_trans(Tween.TRANS_LINEAR)
	
	# Animasi mengisi TextureProgressBar dari nilai saat ini hingga max_value
	if hold_progress:
		hold_tween.tween_property(hold_progress, "value", hold_progress.max_value, waktu_hold).set_trans(Tween.TRANS_LINEAR)
	
	# Setelah animasi selesai, panggil fungsi mulai
	hold_tween.chain().tween_callback(_mulai_level)


func _on_start_button_up() -> void:
	if hold_tween and hold_tween.is_valid():
		hold_tween.kill() 
		
	var reset_tween = create_tween().set_parallel(true)
	
	# Animasi tombol kembali ke ukuran dan warna normal dengan efek memantul (ELASTIC)
	reset_tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	reset_tween.tween_property(start_button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Animasi mengosongkan TextureProgressBar dengan cepat (0.2 detik)
	# Catatan: Kita secara spesifik menggunakan TRANS_LINEAR di sini agar nilai progress bar tidak ikut memantul hingga ke nilai minus
	if hold_progress:
		reset_tween.tween_property(hold_progress, "value", hold_progress.min_value, 0.2).set_trans(Tween.TRANS_LINEAR)

func _mulai_level() -> void:
	get_tree().change_scene_to_file("res://Scene/world.tscn")
