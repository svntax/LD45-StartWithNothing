extends Area2D

# Original source: https://github.com/mlokogrgel1/Worm_

# To create custom worm segments, create new scene, make the root an Area2D, and inherit this script

onready var j1 : Vector2 = Vector2() # This joint
onready var j2 : Vector2 = Vector2() # Adjacent joint

onready var base = 40

# Moves and rotates towards adjacent joint
func move(vel) -> void:
    var rot = (j1 - j2).angle()
    position = j1 + (j2 - j1) / 2
    rotation = rot
    j1 += vel.rotated(rot)
    j2 += Vector2(vel.x + base - sqrt(base * base - vel.y * vel.y), 0).rotated(rot)

func set_distance_between_joints(dist) -> void:
    base = dist