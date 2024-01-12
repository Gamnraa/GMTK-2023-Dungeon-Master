extends AnimatedSprite2D

var health
var MAX_HEALTH = 180
var offense = 15
var defense = 15
var entity_name

signal dead
signal action_revive(target)
signal action_attack(target)
signal attacked

var is_dead

func _init():
	print("ready")
	action_attack.connect(_on_action_attack)
	action_revive.connect(_on_action_revive)

func _on_dead():
	hide()
	is_dead = true
	Global.TheDungeon.received_message.emit(entity_name + " defeated!")


func _on_action_revive():
	show()
	is_dead = false
	health = MAX_HEALTH
	Global.TheDungeon.received_message.emit(entity_name + " revived!")


func _on_action_attack(target):
	var damage_out = (randi() % offense * 2 + offense) - (randi() % target.defense + target.defense)
	if damage_out <= 0: damage_out = 1
	var damage_in = randi() % target.offense * 2 + target.offense - defense
	if damage_in <= 0: damage_in = 1
	print("damage dealt", damage_out, "\ndamage took", damage_in)
	health -= damage_in
	target.health -= damage_out
	var message = entity_name + " (" + str(damage_in) + " dmg) attacked " + target.entity_name + "(" + str(damage_out) + " dmg)!"
	Global.TheDungeon.received_message.emit(message)
	target.attacked.emit()
	_on_attacked()
	
	
func _on_attacked():
	if health <= 0:
		dead.emit()
		
func _on_action_heal(target):
	var heal = randi() % target.MAX_HEALTH / 10 + 15
	print("healing ", heal)
	target.health += heal
	if target.health > target.MAX_HEALTH: target.health = target.MAX_HEALTH
	var message = entity_name + " healed " + str(heal) + " health!"
	Global.TheDungeon.received_message.emit(message)
