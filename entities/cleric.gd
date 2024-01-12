extends AnimatedSprite2D

const Hero = preload("res://entities/hero_common.gd")

var hero = Hero.new()
var is_dead


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	
	
func start():
	show()
	hero.MAX_HEALTH = 180
	hero.offense = 15
	hero.defense = 15
	hero.health = hero.MAX_HEALTH
	hero.entity_name = "CLERIC"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_action_heal(target):
	var heal = randi() % target.MAX_HEALTH / 5 + 30
	print("healing ", heal)
	target.health += heal
	if target.health > target.MAX_HEALTH: target.health = target.MAX_HEALTH
	var message = "CLERIC healed " + str(heal) + " health!"
	Global.TheDungeon.received_message.emit(message)
	
