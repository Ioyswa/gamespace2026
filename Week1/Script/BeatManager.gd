# BeatManager.gd
extends Node

@export var bpm: float = 120.0
@export var audio_player: AudioStreamPlayer2D
@export var auto_start: bool = true

signal beat

var beat_interval: float
var song_position: float = 0.0
var is_playing: bool = false

func _ready():
	beat_interval = 60.0 / bpm
	
	if auto_start:
		start()
	
	
func start():
	song_position = 0.0
	is_playing = true
	
	
func stop():
	is_playing = false
	
	
func set_bpm(new_bpm: float):
	bpm = new_bpm
	beat_interval = 60.0 / bpm
	
	
func _process(delta):
	if not is_playing:
		return
	
	song_position += delta
	
	if song_position >= beat_interval:
		song_position -= beat_interval
		trigger_beat()

func trigger_beat():
	emit_signal("beat")

	if audio_player:
		audio_player.play()
		
