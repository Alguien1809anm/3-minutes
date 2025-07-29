extends Area2D

@export var container_name: String = "Caja"
@export var interaction_distance: float = 32.0
@export var contents: Array[String] = ["Llave", "Linterna", "Foto antigua"]

@onready var label = $Label
@onready var ui_panel = $Panel
@onready var vbox = $Panel/VBoxContainer
@onready var player = get_node("/root/Game/Player")

func _ready():
	label.text = container_name
	label.visible = false  # Oculto por defecto
	ui_panel.visible = false
	input_pickable = true

func _on_mouse_enter():
	label.visible = true

func _on_mouse_exit():
	label.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var approach_position = global_position + Vector2(0, interaction_distance)
		player.move_to(approach_position, func():
			open_inventory()
		)

func open_inventory():
	ui_panel.visible = true
	for child in vbox.get_children():
		child.queue_free()

	for item_name in contents:
		var button = Button.new()
		button.text = item_name
		button.pressed.connect(func():
			if InventoryManager.add_item(item_name):
				contents.erase(item_name)
				button.queue_free()
		)
		vbox.add_child(button)

	var close_button = Button.new()
	close_button.text = "Cerrar"
	close_button.pressed.connect(func():
		ui_panel.visible = false
	)
	vbox.add_child(close_button)
