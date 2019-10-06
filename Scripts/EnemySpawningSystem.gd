extends Node2D

var crashingEnemyScene = load("res://Scenes/CrashingEnemySpawn.tscn")

onready var spawnTimer = $SpawnTimer
onready var spawnPoints = $SpawnPoints

func startSpawningEnemies():
    spawnTimer.start()

func _on_SpawnTimer_timeout():
    var enemy = crashingEnemyScene.instance()
    add_child(enemy)
    
    #Pick random spawn point
    var i = randi() % spawnPoints.get_child_count()
    enemy.global_position = spawnPoints.get_child(i).global_position
    enemy.set_number_of_segments(floor(rand_range(1, 6)))
    enemy.init_segments()
    
    spawnTimer.wait_time = floor(rand_range(4, 7))

func _on_InitialDelayTimer_timeout():
    startSpawningEnemies()
