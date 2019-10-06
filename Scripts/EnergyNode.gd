extends "res://Scripts/SpaceNode.gd"

onready var current_charge = 0.0;
onready var MAXIMUM_CHARGE = 100;
onready var SECONDS_TO_FULL_CHARGE = 8;
onready var energyBar = $EnergyUI/EnergyBar
onready var spriteOutline = $Sprite/SpriteOutline

func _ready():
    energyCost = 50 #TODO adjust later
    energyBar.set_value(0)

func _draw():
    for node in adjacentNodes:
        #to_local() needed because _draw() is relative to this node's position
        draw_line(to_local($Sprite.global_position), to_local(node.get_node("Sprite").global_position), LINE_COLOR, 2)
    if isSelected:
        #draw_rect(Rect2(-16, -16, 32, 32), Color.green, false)
        #draw_circle(Vector2(0, 0), NODE_RADIUS, Color.green)
        draw_circle_arc(Vector2(0, 0), NODE_RADIUS, 0, 360, Color("ead4aa"))

func _process(delta):
    update()
    energyBar.set_value(energyBar.value + delta * energyBar.max_value / SECONDS_TO_FULL_CHARGE)
    
    if isSelected and not spriteOutline.visible:
        spriteOutline.show()
    elif !isSelected and spriteOutline.visible:
        spriteOutline.hide()

func showEnergyWarning():
    SoundHandler.energyWarningSound.play()
    $TextAnimation.play("energy_warning")

func hideEnergyWarning():
    $TextAnimation.stop()
    $TextUI/Warning.hide()