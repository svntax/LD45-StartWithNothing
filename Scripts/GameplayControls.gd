extends Node2D

enum NodeType {ENERGY, GUN}

var energyNodeScene = load("res://Scenes/EnergyNode.tscn")
var gunNodeScene = load("res://Scenes/GunNode.tscn")

onready var mouseArea = $MouseArea
onready var nodeSelectUI = $UILayer/NodeTypeSelectionUI
onready var uiAnimation = $UILayer/UIAnimation
onready var waveText = $UILayer/TopUI/WaveLabel
onready var enemySpawningSystem = $EnemySpawningSystem

onready var selectedNode = null

onready var allGroups = {};
onready var alreadyTraversed = {};


onready var BUILD_ENERGY_MODE = 1;
onready var BUILD_GUN_MODE = 2;
onready var ADD_LINK_MODE = 3;
onready var currentMode = BUILD_ENERGY_MODE;


func _process(delta):
    mouseArea.global_position = get_viewport().get_mouse_position()
    if Input.is_action_just_pressed("BuildEnergyNode"):
        currentMode = BUILD_ENERGY_MODE;
        nodeSelectUI.selectEnergyNode()
    if Input.is_action_just_pressed("BuildGunNode"):
        currentMode = BUILD_GUN_MODE;
        nodeSelectUI.selectGunNode()
    if Input.is_action_just_pressed("BuildLink"):
        currentMode = ADD_LINK_MODE;
        nodeSelectUI.selectLinkIcon()
    if Input.is_action_just_pressed("NodeSelection"):
        if mouseArea.get_overlapping_areas().size() == 0:
            print("No overlapping bodies");
            deselectNode();
        else:
            var shouldDeselect = true
            # Ignore NodeRange areas that aren't from the currently selected node
            for area in mouseArea.get_overlapping_areas():
                if area.get_parent() == selectedNode:
                    shouldDeselect = false
            if shouldDeselect:
                deselectNode()


func _ready():
    var initialPos = Vector2(417, 270);
    placeNode(initialPos, NodeType.ENERGY, false);
    tabulateGroups();

func showWaveCompleteUI():
    waveText.set_text("Wave Complete")
    uiAnimation.play("show_wave_text")

func showNextWaveUI(wave):
    waveText.set_text("Wave " + str(wave))
    uiAnimation.play("show_wave_text")

func _on_EnemySpawningSystem_wave_start(currentWave):
    showNextWaveUI(currentWave)

func selectNode(target) -> void:
    selectedNode = target

func deselectNode() -> void:
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
        

# Returns the newly created node
func placeNode(pos: Vector2, type = NodeType.GUN, playSound = true):
    var newNode = null
    if type == NodeType.ENERGY:
        newNode = energyNodeScene.instance()
    elif type == NodeType.GUN:
        newNode = gunNodeScene.instance()
    add_child(newNode)
    newNode.global_position = pos
    if playSound:
        SoundHandler.buildSound.pitch_scale = 1
        SoundHandler.buildSound.play()
    # TODO use real energy cost from energy nodes energy -= newNode.getEnergyCost()
    return newNode

func isMouseOverlappingNode() -> bool:
    for node in get_tree().get_nodes_in_group("SpaceNodes"):
        if mouseArea.global_position.distance_to(node.global_position) < node.HITBOX_RADIUS:
            return true
    return false

func gameOver():
    enemySpawningSystem.stopSpawningEnemies()
    uiAnimation.play("show_game_over")

func _on_UIAnimation_animation_finished(anim):
    if anim == "show_game_over":
        uiAnimation.play("fade_out")
    elif anim == "fade_out":
        get_tree().paused = true

func _on_ReturnButton_pressed():
    print("pressed")
    get_tree().paused = false
    get_tree().change_scene("res://Scenes/Main.tscn")