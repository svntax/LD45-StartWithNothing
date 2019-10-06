extends Position2D

# Original source: https://github.com/mlokogrgel1/Worm_

onready var body : Array = [] # List of segments that make up the worm's body
onready var head_segment = null
onready var rot : float = 0
onready var heading : float = 0 # Rotation of head worm segment, in radians
onready var vel : Vector2 = Vector2()

# Segment joint
onready var j1 : Vector2 = Vector2()

export (PackedScene) var Segment
export (int) var segment_number = 1
export (int) var distance_between_joints = 40

func _ready():
    pass

func init_segments() -> void:
    # Initialize the segments, can customize each segment's properties if needed
    for i in range(segment_number):
        var segment = Segment.instance()
        add_child(segment)
        if head_segment == null:
            head_segment = segment
        segment.set_distance_between_joints(distance_between_joints)
        segment.j1 = j1
        j1=Vector2(j1.x - distance_between_joints, 0)
        segment.j2 = j1
        body.append(segment)
    # Changes drawing order of segments so that head segments draw above trailing segments
    for i in body:
        move_child(i,0)

func set_number_of_segments(num) -> void:
    segment_number = num

func set_segment_scene(segment_scene : PackedScene) -> void:
    Segment = segment_scene

func _physics_process(delta):
    # Worm movement
    if vel.length() > 0:
        var vel_ = vel.rotated(heading) * delta
        for segment in body :
            vel_ = Vector2(vel_.length(), 0).rotated((segment.j1 - segment.j2).angle_to(vel_))
            segment.move(vel_)
            vel_ = Vector2(segment.base + vel_.x - sqrt(segment.base * segment.base - vel_.y * vel_.y), 0).rotated(segment.rotation)