extends AnimatedSprite2D

var health
var MAX_HEALTH = 120
var offense = 15
var defense = 50

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
	is_dead = true
	hide()

func _on_action_revive():
	show()
	is_dead = false
	health = MAX_HEALTH / 2


func _on_action_attack(target):
	var damage_out = (randi() % offense * 2 + offense) - (randi() % target.defense + target.defense)
	if damage_out <= 0: damage_out = 1
	var damage_in = randi() % target.offense * 2 + target.offense - defense
	if damage_in <= 0: damage_in = 1
	print("damage dealt", damage_out, "\ndamage took", damage_in)
	health -= damage_in
	target.health -= damage_out
	target.attacked.emit()
	_on_attacked()


func _on_attacked():
	if health <= 0:
		dead.emit()


func _on_action_heal(target):
	var heal = randi() % target.MAX_HEALTH / 8 + 20
	print("healing ", heal)
	target.health += heal
	if target.health > target.MAX_HEALTH: target.health = target.MAX_HEALTH
