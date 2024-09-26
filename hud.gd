extends CanvasLayer

signal start_game

func _ready() -> void:
	$Score_widget.hide()
	$contact_info.hide()

func _process(_delta) -> void:
	pass

func update_score(credits, capacity):
	$Score_widget/Credits.text = str(credits)
	$Score_widget/Capacity.text = str(capacity)

func update_ui_messages(contact_name, contact_message):
	$contact_info/contact_name.text = str(contact_name)
	$contact_info/contact_message.text = str(contact_message)
	
func _on_start_button_pressed():
	$StartButton.hide()
	$title.hide()
	$ScannerOverlay.show()
	$Score_widget.show()
	$contact_info.show()
	$Score_widget/Credits.text = str(0)
	$Score_widget/Capacity.text = str(1000)
	start_game.emit()

func _on_main_gameover() -> void:
	$StartButton.show()
	$Score_widget/Capacity.text = str(0)
	$contact_info/contact_name.text = str("")
	$contact_info/contact_message.text = str("")


func _on_cursor_isolated_contact(category, type) -> void:
	update_ui_messages(category, type)
