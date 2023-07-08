extends AnimatedSprite2D

var health
var MAX_HEALTH = 100
var offense = 30
var defense = 10

signal dead
var is_dead

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	
func start():
	show()
	health = MAX_HEALTH
	is_dead = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dead():
	pass # Replace with function body.


func _on_party_action_revive(target):
	is_dead = false
	health = MAX_HEALTH / 2
