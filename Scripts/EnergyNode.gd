extends "res://Scripts/SpaceNode.gd"

onready var NODE_RADIUS = nodeRange.get_node("CollisionShape2D").shape.radius
onready var MOUSE_RADIUS = $MouseDetectRange/CollisionShape2D.shape.radius
onready var current_charge = 0.0;
onready var MAXIMUM_CHARGE = 100;
onready var SECONDS_TO_FULL_CHARGE = 8;
onready var energyBar = $EnergyUI/EnergyBar

func _ready():
    energyCost = 50 #TODO adjust later
    energyBar.set_value(0)

func _draw():
    for node in adjacentNodes:
        #to_local() needed because _draw() is relative to this node's position
        draw_line(to_local(global_position), to_local(node.global_position), Color.red, 2)
    if isSelected:
        draw_rect(Rect2(-16, -16, 32, 32), Color.green, false)
        #draw_circle(Vector2(0, 0), NODE_RADIUS, Color.green)

func _process(delta):
    update()
    energyBar.set_value(energyBar.value + delta * energyBar.max_value / SECONDS_TO_FULL_CHARGE)

func isPositionValid(pos):
    var dist : int = global_position.distance_to(pos)
    if MOUSE_RADIUS * 2 < dist and dist < NODE_RADIUS and !nodeSystem.isMouseOverlappingNode():
        return true
    else:
        return false
        


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
