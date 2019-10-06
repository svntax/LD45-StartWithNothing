extends "res://Scripts/SpaceNode.gd"

onready var current_charge = 0.0;
onready var MAXIMUM_CHARGE = 100;
onready var SECONDS_TO_FULL_CHARGE = 8;

onready var player_projectile = load("res://Scenes/PlayerProjectile.tscn")

onready var PLAYER_PROJECTILE_SPEED = 50;
onready var PLAYER_PROJECTILE_DAMAGE = 10;


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
    
func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_RIGHT and event.pressed:
            if isSelected:
                var projectile_test = player_projectile.instance();
                var clickPos : Vector2 = get_global_mouse_position();
                var projectileMotion : Vector2 = (clickPos - global_position).normalized();
                get_parent().add_child(projectile_test);
                projectile_test.global_position = global_position;
                projectile_test.direction = projectileMotion;
                projectile_test.speed = PLAYER_PROJECTILE_SPEED;
                projectile_test.damage = PLAYER_PROJECTILE_DAMAGE;
                

func isPositionValid(pos):
    var dist : int = global_position.distance_to(pos)
    if MOUSE_RADIUS * 2 < dist and dist < NODE_RADIUS and !nodeSystem.isMouseOverlappingNode():
        return true
    else:
        return false
        
