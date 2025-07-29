extends CanvasLayer

@onready var line_edit := $Panel/LineEdit
@onready var call_button := $Panel/HBoxContainer/Button
@onready var close_button := $Panel/HBoxContainer/Button2
@onready var number_label := $Panel/NumberLabel  # A Label under the Panel
@onready var game := get_node("/root/Game")


signal number_called(number: String)

func _ready():
	visible = false
	call_button.pressed.connect(_on_call_pressed)

func open():
	visible = true
	line_edit.placeholder_text = "Enter Phone Number"
	line_edit.text = ""

	if LoopManager.knows("Emergency Number"):
		number_label.text = "Emergency Number: 333893133"
	else:
		number_label.text = ""
	

func close():
	visible = false

func _on_call_pressed():
	var number = line_edit.text.strip_edges()
	var numbers = "0123456789"
	var cum : bool = false
	if number.length() != 9:
		Dialogic.start("NumberNotCorrect")
	else:
		for num in number:
			if num not in numbers:
				cum = true
		if cum == true:
			Dialogic.start("NumberNotCorrect")
		else:
			if number == "333893133":
				if LoopManager.knows("Emergency Number"):
					close()
					Dialogic.start("Llamada Alonso")
				else: 
					Dialogic.start("NoLlamarDesconocidos")
			else:
				Dialogic.start("NoLlamarDesconocidos")


@onready var phone_ui = get_node("/root/Game/PhoneUI")
