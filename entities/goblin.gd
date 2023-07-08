extends Area2D

var health
var MAX_HEALTH = 180
var offense = 5
var defense = 10

signal dead
signal action_attack(target)

var is_dead
var curr_room

var mouse_over = false
var selected = false



func move_to_room(room):
	if curr_room: 
		curr_room.num_monsters -= 1
		on_lose_focus()
	curr_room = room
	room.num_monsters += 1
	var offset_x = room.get_node("MonsterPosition").position.x
	var offset_y = 40 * room.num_monsters
	position = Vector2(room.position.x + offset_x, room.position.y + offset_y)
	
	
func _input(event):
	if Global.ThePlayer.is_turn and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_over:
			on_gain_focus()
		
func on_gain_focus():
	selected = true
	for room in curr_room.next_rooms:
		room.on_gain_focus()
		room.send_to_room.connect(move_to_room)
		
	for room in curr_room.prev_rooms:
		room.on_gain_focus()
		room.send_to_room.connect(move_to_room)
		
func on_lose_focus():
	selected = false
	for room in curr_room.next_rooms:
		room.on_lose_focus()
		room.send_to_room.disconnect(move_to_room)
			
	for room in curr_room.prev_rooms:
		room.on_lose_focus()
		room.send_to_room.disconnect(move_to_room)
	
func _ready():
	show()
	health = MAX_HEALTH
	is_dead = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dead():
	queue_free()


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
