extends Area2D

var health
var MAX_HEALTH = 180
var offense = 5
var defense = 10

signal dead
signal action_attack(target)

var is_dead
var curr_room

func move_to_room(room):
	curr_room = room
	room.num_monsters += 1
	print(room.num_monsters)
	var offset_x = room.get_node("MonsterPosition").position.x
	var offset_y = 40 * room.num_monsters
	position = Vector2(room.position.x + offset_x, room.position.y + offset_y)
	
	
func _ready():
	show()
	health = MAX_HEALTH
	is_dead = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dead():
	queue_free()
