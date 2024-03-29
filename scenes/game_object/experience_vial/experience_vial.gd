extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
var id = "experience_vial"

func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position = start_position.lerp(player.global_position, percent)


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_callback(collect)
	$RandomStreamPlayer2dComponent.play_random()

