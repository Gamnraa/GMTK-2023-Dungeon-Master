extends Node2D

@export var goblin_spawner: PackedScene
@export var ogre_spawner: PackedScene
@export var slasher_spawner: PackedScene
@export var treasure_spawner: PackedScene

var turn = 0
var active_player = turn % 2
var moves_left = 3
var selected_monster
var game_over
var cooldown = true

signal next_turn
signal heroes_turn
signal moves_changed
signal gold_changed
signal received_message(message)
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.TheDungeon = self
	start()
	
func start():
	for room in get_tree().get_nodes_in_group("rooms"):
		room.start()
	
	$room.next_rooms.append($room1_1)
	$room.next_rooms.append($room1_2)
	
	$room1_1.prev_rooms.append($room)
	$room1_1.next_rooms.append($room2)
	
	$room1_2.prev_rooms.append($room)
	$room1_2.next_rooms.append($room2)
	var treasure = treasure_spawner.instantiate()
	$room1_2.treasure = treasure
	$room1_2.has_treasure = true
	treasure.position = Vector2($room1_2.position.x + 50, $room1_2.position.y + 50)
	add_child(treasure)
	
	$room2.prev_rooms.append($room1_1)
	$room2.prev_rooms.append($room1_2)
	$room2.next_rooms.append($room2_1)
	$room2.next_rooms.append($room2_2)
	
	$room2_1.prev_rooms.append($room2)
	$room2_1.next_rooms.append($room2_1_1)
	treasure = treasure_spawner.instantiate()
	$room2_1.treasure = treasure
	$room2_1.has_treasure = true
	treasure.position = Vector2($room2_1.position.x + 50, $room2_1.position.y + 50)
	add_child(treasure)
	
	$room2_2.prev_rooms.append($room2)
	$room2_2.next_rooms.append($room2_2_1)
	
	$room2_1_1.prev_rooms.append($room2_1)
	$room2_1_1.next_rooms.append($room3)
	
	$room2_2_1.prev_rooms.append($room2_2)
	$room2_2_1.next_rooms.append($room3)
	
	$room3.prev_rooms.append($room2_1_1)
	$room3.prev_rooms.append($room2_2_1)
	
	print($room1_1.get_node("HeroPosition").position)
	$party.start()
	$party.move_to_room($room)
	
	var goblin = goblin_spawner.instantiate()
	goblin.move_to_room($room1_1)
	add_child(goblin)
	
	var goblin2 = goblin_spawner.instantiate()
	goblin2.move_to_room($room2)
	add_child(goblin2)
	
	var goblin3 = goblin_spawner.instantiate()
	goblin3.move_to_room($room2_1_1)
	add_child(goblin3)
	
	turn = 0
	active_player = turn % 2
	moves_left = 3
	game_over = false
	
	$Player.start($room3)
	print("player is active")
	$HUD.on_player_turn_start()
	$HUD.get_node("ButtonGoblin").pressed.connect(on_begin_purchase_goblin)
	$HUD.get_node("ButtonOgre").pressed.connect(on_begin_purchase_ogre)
	$HUD.get_node("ButtonSlasher").pressed.connect(on_begin_purchase_slasher)
	$HUD.get_node("ButtonX").pressed.connect(on_cancel_purchase)
	

func on_use_move(amount):
	moves_left -= amount
	moves_changed.emit()
	if moves_left <= 0:
		_on_next_turn()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("end_turn_restart"):
		if active_player == 0 and $Player.health > 0 and cooldown:
			moves_left = 0
			on_use_move(0)
			cooldown = false
		elif game_over:
			start()
			cooldown = false


func _on_room_send_to_room(room):
	on_use_move(1)

func _on_next_turn():
	print("SWITCH ACTIVE TEAM")
	if game_over: return
	if active_player < 1:
		#player's turn ends
		$Player.is_turn = false
		$PartyTimer.start()
		moves_left = 3
		heroes_turn.emit()
	else:
		$Player.is_turn = true
		$PartyTimer.stop()
		moves_left = 3
		next_turn.emit()
		var gold_yield = 0
		for room in get_tree().get_nodes_in_group("rooms"):
			if room.has_treasure:
				if room.has_party and room.num_monsters < 1:
					room.treasure.queue_free()
					room.has_treasure = false
					received_message.emit("HEROES have cleared a room of treasure!")
				elif room.has_party and room.num_monsters > 0:
					gold_yield += 25
				elif not room.has_party:
					gold_yield += 50 
			if not room.has_party:
				gold_yield += 10 * room.num_monsters
		
		$Player.gold += gold_yield
		gold_changed.emit()
		
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

