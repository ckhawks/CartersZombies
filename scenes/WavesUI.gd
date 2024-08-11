extends Control

@export var playerForIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("waveStarted", on_change_wave)
	SignalBus.connect("waveStarting", on_wave_starting)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_wave_starting(waveNumber: int) -> void:
	%WaveLabel.text = str(waveNumber)
	$AnimationPlayer.play("wavestarting")

func on_change_wave(waveNumber: int) -> void:
	%WaveLabel.text = str(waveNumber)
