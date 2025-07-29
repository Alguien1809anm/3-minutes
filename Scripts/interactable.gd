extends Area2D

@export var interaction_name: String = "Object"
@export var interaction_distance: float = 32.0
@export var required_item: String = ""  # 🔑 Required item to interact (optional)
@export var consume_required_item: bool = false  # 🗑️ Remove item after use
@export var target_node_path: NodePath
@export var method_name: String = ""
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var collision_shape : CollisionShape2D

signal interacted(callback: Callable)

func _ready() -> void:
	if collision_shape != null:
		collision_shape.disabled = false
	
	$Label.text = interaction_name
	$Label.visible = false
	input_pickable = true

func _mouse_enter() -> void:
	$Label.visible = true

func _mouse_exit() -> void:
	$Label.visible = false

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_node("/root/Game/Player")
		var approach_position = global_position + Vector2(0, interaction_distance)
		player.move_to(approach_position, func():
			_check_and_interact()
		)

func _check_and_interact() -> void:
	var game = get_node("/root/Game")
	if required_item == "" or game.has_item(required_item):
		if required_item != "" and consume_required_item:
			game.remove_item(required_item)
		interact()
	else:
		game.show_message("❌" + required_item + " is needed")

func interact() -> void:
	var node = get_node_or_null(target_node_path)
	if node and method_name != "" and node.has_method(method_name):
		node.call(method_name)
	else:
		print("✅ Interacted with:", interaction_name)

func open_door():
	collision_shape.disabled = true
	animation_player.play("open_door")

func use_emergency_number_item():
	var game = get_node("/root/Game")
	LoopManager.remember("Emergency Number", "333893133")
	Dialogic.start("LearnEmergencyNumber")
func guiri_ending():
	var next_scene_path: String = "res://Scenes/balconing_simulator_ending_scene.tscn"  # Scene to load when interacted

	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("✅ Interacted with:", interaction_name)