func on_begin_purchase_goblin():
	var rooms = get_rooms_open()
	for room in rooms:
		room.on_gain_focus()
		room.send_to_room.connect(on_purchase_goblin)
		
	$HUD.get_node("ButtonX").show()
	$HUD.get_node("CancelLabel").show()
	$HUD.disable_buy($HUD.get_node("ButtonGoblin"))
	$HUD.disable_buy($HUD.get_node("ButtonSlasher"))
	$HUD.disable_buy($HUD.get_node("ButtonOgre"))

func on_purchase_goblin(room):
	$Player.gold -= $HUD.goblin_cost
	gold_changed.emit()
	
	var mob = goblin_spawner.instantiate()
	mob.move_to_room(room)
	mob.on_lose_focus()
	add_child(mob)
	
	for r in get_tree().get_nodes_in_group("rooms"):
		r.send_to_room.disconnect(on_purchase_goblin)
		r.on_lose_focus()
	
	$HUD.get_node("ButtonX").hide()
	$HUD.get_node("CancelLabel").hide()
	$HUD.on_update_gold()
	
	
	
	
func on_begin_purchase_ogre():
	var rooms = get_rooms_open()
	for room in rooms:
		room.on_gain_focus()
		room.send_to_room.connect(on_purchase_ogre)
		
	$HUD.get_node("ButtonX").show()
	$HUD.get_node("CancelLabel").show()
	$HUD.disable_buy($HUD.get_node("ButtonGoblin"))
	$HUD.disable_buy($HUD.get_node("ButtonSlasher"))
	$HUD.disable_buy($HUD.get_node("ButtonOgre"))

func on_purchase_ogre(room):
	$Player.gold -= $HUD.ogre_cost
	gold_changed.emit()
	
	var mob = ogre_spawner.instantiate()
	mob.move_to_room(room)
	mob.on_lose_focus()
	add_child(mob)
	
	for r in get_tree().get_nodes_in_group("rooms"):
		r.send_to_room.disconnect(on_purchase_ogre)
		r.on_lose_focus()
	
	$HUD.get_node("ButtonX").hide()
	$HUD.get_node("CancelLabel").hide()
	$HUD.on_update_gold()





func on_begin_purchase_slasher():
	var rooms = get_rooms_open()
	for room in rooms:
		room.on_gain_focus()
		room.send_to_room.connect(on_purchase_slasher)
		
	$HUD.get_node("ButtonX").show()
	$HUD.get_node("CancelLabel").show()
	$HUD.disable_buy($HUD.get_node("ButtonGoblin"))
	$HUD.disable_buy($HUD.get_node("ButtonSlasher"))
	$HUD.disable_buy($HUD.get_node("ButtonOgre"))

func on_purchase_slasher(room):
	$Player.gold -= $HUD.slasher_cost
	gold_changed.emit()
	
	var mob = slasher_spawner.instantiate()
	mob.move_to_room(room)
	mob.on_lose_focus()
	add_child(mob)
	
	for r in get_tree().get_nodes_in_group("rooms"):
		r.send_to_room.disconnect(on_purchase_slasher)
		r.on_lose_focus()
	
	$HUD.get_node("ButtonX").hide()
	$HUD.get_node("CancelLabel").hide()
	$HUD.on_update_gold()
	
	
func on_cancel_purchase():
	for r in get_tree().get_nodes_in_group("rooms"):
		r.send_to_room.disconnect(on_purchase_goblin)
		r.on_lose_focus()
	
	$HUD.get_node("ButtonX").hide()
	$HUD.get_node("CancelLabel").hide()
	$HUD.on_update_gold()
	
	get_tree().call_group("monsters", "on_lose_focus")
		
	
func stop_game():
	$PartyTimer.stop()
	$HUD.on_player_turn_end()
	$HUD.get_node("TurnHeroes").hide()
	$HUD.get_node("TurnMonsters").hide()
	get_tree().call_group("monsters", "queue_free")
	game_over = true

func _on_player_dead():
	received_message.emit("You LOSE!!!\nPress ENTER to play again")
	stop_game()


func _on_party_defeated():
	received_message.emit("You WIN!!!\nPress ENTER  to play again")
	stop_game()
	


func _on_timer_timeout():
	cooldown = true
