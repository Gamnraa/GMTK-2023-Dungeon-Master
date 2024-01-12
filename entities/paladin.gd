extends AnimatedSprite2D

const Hero = preload("res://entities/hero_common.gd")

var hero = Hero.new()

var is_dead

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	
func start():
	show()
	hero.MAX_HEALTH = 120
	hero.offense = 25
	hero.defense = 50
	hero.health = hero.MAX_HEALTH
	hero.entity_name = "PALADIN"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
