extends KinematicBody


const MOVE_SPEED = 4
const MOUSE_SENS = 0.1

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	# No comando acima, estamos chamando a função set_player, de todos que
	# estão no grupo 'zombies', passando como parâmetro o self
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()

func _physics_process(delta):
	var move_vector:Vector3 = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vector.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vector.z += 1
	if Input.is_action_pressed("move_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vector.x += 1
	move_vector = move_vector.normalized()
	move_vector = move_vector.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vector * MOVE_SPEED * delta)
		
	if Input.is_action_pressed("shoot") and not anim_player.is_playing():
		anim_player.play("shoot")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
		
func kill():
	get_tree().reload_current_scene()
