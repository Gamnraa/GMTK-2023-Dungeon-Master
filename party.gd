extends Area2D

var total_members
var alive_members
var moves_left = 0
var in_combat
var curr_room
var active = false
var selectable = false

signal perform_action(moves)
signal defeated

func move_to_room(room):
	if curr_room:
		curr_room.has_party = false
		
	curr_room = room
	curr_room.has_party = true
	var offset_x = room.get_node("HeroPosition").position.x
	var offset_y = room.get_node("HeroPosition").position.y
	position = Vector2(room.position.x + offset_x, room.position.y + offset_y)
	if room.has_treasure and room.has_party and room.num_monsters < 1:
		room.has_treasure = false
		room.treasure.queue_free()
		Global.TheDungeon.received_message.emit("HEROES have cleared a room of treasure!")

func heal_or_revive():
	print("heal_or_revive")
	if moves_left >= 2 and alive_members.size() < total_members:
		if $cleric.is_dead:
			$cleric.action_revive.emit()
			perform_action.emit(2)
			moves_left -= 2
			return
		elif $paladin.is_dead:
			$paladin.action_revive.emit()
			perform_action.emit(2)
			moves_left -= 2
			return
		elif $man_at_arms.is_dead:
			$man_at_arms.action_revive.emit()
			perform_action.emit(2)
			moves_left -= 2
			return
	var needs_heal = []
	for hero in alive_members:
		if hero.health < hero.MAX_HEALTH:
			needs_heal.append(hero)
	var target = randi() % needs_heal.size()
	print("heal ", needs_heal[target])
	needs_heal[target].action_heal.emit(needs_heal[target])
	perform_action.emit(1)
	moves_left -= 1

func get_actions():
	var num_members_alive = alive_members.size()
		
	in_combat = curr_room.num_monsters > 0
	var revive_weight = total_members - num_members_alive * 20
	#we'll code this logic later. Most of this will likely change
	print("perform action")
	var heal_weight = 0
	for hero in alive_members:
		print(hero)
		if hero == $cleric:
			heal_weight+= (hero.hero.MAX_HEALTH - hero.health)
		else:	
			heal_weight += (hero.MAX_HEALTH - hero.health)
		
	print(heal_weight)
	if not in_combat:
		
		var wants_to_move = heal_weight < randi() % 31 + 50
		if wants_to_move:
			var destination = randi() % curr_room.next_rooms.size()
			move_to_room(curr_room.next_rooms[destination])
			perform_action.emit(1)
			moves_left -= 1
		else:
			heal_or_revive()
	else:
		var wants_to_attack = heal_weight < (randi() % 101 + 50) / num_members_alive
		if wants_to_attack:
			var target = randi() % curr_room.num_monsters
			var attacker = randi() %  num_members_alive
			print(alive_members[attacker], "attack", curr_room.monsters[target])
			alive_members[attacker].action_attack.emit(curr_room.monsters[target])
			perform_action.emit(1)
			moves_left -= 1
		else:
			heal_or_revive()
			
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.TheParty = self
	
func start():
	alive_members = [$man_at_arms, $paladin, $cleric]
	total_members = alive_members.size()
	for hero in alive_members: hero.start()
	$AttackIndicator.hide()
	$AttackHighlight.hide()
	$AttackLabel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_party_member_dead(member):
	member.is_dead = true
	alive_members.erase(member)
	if alive_members.size() < 1: defeated.emit()

func _on_man_at_arms_dead():
	$man_at_arms.is_dead = true
	alive_members.erase($man_at_arms)
	if alive_members.size() < 1: defeated.emit()

func _on_paladin_dead():
	$paladin.is_dead = true
	alive_members.erase($paladin)
	if alive_members.size() < 1: defeated.emit()

func _on_cleric_dead():
	$cleric.is_dead = true
	alive_members.erase($cleric)
	if alive_members.size() < 1: defeated.emit()


func _on_mouse_entered():
	if active: selectable = true
	if $AttackIndicator.visible: 
		$AttackHighlight.show()
		$AttackLabel.show()



func _on_mouse_exited():
	selectable = false
	$AttackHighlight.hide()
	$AttackLabel.hide()

func on_attacked(attacker):
	var target = randi() % alive_members.size()
	attacker.action_attack.emit(alive_members[target])
	active = false
	$AttackIndicator.hide()
	$AttackHighlight.hide()
	$AttackLabel.hide()
	perform_action.emit(1)
