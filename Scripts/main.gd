extends Node2D

@onready var player = $Player
@onready var animation_player: AnimationPlayer = $Interactable/AnimationPlayer
var known_numbers: Array[String] = []


func _ready():
	var slot1 = $Player/Camera2D/UI/Hotbar/Slot0
	var slot2 = $Player/Camera2D/UI/Hotbar/Slot1
	var slot3 = $Player/Camera2D/UI/Hotbar/Slot2

	InventoryManager.hotbar_slots = [slot1, slot2, slot3]

	for i in range(InventoryManager.hotbar_slots.size()):
		var button = InventoryManager.hotbar_slots[i]
		if button != null:
			button.pressed.connect(_on_hotbar_button_pressed.bind(i))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var click_position = get_global_mouse_position()
		player.move_to(click_position)
		
func _on_hotbar_button_pressed(slot_index: int):
	if slot_index < InventoryManager.items.size():
		var item_name = InventoryManager.items[slot_index]
		print("🧪 Usaste el objeto:", item_name)
		# Aquí puedes ejecutar una acción, por ejemplo:
		# - Consumir el objeto
		# - Mostrar una descripción
		# - Usarlo sobre algo en el mundo
func has_item(item_name: String) -> bool:
	return item_name in InventoryManager.items
	
func show_message(text: String) -> void:
	var label = get_node_or_null("Player/Camera2D/UI/MessageLabel")
	if label:
		label.text = text
		label.show()
		await get_tree().create_timer(2.0).timeout
		label.hide()
	else:
		print("📭 No se encontró MessageLabel")
func remove_item(item_name: String) -> void:
	if item_name in InventoryManager.items:
		InventoryManager.items.erase(item_name)
		InventoryManager.update_hotbar()
		

func add_known_number(number: String):
	if number not in known_numbers:
		known_numbers.append(number)

func knows_number(number: String) -> bool:
	return number in known_numbers
	
