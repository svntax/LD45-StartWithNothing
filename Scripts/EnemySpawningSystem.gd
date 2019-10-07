extends Node2D

signal wave_complete
signal wave_start

var crashingEnemyScene = load("res://Scenes/CrashingEnemySpawn.tscn")

onready var spawnTimer = $SpawnTimer
onready var spawnPoints = $SpawnPoints

onready var currentWave = 1
onready var spawnCount = 0

onready var isActive = true

func startSpawningEnemies():
    if isActive:
        emit_signal("wave_start", currentWave)
        spawnTimer.start()
        spawnCount = 0
        currentWave += 1

func _on_SpawnTimer_timeout():
    if not isActive:
        return

    var enemy = crashingEnemyScene.instance()
    add_child(enemy)
    
    #Pick random spawn point
    var i = randi() % spawnPoints.get_child_count()
    enemy.global_position = spawnPoints.get_child(i).global_position
    enemy.set_number_of_segments(floor(rand_range(currentWave-1, currentWave + 3)))
    enemy.init_segments()
    
    spawnTimer.wait_time = floor(rand_range(3, 6))
    
    spawnCount += 1
    # Hard-coded, number of enemies per wave is 2*wave + 5
    if spawnCount >= 5 + ((currentWave - 1) * 2):
        spawnTimer.stop()
        $InitialDelayTimer.start()

func _on_InitialDelayTimer_timeout():
    if isActive:
        startSpawningEnemies()

func stopSpawningEnemies():
    isActive = false
    spawnTimer.stop()
    $InitialDelayTimer.stop()
    # -1 because when current wave starts, currentWave var is immediately incremented
    Globals.updateHighScore(currentWave - 1)