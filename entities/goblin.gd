extends Area2D

var health
@export var MAX_HEALTH = 150
@export var offense = 5
@export var defense = 10
@export var entity_name = "GOBLIN"

signal dead
signal action_attack(target)
signal attacked

var is_dead
var curr_room

var mouse_over = false
var selected = false



func can_move():
	return Global.ThePlayer.is_turn and not curr_room.has_party

func move_to_room(room):
	if curr_room: 
		curr_room.num_monsters -= 1
		on_lose_focus()
		curr_room.monsters.erase(self)
		
	curr_room = room
	room.num_monsters += 1
	curr_room.monsters.append(self)
	var i = 1
	for monster in curr_room.monsters:
		var offset_x = room.get_node("MonsterPosition").position.x
		var offset_y = 40 * i
		i += 1
		monster.position = Vector2(room.position.x + offset_x, room.position.y + offset_y)
	
	
func _input(event):
	if can_move() and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_over:
			on_gain_focus()
		
func on_gain_focus():
	selected = true
	if curr_room.next_rooms:
		for room in curr_room.next_rooms:
			if room.num_monsters < 3:
				room.on_gain_focus()
				room.send_to_room.connect(move_to_room)
			
	if curr_room.prev_rooms:
		for room in curr_room.prev_rooms:
			if room.num_monsters < 3:
				room.on_gain_focus()
				room.send_to_room.connect(move_to_room)
		
func on_lose_focus():
	selected = false
	if curr_room.next_rooms:
		for room in curr_room.next_rooms:
			room.on_lose_focus()
			room.send_to_room.disconnect(move_to_room)
	
	if curr_room.prev_rooms:		
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
	curr_room.num_monsters -= 1
	curr_room.monsters.erase(self)
	queue_free()


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


func _on_action_attack(target):
	var damage_out = (randi() % offense * 2 + offense) - (randi() % target.defense + target.defense)
	if damage_out <= 0: damage_out = 1
	var damage_in = (randi() % target.offense + target.offense) - defense
	if damage_in <= 0: damage_in = 1
	print("damage dealt", damage_out, "\ndamage took", damage_in)
	health -= damage_in
	target.health -= damage_out
	target.attacked.emit()
	_on_attacked()


func _on_attacked():
	if health <= 0:
		dead.emit()
