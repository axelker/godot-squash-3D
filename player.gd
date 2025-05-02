extends CharacterBody3D

@onready var animation_player : AnimationPlayer = $AnimationPlayer;


const SPEED = 14;
const JUMP_VELOCITY = 20;
const FALL_ACCELERATION = 75;
@export var bounce_impulse = 16

signal hit;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$Pivot.basis = Basis.looking_at(direction)
		animation_player.speed_scale = 4

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_player.speed_scale = 1

	handle_collision(get_last_slide_collision());
	move_and_slide()
	

func handle_collision(collision:KinematicCollision3D):
	if collision == null:
		return;
	var collider = collision.get_collider();
	
	if collider == null:
		return;

	if collider.is_in_group("ennemies") and Vector3.UP.dot(collision.get_normal()) > 0.1:
		var mob = collision.get_collider();
		mob.squash()
		velocity.y = bounce_impulse

func die():
	hit.emit();
	queue_free();

func _on_mob_detection_body_entered(_body: Node3D) -> void:
	die();
