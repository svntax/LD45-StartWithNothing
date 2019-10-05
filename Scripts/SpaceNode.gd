extends Node2D

#References Gameplay.tscn with script that handles making connections
onready var nodeSystem = get_parent()

onready var adjacentNodes : Array = []
onready var nodeRange : Area2D = $NodeRange

onready var energyCost = 0 #Cost to build
onready var isSelected = false

onready var groupId = -1;

onready var NODE_RADIUS = nodeRange.get_node("CollisionShape2D").shape.radius
onready var MOUSE_RADIUS = $MouseDetectRange/CollisionShape2D.shape.radius

func connectNode(targetNode) -> void:
    for element in adjacentNodes:
        if element == targetNode:
            #Already exists, so return
            return
    adjacentNodes.append(targetNode)
    nodeSystem.tabulateGroups()

func disconnectNode(targetNode) -> void:
    var i = adjacentNodes.find(targetNode)
    if i > -1:
        adjacentNodes.remove(i)
    nodeSystem.tabulateGroups()

func deselect() -> void:
    isSelected = false

func removeNode() -> void:
    for node in adjacentNodes:
        node.disconnectNode(self)
    adjacentNodes.clear()
    if nodeSystem.getSelectedNode() == self:
        nodeSystem.deselectNode()
    queue_free()
    
func get_connected_energy_nodes():
    var ret = [];
    var groupMemberIds = nodeSystem.allGroups[self.groupId];
    var allEnergyNodes = get_tree().get_nodes_in_group("EnergyNodes");
    for energyNode in allEnergyNodes:
        if groupMemberIds.has(energyNode.get_instance_id()):
            ret.push_back(energyNode);
    return ret;
            
func get_currently_available_energy():
    var availableEnergyNodes = get_connected_energy_nodes();
    var total = 0.0;
    for energyNode in availableEnergyNodes:
        total+=energyNode.energyBar.value;
    print("Determined total value to be ", total);
    return total;
    
func spend_energy(cost):
    var availableEnergyNodes = get_connected_energy_nodes();
    while(cost > 0):
        var lowestNonZero = null;
        var spenders = 0;
        for energyNode in availableEnergyNodes:
            if energyNode.energyBar.value <= 0:
                print("Value <= 0: ", energyNode.energyBar.value);
                continue;
            spenders += 1;
            if lowestNonZero == null or energyNode.energyBar.value < lowestNonZero.energyBar.value:
                lowestNonZero = energyNode;
        var amountBeingSpent = min(lowestNonZero.energyBar.value * spenders, cost);
        cost -= amountBeingSpent;
        for energyNode in availableEnergyNodes:
            if energyNode.energyBar.value >= lowestNonZero.energyBar.value:
                energyNode.energyBar.value -= amountBeingSpent / spenders;

func getAdjacentNodes() -> Array:
    return adjacentNodes

func getNodesInRange() -> Array:
    return nodeRange.get_overlapping_areas()

func getEnergyCost() -> int:
    return energyCost
    
func _on_NodeRange_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
        if isSelected:
            if isPositionValid(event.position):
                print("valid point")
                if(self.get_currently_available_energy() >= energyCost):
                    self.spend_energy(energyCost);
                    var newNode = nodeSystem.placeNode(event.position)
                    nodeSystem.connectNodes(newNode, self)
                    nodeSystem.deselectNode()
                else:
                    print("Not enough energy");
            else:
                print("invalid point")

func _on_MouseDetectRange_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed :
        if event.button_index == BUTTON_LEFT:
            if not isSelected and not nodeSystem.hasSelectedNode():
                isSelected = true
                nodeSystem.selectNode(self)
                print("mouse range click")
            elif not isSelected and nodeSystem.hasSelectedNode():
                nodeSystem.connectNodes(self, nodeSystem.getSelectedNode())
                nodeSystem.deselectNode()
        elif event.button_index == BUTTON_RIGHT and !nodeSystem.hasSelectedNode():
            #TODO debug node removal, remove later?
            self.removeNode()
            
func isPositionValid(pos):
    var dist : int = global_position.distance_to(pos)
    if MOUSE_RADIUS * 2 < dist and dist < NODE_RADIUS and !nodeSystem.isMouseOverlappingNode():
        return true
    else:
        return false
