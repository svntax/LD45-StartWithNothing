extends "res://Scripts/WormSpawner.gd"

# Affects how fast to turn towards the target node
onready var turningWeight = 0.8

onready var targetNode = null
onready var fallbackTargetPos = Vector2(400 + rand_range(-300, 300), 300 + rand_range(-200, 200))

func _physics_process(delta):
    control(delta)
    
func init_segments() -> void:
    .init_segments()
    for segment in body:
        segment.connect("segment_destroyed", self, "on_segment_destroyed")
    head_segment.connect("node_found", self, "on_node_found")
    head_segment.connect("node_left", self, "on_node_left")

func on_segment_destroyed(segment):
    queue_free() #TODO fancy effects

func on_node_found(node):
    if targetNode == null:
        targetNode = node
        print(targetNode)
    else:
        var currentDist = head_segment.global_position.distance_to(targetNode.global_position)
        var newDist = head_segment.global_position.distance_to(node.global_position)
        if newDist < currentDist:
            targetNode = node
            print(targetNode)

func on_node_left(node):
    if node == targetNode:
        targetNode = null
        #TODO find new target node?

func control(delta):
    vel = Vector2(90, 0)
    if targetNode != null:
        # Returns an angle from -180 to 180
        var targetAngle = head_segment.global_position.angle_to_point(targetNode.global_position)   
        if heading < targetAngle + PI: # Need offset of PI
            heading += PI * delta * turningWeight
        else:
            heading -= PI * delta * turningWeight
        #NOTE: when angle_to_point() jumps from -180 to 180 or vice versa, the ship will want to
        #turn 360 degrees to match the new angle, which is bad behavior but not that game breaking
    else:
        var targetAngle = head_segment.global_position.angle_to_point(fallbackTargetPos)
        if heading < targetAngle + PI: # Need offset of PI
            heading += PI * delta * turningWeight
        else:
            heading -= PI * delta * turningWeight

func targetRandomNode():
    var spaceNodes = get_tree().get_nodes_in_group("SpaceNodes")
    var i = randi() % spaceNodes.size()
    fallbackTargetPos = spaceNodes[i].global_position + Vector2(rand_range(-200, 200), rand_range(-200, 200))

func _on_TargetCheckTimer_timeout():
    if targetNode == null:
        # Target random node as fallback, with random offset
        targetRandomNode()
