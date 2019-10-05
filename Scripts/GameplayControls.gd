extends Node2D

var energyNodeScene = load("res://Scenes/EnergyNode.tscn")

onready var mouseArea = $MouseArea
onready var energyUI = $UILayer/UIRoot/EnergyLabel

onready var selectedNode = null
onready var energy = 100

func _process(delta):
    mouseArea.global_position = get_viewport().get_mouse_position()
    if Input.is_action_just_pressed("deselect"):
        deselectNode()

func selectNode(target) -> void:
    deselectNode()
    selectedNode = target

func deselectNode() -> void:
    print("deselectNode()")
    if selectedNode != null:
        selectedNode.deselect()
    selectedNode = null

func hasSelectedNode() -> bool:
    return selectedNode != null

func getSelectedNode():
    return selectedNode

func connectNodes(node1, node2) -> void:
    node1.connectNode(node2)
    node2.connectNode(node1)

func disconnectNodes(node1, node2) -> void:
    node1.disconnectNode(node2)
    node2.disconnectNode(node1)

#Returns the newly created node
func placeNode(pos: Vector2):
    #TODO right now it always spawns an energy node, should be based on UI selection
    var newNode = energyNodeScene.instance()
    add_child(newNode)
    newNode.global_position = pos
    energy -= newNode.getEnergyCost()
    return newNode

func isMouseOverlappingNode() -> bool:
    for node in get_tree().get_nodes_in_group("SpaceNodes"):
        if mouseArea.global_position.distance_to(node.global_position) < node.MOUSE_RADIUS:
            return true
    return false

func addEnergy(amount) -> void:
    energy += amount