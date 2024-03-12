extends Node

@export var axe_ability_scene: PackedScene
@export var base_damage:float = 10
@export var damage_upgrade_percent:float = 10

var additional_damage_percent = 1.0
var base_wait_time

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	base_wait_time = $Timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
		
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = pow(1 + damage_upgrade_percent*0.01,current_upgrades["axe_damage"]["quantity"])
	if upgrade.id == "axe_rate":
		var percent_reduction = pow(0.9, current_upgrades["axe_rate"]["quantity"])
		$Timer.wait_time = base_wait_time * percent_reduction
		$Timer.start()
