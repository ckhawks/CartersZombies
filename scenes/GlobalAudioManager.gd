extends Node

func _ready() -> void:
	SignalBus.waveStarting.connect(on_wave_starting)
	
func on_wave_starting(waveNumber: int) -> void:
	$WaveGraceStart1AudioPlayer.play()
	$WaveGraceStart2AudioPlayer.play()
