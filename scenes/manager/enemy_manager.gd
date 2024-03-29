extends Node

const SPAWN_RADIUS = 360 # slightly more than half the window width

@export var basic_enemy_scene: PackedScene
@export var little_ghost_enemy_scene: PackedScene
@onready var arena_time_manager = $"../ArenaTimeManager"


@onready var timer = $Timer

var base_spawn_time = 1
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		pass
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min (time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off

	if arena_difficulty == 12:
		enemy_table.add_item(little_ghost_enemy_scene, 30)
		enemy_table.change_weight(basic_enemy_scene, 0)
	
	if arena_difficulty == 24:
		enemy_table.change_weight(basic_enemy_scene, 20)
	
