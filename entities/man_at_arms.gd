extends AnimatedSprite2D

const Hero = preload("res://entities/hero_common.gd")

var hero = Hero.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	
func start():
	show()
	hero.MAX_HEALTH = 100
	hero.offense = 40
	hero.defense = 10
	hero.health = hero.MAX_HEALTH
	hero.entity_name = "MAN_AT_ARMS"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
