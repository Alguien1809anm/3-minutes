extends Node

var items: Array[String] = []
var hotbar_slots: Array[Button] = []
const max_slots := 3
static var full_hotbar : bool = false

func _ready():
	for i in range(max_slots):
		var slot_path = "Slot" + str(i)
		var slot = get_node_or_null(slot_path)
		if slot != null and slot is Button:
			hotbar_slots.append(slot)
		else:
			print("❌ Slot no válido o no es un botón:", slot_path)

func add_item(item_name: String) -> bool:
	if items.size() < max_slots:
		items.append(item_name)
		update_hotbar()
		return true
	else:
		print("❌ Hotbar llena.")
		return false

func update_hotbar():
	for i in range(hotbar_slots.size()):
		var slot = hotbar_slots[i]
		if i < items.size():
			slot.text = items[i]
			slot.show()
		else:
			slot.text = ""
			slot.hide()
