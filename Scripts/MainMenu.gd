extends Node2D

onready var highScoreText = $ScoreContainer/HighScore

func _ready():
    SoundHandler.titleMusic.play()
    if Globals.highScore > 0:
        highScoreText.set_text("Highest wave reached: Wave " + str(Globals.highScore))
    else:
        highScoreText.hide()

func _on_StartButton_pressed():
    SoundHandler.titleMusic.stop()
    get_tree().change_scene("res://Scenes/Gameplay.tscn")

func _on_QuitButton_pressed():
    get_tree().quit()