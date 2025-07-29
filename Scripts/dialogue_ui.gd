extends CanvasLayer

@onready var speaker_label: Label = $Panel/SpeakerLabel
@onready var dialogue_text: RichTextLabel = $Panel/DialogueText
@onready var next_button: Button = $Panel/NextButton
@onready var options_container: VBoxContainer = $Panel/OptionsContainer

var dialogue_data: Array = []
var current_index := 0
var on_finish: Callable = func(): pass

func show_dialogue(pages: Array, finish_callback: Callable = func(): pass) -> void:
	dialogue_data = pages
	current_index = 0
	on_finish = finish_callback
	visible = true
	_next_page()

func _next_page() -> void:
	options_container.hide()
	for child in options_container.get_children():
		child.queue_free()


	if current_index >= dialogue_data.size():
		close_dialogue()
		return

	var page = dialogue_data[current_index]
	speaker_label.text = page.get("speaker", "")
	dialogue_text.text = page.get("text", "")

	var responses = page.get("responses", [])
	if responses.size() > 0:
		options_container.show()
		for response in responses:
			var btn := Button.new()
			btn.text = response.get("text", "Respuesta")
			btn.pressed.connect(response.get("callback", func(): pass))
			btn.pressed.connect(_on_response_selected)
			options_container.add_child(btn)
		next_button.hide()
	else:
		next_button.show()

	current_index += 1

func _on_NextButton_pressed():
	_next_page()

func _on_response_selected():
	close_dialogue()

func close_dialogue():
	visible = false
	options_container.queue_free_children()
	on_finish.call()
