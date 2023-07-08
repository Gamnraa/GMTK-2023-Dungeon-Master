extends Node2D

var alive_members
var moves_left = 0
var in_combat
var curr_room

signal perform_action(moves)

func move_to_room(room):
	if curr_room:
		curr_room.has_party = false
		
	curr_room = room
	curr_room.has_party = true
	var offset_x = room.get_node("HeroPosition").position.x
	var offset_y = room.get_node("HeroPosition").position.y
	position = Vector2(room.position.x + offset_x, room.position.y + offset_y)

func get_actions():
	in_combat = curr_room.num_monsters > 0
	var revive_weight = get_children().size() - alive_members.size() * 20
	#we'll code this logic later. Most of this will likely change
	print("perform action")
	if not in_combat:
		var heal_weight = 0
		for hero in alive_members:
			heal_weight += (hero.MAX_HEALTH - hero.health)
		var wants_to_move = heal_weight < randi() % 51 + 50
		if wants_to_move:
			
			var destination = randi() % 1
			move_to_room(curr_room.next_rooms[destination])
			perform_action.emit(1)
			moves_left -= 1
	else:
		$cleric.action_revive.emit()
		moves_left -= 1
# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	
func start():
	alive_members = []
	#This is fine so long the only children of this node are our chars
	for child in get_children():
		child.start()
		alive_members.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_man_at_arms_dead():
	$man_at_arms.is_dead = true
	alive_members.erase($man_at_arms)

func _on_paladin_dead():
	$paladin.is_dead = true
	alive_members.erase($paladin)

func _on_cleric_dead():
	$cleric.is_dead = true
	alive_members.erase($cleric)
