extends CanvasLayer

signal start_game

func _ready() -> void:
	$ScannerOverlay.hide()
	$Score_widget.hide()
	pass # Replace with function body.

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
	$ScannerOverlay.show()
	$Score_widget.show()
	$Score_widget/Credits.text = str(0)
	$Score_widget/Capacity.text = str(1000)
	start_game.emit()

func _on_main_gameover() -> void:
	$StartButton.show()
	$ScannerOverlay.hide()
	$Score_widget/Capacity.text = str(0)
	$contact_info/contact_name.text = str("")
	$contact_info/contact_message.text = str("")
	#$Score_widget.hide()
