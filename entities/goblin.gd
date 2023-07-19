extends Area2D

var health
@export var MAX_HEALTH = 150
@export var offense = 5
@export var defense = 10
@export var entity_name = "GOBLIN"
var movable = true

signal dead
signal action_attack(target)
signal attacked

var is_dead
var curr_room

var mouse_over = false
var selected = false
var selectable = false



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
		if monster.movable: monster.position = Vector2(room.position.x + offset_x, room.position.y + offset_y)
	
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_over:
			on_gain_focus()
		elif Global.TheParty.selectable and selected:
			Global.TheParty.on_attacked(self)
		
func on_gain_focus():
	selected = true
	if can_move():
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
	elif curr_room.has_party:
		Global.TheParty.active = true
		Global.TheParty.get_node("AttackIndicator").show()
	
	Global.TheDungeon.get_node("HUD").get_node("ButtonX").show()
	Global.TheDungeon.get_node("HUD").get_node("CancelLabel").show()
	
		
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
			
	Global.TheDungeon.get_node("HUD").get_node("ButtonX").hide()
	Global.TheDungeon.get_node("HUD").get_node("CancelLabel").hide()
	
func _ready():
	show()
	health = MAX_HEALTH
	is_dead = false
	movable = true
	$Selector.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dead():
	curr_room.num_monsters -= 1
	curr_room.monsters.erase(self)
	Global.TheDungeon.received_message.emit(entity_name + " defeated!")
	queue_free()


func _on_mouse_entered():
	if selectable: 
		mouse_over = true
		$Selector.show()


func _on_mouse_exited():
	mouse_over = false
	$Selector.hide()


func _on_action_attack(target):
	var damage_out = (randi() % offense * 2 + offense) - (randi() % target.defense + target.defense)
	if damage_out <= 0: damage_out = 1
	var damage_in = (randi() % target.offense + target.offense) - defense
	if damage_in <= 0: damage_in = 1
	print("damage dealt", damage_out, "\ndamage took", damage_in)
	health -= damage_in
	target.health -= damage_out
	var message = entity_name + " (" + str(damage_in) + " dmg) attacked " + target.entity_name + "(" + str(damage_out) + " dmg)!"
	Global.TheDungeon.received_message.emit(message)
	target.attacked.emit()
	_on_attacked()
	
	
	on_lose_focus()


func _on_attacked():
	if health <= 0:
		dead.emit()
