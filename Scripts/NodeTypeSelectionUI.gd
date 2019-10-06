extends Node2D

onready var energyNodeIcon = $IconEnergy
onready var gunNodeIcon = $IconGun
onready var linkIcon = $IconConnect
onready var iconHighlight = $IconHighlight

func selectEnergyNode():
    iconHighlight.position = energyNodeIcon.position

func selectGunNode():
    iconHighlight.position = gunNodeIcon.position

func selectLinkIcon():
    iconHighlight.position = linkIcon.position