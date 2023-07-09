extends AnimatedSprite2D


var health
var offense = 1
var defense = 3
var gold
var active = false
var is_turn = false
var entity_name = "THE BOSS"
var movable = false


signal dead
signal attacked

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
	room.monsters.append(self)
	room.num_monsters += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attacked():
	if health <= 0:
		dead.emit()
		hide()
