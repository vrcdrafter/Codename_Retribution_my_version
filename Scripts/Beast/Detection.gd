extends Node
class_name Detection

var rays : Array[RayCast3D]
var stuckRays : Array[RayCast3D]
@export var areaFar : Area3D
var beast : Beast
var player : Player

var player_is_around : bool = false


func _ready():
	beast = Global._get_beast()
	player = Global._get_player()
	areaFar.connect("body_entered", body_entered_far)
	areaFar.connect("body_exited", body_exited_far)

	for child in $Head.get_children():
		if child is RayCast3D:
			rays.append(child)

	for child in $StuckRays.get_children():
		if child is RayCast3D:
			stuckRays.append(child)

func _physics_process(delta):
	checkRays()


func checkStuck():
	for ray in stuckRays:
		if ray.is_colliding():
			beast.seeingPlayer = false
			beast.nav.set_velocity(Vector3.ZERO)
			return true
		else:
			return false

func checkRays() -> bool:	
	for ray in rays:
		if ray.is_colliding():
			var col = ray.get_collider()
			if col is Player:
				beast.seeingPlayer = true
				beast.nav.target_position = col.global_transform.origin
				return true
	
	return false

func LoudSoundEmitted(obj):
	if player_is_around:
		beast.nav.target_position = obj.global_transform.origin
		beast.stateMachine.current_state.Transitioned.emit(beast.stateMachine.current_state, "Chase")

func body_entered_far(body):
	if body is Player:
		player_is_around = true

func body_exited_far(body):
	if body is Player:
		player_is_around = false
