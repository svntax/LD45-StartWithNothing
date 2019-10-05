extends Node2D

var animatedStar = load("res://Scenes/BackgroundStar.tscn")

onready var stars : Array = []

func _ready():
    for i in range(1000):
        var x = randi() % 1000
        var y = randi() % 1000
        if randf() < 0.2:
            var twinklingStar = animatedStar.instance()
            add_child(twinklingStar)
            twinklingStar.global_position = Vector2(x, y)
            twinklingStar.get_node("AnimationPlayer").seek(randf())
        else:
            var star = {}
            star.x = x
            star.y = y
            star.size = randi() % 2 + 1
            stars.append(star)

func _draw():
    for star in stars:
        draw_rect(Rect2(star.x, star.y, star.size, star.size), Color.white)

func _process(delta):
    update()