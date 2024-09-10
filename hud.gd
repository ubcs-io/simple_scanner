extends CanvasLayer

signal start_game

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta) -> void:
	pass

func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_start_button_pressed():
	print('started')
	$StartButton.hide()
	start_game.emit()
