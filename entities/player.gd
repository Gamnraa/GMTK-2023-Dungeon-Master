extends AnimatedSprite2D


var health
var offense = 1
var defense = 10
var gold
var active = false
var is_turn = false


signal dead
signal end_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ThePlayer = self
	hide()
	

func start(room):
	show()
	health = 100
	gold = 100
	active = true
	is_turn = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
