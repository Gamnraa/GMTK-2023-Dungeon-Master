extends AnimatedSprite2D

var health
var MAX_HEALTH = 180
var offense = 15
var defense = 15
var entity_name = "CLERIC"

signal dead
signal action_revive(target)
signal action_attack(target)
signal action_hero_ability
signal action_heal(target)
signal attacked

var is_dead


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	
func start():
	show()
	health = MAX_HEALTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dead():
	hide()
	is_dead = true
	Global.TheDungeon.received_message.emit("CLERIC defeated!")


func _on_action_revive():
	show()
	is_dead = false
	health = MAX_HEALTH
	Global.TheDungeon.received_message.emit("CLERIC revived!")


func _on_action_attack(target):
	var damage_out = (randi() % offense * 2 + offense) - (randi() % target.defense + target.defense)
	if damage_out <= 0: damage_out = 1
	var damage_in = randi() % target.offense * 2 + target.offense - defense
	if damage_in <= 0: damage_in = 1
	print("damage dealt", damage_out, "\ndamage took", damage_in)
	health -= damage_in
	target.health -= damage_out
	var message = "CLERIC (" + str(damage_in) + " dmg) attacked " + target.entity_name + "(" + str(damage_out) + " dmg)!"
	Global.TheDungeon.received_message.emit(message)
	target.attacked.emit()
	_on_attacked()
	
	
func _on_attacked():
	if health <= 0:
		dead.emit()


func _on_action_heal(target):
	var heal = randi() % target.MAX_HEALTH / 5 + 30
	print("healing ", heal)
	target.health += heal
	if target.health > target.MAX_HEALTH: target.health = target.MAX_HEALTH
	var message = "CLERIC healed " + str(heal) + " health!"
	Global.TheDungeon.received_message.emit(message)
