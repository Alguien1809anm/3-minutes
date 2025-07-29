extends Node

@export var loop_duration: float = 180.0 # 3 minutes
var remaining_time: float = 0.0
var memory := {}  # Stores what the player learns between loops
var diddy_time_v = false

signal loop_restarted  # You can connect this to other nodes that need to reset
signal diddy_time

@onready var loop_timer_label: Label = $"../Player/Camera2D/UI/LoopTimer"
  # Update if needed

func _ready():
	start_loop()

func start_loop():
	remaining_time = loop_duration
	
	_update_timer_label()
	print("🔁 Loop started.")
	emit_signal("loop_restarted")

func _process(delta):
	remaining_time -= delta
	_update_timer_label()
	if remaining_time <= 0:
		_restart_loop()
	if remaining_time <= 60 and diddy_time_v == false:
		diddy_time_v = true
		emit_signal("diddy_time")

func _restart_loop():
	print("🌀 Loop ended. Restarting...")
	start_loop()

func _update_timer_label():
	if loop_timer_label:
		var minutes = int(remaining_time) / 60
		var seconds = int(remaining_time) % 60
		loop_timer_label.text = "Time Left: %02d:%02d" % [minutes, seconds]

# 📚 Save what the player learned
func remember(key: String, value):
	memory[key] = value

# 🔍 Check what was remembered
func knows(key: String) -> bool:
	return memory.has(key) and memory[key]
	
func _on_diddy_time() -> void:
	Dialogic.start("diddy_time")
