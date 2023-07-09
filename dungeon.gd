extends Node2D

@export var goblin_spawner: PackedScene
@export var ogre_spawner: PackedScene
@export var slasher_spawner: PackedScene

var turn = 0
var active_player = turn % 2
var moves_left = 5
var selected_monster

signal next_turn
signal heroes_turn
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.TheDungeon = self
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
	
	$room3.prev_rooms.append($room2_1_1)
	$room3.prev_rooms.append($room2_2_1)
	
	print($room1_1.get_node("HeroPosition").position)
	$party.move_to_room($room)
	
	var goblin = goblin_spawner.instantiate()
	goblin.move_to_room($room)
	add_child(goblin)
	
	goblin = goblin_spawner.instantiate()
	goblin.move_to_room($room2)
	add_child(goblin)
	
	goblin = ogre_spawner.instantiate()
	goblin.move_to_room($room2)
	add_child(goblin)
	
	goblin = slasher_spawner.instantiate()
	goblin.move_to_room($room3)
	add_child(goblin)
	
	$Player.start($room3)
	print("player is active")
	$HUD.on_player_turn_start()
	

func on_use_move(amount):
	moves_left -= amount
	if moves_left <= 0:
		_on_next_turn()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_room_send_to_room(room):
	on_use_move(1)

func _on_next_turn():
	print("SWITCH ACTIVE TEAM")
	if active_player < 1:
		#player's turn ends
		$Player.is_turn = false
		$PartyTimer.start()
		moves_left = 3
		heroes_turn.emit()
	else:
		$Player.is_turn = true
		$PartyTimer.stop()
		moves_left = 5
		next_turn.emit()
		
	turn += 1
	active_player = turn % 2


func _on_party_timer_timeout():
	$party.get_actions()


func _on_party_perform_action(moves):
	on_use_move(moves)
	
func get_rooms_open():
	var rooms = get_tree().get_nodes_in_group("rooms")
	for room in rooms:
		if room.num_monsters == 3 or room.has_party:
			rooms.erase(room)
			
	return rooms
