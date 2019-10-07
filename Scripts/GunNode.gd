extends "res://Scripts/SpaceNode.gd"

onready var current_charge = 0.0;
onready var MAXIMUM_CHARGE = 100;
#onready var SECONDS_TO_FULL_CHARGE = 8; #UNUSED

onready var player_projectile = load("res://Scenes/PlayerProjectile.tscn")

onready var PLAYER_PROJECTILE_SPEED = 150;
onready var PLAYER_PROJECTILE_DAMAGE = 10;
onready var SHOOTING_COST = 40;

onready var spriteOutline = $Sprite/SpriteOutline

onready var COOLDOWN_TIME = 3.0;
onready var cooldownBar = $CooldownUI/CooldownBar

func _ready():
    energyCost = 50 #TODO adjust later
    cooldownBar.value = cooldownBar.max_value;


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
    if isSelected and not spriteOutline.visible:
        spriteOutline.show()
    elif !isSelected and spriteOutline.visible:
        spriteOutline.hide()
    cooldownBar.value += delta * cooldownBar.max_value / COOLDOWN_TIME;
    
func _input(event):
    if event is InputEventKey:
        if event.is_action("Shoot") and event.pressed:
            if isSelected:
                if cooldownBar.value >= 100:
                    if get_currently_available_energy() >= SHOOTING_COST:
                        cooldownBar.value = 0;
                        spend_energy(SHOOTING_COST);
                        var projectile_test = player_projectile.instance();
                        var clickPos : Vector2 = get_global_mouse_position();
                        var projectileMotion : Vector2 = (clickPos - global_position).normalized();
                        get_parent().add_child(projectile_test);
                        SoundHandler.shootSound.play()
                        projectile_test.global_position = global_position;
                        projectile_test.direction = projectileMotion;
                        projectile_test.speed = PLAYER_PROJECTILE_SPEED;
                        projectile_test.damage = PLAYER_PROJECTILE_DAMAGE;
                        projectile_test.lifespan = 10
                        projectile_test.limited_lifespan = true
                    else:
                        # Not enough energy
                        showEnergyWarning()
                else:
                    print("Gun is on cooldown");
                    #TODO show UI warning

func isPositionValid(pos):
    var dist : int = global_position.distance_to(pos)
    if HITBOX_RADIUS * 2 < dist and dist < NODE_RADIUS and !nodeSystem.isMouseOverlappingNode():
        return true
    else:
        return false
        
func showEnergyWarning():
    SoundHandler.energyWarningSound.play()
    $TextAnimation.play("energy_warning")

func hideEnergyWarning():
    $TextAnimation.stop()
    $TextUI/Warning.hide()