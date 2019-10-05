extends Node2D

#References Gameplay.tscn with script that handles making connections
onready var nodeSystem = get_parent()

onready var adjacentNodes : Array = []
onready var nodeRange : Area2D = $NodeRange

onready var energyCost = 0 #Cost to build
onready var isSelected = false

func connectNode(targetNode) -> void:
    for element in adjacentNodes:
        if element == targetNode:
            #Already exists, so return
            return
    adjacentNodes.append(targetNode)

func disconnectNode(targetNode) -> void:
    var i = adjacentNodes.find(targetNode)
    if i > -1:
        adjacentNodes.remove(i)

func deselect() -> void:
    isSelected = false

func removeNode() -> void:
    for node in adjacentNodes:
        node.disconnectNode(self)
    adjacentNodes.clear()
    if nodeSystem.getSelectedNode() == self:
        nodeSystem.deselectNode()
    queue_free()

func getAdjacentNodes() -> Array:
    return adjacentNodes

func getNodesInRange() -> Array:
    return nodeRange.get_overlapping_areas()

func getEnergyCost() -> int:
    return energyCost