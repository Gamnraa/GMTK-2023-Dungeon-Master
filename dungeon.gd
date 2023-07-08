extends Node2D

@export var goblin_spawner: PackedScene

var turn = 0
var active_player = turn % 2
var moves_left = 5
var selected_monster

signal next_turn
# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	
func start():
	$room.next_rooms.append($room1_1)
	$room.next_rooms.append($room1_2)
	
	$room1_1.prev_rooms.append($room)
	$room1_1.next_rooms.append($room2)
	
	$room1_2.prev_rooms.append($room)
	$room1_2.next_rooms.append($room2)
	
	$room2.prev_rooms.append($room1_1)
	$room2.prev_rooms.append($room1_2)
	$room2.next_rooms.append($room2_1)
	$room2.next_rooms.append($room2_2)
	
	$room2_1.prev_rooms.append($room2)
	$room2_1.next_rooms.append($room2_1_1)
	
	$room2_2.prev_rooms.append($room2)
	$room2_2.next_rooms.append($room2_2_1)
	
	$room2_1_1.prev_rooms.append($room2_1)
	$room2_1_1.next_rooms.append($room3)
	
	$room2_2_1.prev_rooms.append($room2_2)
	$room2_2_1.next_rooms.append($room3)
	
	print($room1_1.get_node("HeroPosition").position)
	$party.move_to_room($room)
	
	var goblin = goblin_spawner.instantiate()
	goblin.move_to_room($room)
	add_child(goblin)
	
	goblin = goblin_spawner.instantiate()
	goblin.move_to_room($room2)
	add_child(goblin)
	
	$Player.start($room3)
	print("player is active")
	

func on_use_move():
	moves_left -= 1
	if moves_left <= 0:
		next_turn.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_room_send_to_room(room):
	on_use_move()

func _on_next_turn():
	print("SWITCH ACTIVE TEAM")
	if active_player < 1:
		#player's turn ends
		$Player.is_turn = false
	else:
		$Player.is_turn = true
