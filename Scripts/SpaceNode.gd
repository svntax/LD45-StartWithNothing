extends Node2D

#References Gameplay.tscn with script that handles making connections
onready var nodeSystem = get_parent()

onready var adjacentNodes : Array = []
onready var nodeRange : Area2D = $NodeRange

onready var energyCost = 0 #Cost to build
onready var isSelected = false

onready var groupId = -1;

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