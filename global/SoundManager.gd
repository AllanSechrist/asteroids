extends Node

var _player: AudioStreamPlayer

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.bus = "SFX"
	var poly := AudioStreamPolyphonic.new()
	poly.polyphony = 32
	_player.stream = poly
	add_child(_player)
	_player.play()
	
func play(stream: AudioStream, volume_db := 0.0, pitch_scale := 1.0) -> void:
	if stream:
		var playback: AudioStreamPlaybackPolyphonic = _player.get_stream_playback()
		playback.play_stream(stream, 0.0, volume_db, pitch_scale)
