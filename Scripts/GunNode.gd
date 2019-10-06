extends "res://Scripts/SpaceNode.gd"

onready var current_charge = 0.0;
onready var MAXIMUM_CHARGE = 100;
onready var SECONDS_TO_FULL_CHARGE = 8;

func _ready():
    energyCost = 50 #TODO adjust later

func _draw():
    for node in adjacentNodes:
        #to_local() needed because _draw() is relative to this node's position
        draw_line(to_local($Sprite.global_position), to_local(node.get_node("Sprite").global_position), Color.red, 2)
    if isSelected:
        draw_rect(Rect2(-16, -16, 32, 32), Color.green, false)
        #draw_circle(Vector2(0, 0), NODE_RADIUS, Color.green)

func _process(delta):
    update()

func isPositionValid(pos):
    var dist : int = global_position.distance_to(pos)
    if MOUSE_RADIUS * 2 < dist and dist < NODE_RADIUS and !nodeSystem.isMouseOverlappingNode():
        return true
    else:
        return false
        
