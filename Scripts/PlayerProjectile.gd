extends KinematicBody2D

onready var direction;
onready var speed;
onready var accel;
onready var limited_lifespan = false;
onready var lifespan;
onready var damage;


func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    if limited_lifespan:
        lifespan -= delta;
    if limited_lifespan and lifespan <= 0:
        queue_free();
    move_and_slide(direction * speed);
    
func _on_Area2D_area_entered(area):
    #TODO
    pass;