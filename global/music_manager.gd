extends Node

@onready var _player: AudioStreamPlayer = AudioStreamPlayer.new()
var _current_stream: AudioStream

func _ready() -> void:
	_player.bus = "BGM"
	add_child(_player)
	
func play(stream: AudioStream, loop := true) -> void:
	if stream == _current_stream and _player.playing:
		return # already playing, do not restart track
	_current_stream = stream
	if "loop" in stream:
		stream.loop = loop
	_player.stream = stream
	_player.play()
	
func stop() -> void:
	_player.stop()
	_current_stream = null
