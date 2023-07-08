extends Node2D

var alive_members
var moves_left = 0
var in_combat

signal action_move(destination)
signal action_revive(target)
signal action_attack(attacker, target)
signal action_hero_ability(user)

func get_actions():
	var revive_weight = alive_members.size() - get_children().size() * 20
	#we'll code this logic later. Most of this will likely change
	if not in_combat:
		action_move.emit()
		moves_left -= 1
	else:
		action_attack.emit()
		moves_left -= 1
# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	
func start():
	alive_members = []
	#This is fine so long the only children of this node are our chars
	for child in get_children():
		child.start()
		alive_members.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_man_at_arms_dead():
	$man_at_arms.dead = true
	alive_members.erase($man_at_arms)


func _on_paladin_dead():
	$paladin.dead = true
	alive_members.erase($paladin)

func _on_cleric_dead():
	$cleric.dead = true
	alive_members.erase($cleric)
