extends Node

signal volumes_changed(music_volume: float, sfx_volume: float)

const SETTINGS_PATH := "user://audio_settings.json"
const BGM_PATH := "res://resources/music/Meadow Quest(happy).mp3"
const CLICK_SFX_PATH := "res://resources/music/click.wav"
const COLLECT_SFX_PATH := "res://resources/music/collect.wav"

var music_volume: float = 70.0
var sfx_volume: float = 80.0

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer
var _click_stream: AudioStream
var _collect_stream: AudioStream


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_settings()
	_setup_players()
	_apply_volumes()


func start_bgm() -> void:
	if _music_player == null or _music_player.stream == null:
		return
	if not _music_player.playing:
		_music_player.play()


func stop_bgm() -> void:
	if _music_player != null:
		_music_player.stop()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 100.0)
	_apply_volumes()
	_save_settings()
	volumes_changed.emit(music_volume, sfx_volume)


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 100.0)
	_apply_volumes()
	_save_settings()
	volumes_changed.emit(music_volume, sfx_volume)


func play_click() -> void:
	_play_sfx(_click_stream)


func play_collect() -> void:
	_play_sfx(_collect_stream)


func _setup_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_music_player.stream = _load_audio_stream(BGM_PATH)
	if _music_player.stream is AudioStreamMP3:
		(_music_player.stream as AudioStreamMP3).loop = true
	add_child(_music_player)

	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.name = "SfxPlayer"
	_sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_sfx_player)

	_click_stream = _load_audio_stream(CLICK_SFX_PATH)
	_collect_stream = _load_audio_stream(COLLECT_SFX_PATH)


func _play_sfx(stream: AudioStream) -> void:
	if _sfx_player == null or stream == null:
		return
	_sfx_player.stream = stream
	_sfx_player.play()


func _load_audio_stream(path: String) -> AudioStream:
	var stream: AudioStream = load(path)
	if stream != null:
		return stream
	if path.get_extension().to_lower() == "wav":
		return AudioStreamWAV.load_from_file(path)
	return null


func _apply_volumes() -> void:
	if _music_player != null:
		_music_player.volume_db = _volume_to_db(music_volume)
	if _sfx_player != null:
		_sfx_player.volume_db = _volume_to_db(sfx_volume)


func _volume_to_db(value: float) -> float:
	var linear := clampf(value / 100.0, 0.0, 1.0)
	if linear <= 0.0:
		return -80.0
	return linear_to_db(linear)


func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		return

	var data := parsed as Dictionary
	music_volume = clampf(float(data.get("music_volume", music_volume)), 0.0, 100.0)
	sfx_volume = clampf(float(data.get("sfx_volume", sfx_volume)), 0.0, 100.0)


func _save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save audio settings.")
		return

	var data := {"music_volume": music_volume, "sfx_volume": sfx_volume}
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
