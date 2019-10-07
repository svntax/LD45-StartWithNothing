extends Node

onready var highScore = 0

func updateHighScore(newScore):
    if highScore < newScore:
        highScore = newScore