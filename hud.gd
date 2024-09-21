extends CanvasLayer

signal start_game

func _ready() -> void:
	$ScannerOverlay.hide()
	pass # Replace with function body.

func _process(_delta) -> void:
	pass

func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_start_button_pressed():
	$StartButton.hide()
	$ScannerOverlay.show()
	start_game.emit()

func _on_main_gameover() -> void:
	$StartButton.show()
	$ScannerOverlay.hide()
	$ScoreLabel.text = str(0)
