extends Node2D

onready var energyNodeIcon = $IconEnergy
onready var gunNodeIcon = $IconGun
onready var linkIcon = $IconConnect
onready var iconHighlight = $IconHighlight
onready var actionLabel = $ActionRoot/ActionLabel

func selectEnergyNode():
    iconHighlight.position = energyNodeIcon.position
    actionLabel.set_text("Energy Node")

func selectGunNode():
    iconHighlight.position = gunNodeIcon.position
    actionLabel.set_text("Gun Node")

func selectLinkIcon():
    iconHighlight.position = linkIcon.position
    actionLabel.set_text("Connect Nodes")