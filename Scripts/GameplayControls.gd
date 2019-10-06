extends Node2D

enum NodeType {ENERGY, GUN}

var energyNodeScene = load("res://Scenes/EnergyNode.tscn")
var gunNodeScene = load("res://Scenes/GunNode.tscn")

onready var mouseArea = $MouseArea

onready var selectedNode = null

onready var allGroups = {};
onready var alreadyTraversed = {};


onready var BUILD_ENERGY_MODE = 1;
onready var BUILD_GUN_MODE = 2;
onready var ADD_LINK_MODE = 3;
onready var currentMode = BUILD_ENERGY_MODE;


func _process(delta):
    mouseArea.global_position = get_viewport().get_mouse_position()
    if Input.is_action_just_pressed("deselect"):
        deselectNode()
    if Input.is_action_just_pressed("BuildEnergyNode"):
        currentMode = BUILD_ENERGY_MODE;
        print("Build energy mode");
    if Input.is_action_just_pressed("BuildGunNode"):
        currentMode = BUILD_GUN_MODE;
        print("Build gun mode");
    if Input.is_action_just_pressed("BuildLink"):
        currentMode = ADD_LINK_MODE;
        print("Build link mode");


func _ready():
    var initialPos = Vector2(417, 270);
    placeNode(initialPos, NodeType.ENERGY);
    tabulateGroups();
    

func selectNode(target) -> void:
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
    
func tabulateGroups() -> void:
    var groupIdCounter = 0;
    alreadyTraversed = {};
    allGroups = {};
    var allSpaceNodes = get_tree().get_nodes_in_group("SpaceNodes");
    for spaceNode in allSpaceNodes:
        if alreadyTraversed.has(spaceNode.get_instance_id()):
            continue;
        groupIdCounter += 1;
        allGroups[groupIdCounter] = [];
        recursiveDFS(spaceNode, groupIdCounter);    
        
func recursiveDFS(currentNode, groupIdCounter) -> void:
    if alreadyTraversed.has(currentNode.get_instance_id()):
            return;
    currentNode.groupId = groupIdCounter;
    allGroups[groupIdCounter].push_back(currentNode.get_instance_id());
    alreadyTraversed[currentNode.get_instance_id()] = 1;
    for neighbor in currentNode.adjacentNodes:
        recursiveDFS(neighbor, groupIdCounter);
        

#Returns the newly created node
func placeNode(pos: Vector2, type = NodeType.GUN):
    #TODO right now it always spawns an energy node, should be based on UI selection
    var newNode = null
    if type == NodeType.ENERGY:
        newNode = energyNodeScene.instance()
    elif type == NodeType.GUN:
        newNode = gunNodeScene.instance()
    add_child(newNode)
    newNode.global_position = pos
    # TODO use real energy cost from energy nodes energy -= newNode.getEnergyCost()
    return newNode

func isMouseOverlappingNode() -> bool:
    for node in get_tree().get_nodes_in_group("SpaceNodes"):
        if mouseArea.global_position.distance_to(node.global_position) < node.MOUSE_RADIUS:
            return true
    return false
