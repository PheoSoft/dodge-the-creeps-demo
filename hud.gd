# https://docs.godotengine.org/en/stable/getting_started/first_2d_game/06.heads_up_display.html#removing-old-creeps
extends CanvasLayer

signal start_game

@onready var MsgTime = "Time %s"
@onready var MsgCoins = "Coins %s"
@onready var MsgTotal = "Total %s"

func show_game_over():
	show_message("Game Over")
	show_ranking($ScoreLabel.text, $CoinLabel.text)
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	#await get_tree().create_timer(2.0).timeout
	$StartButton.show()
	$RankingButton.show()

func show_ranking(time, coins):
	#msg = msg % [str(puntos)]
	#$lblScore.text = msg
	$Summary/VBoxContainer/lblScoreTime.text = MsgTime % str(time)
	$Summary/VBoxContainer/lblScoreCoins.text = MsgCoins % (coins)
	$Summary/VBoxContainer/lblScoreTotal.text = MsgTotal % str(int(time) + int(coins))
	$Summary.visible = true

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_coins(coins):
	$CoinLabel.text = str(coins)

func _on_start_button_pressed():
	$StartButton.hide()
	$RankingButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#show_ranking(24,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ranking_button_pressed():
	get_tree().change_scene_to_file("res://ranking_screen.tscn")
