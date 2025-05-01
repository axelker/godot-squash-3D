class_name Mob
extends CharacterBody3D

signal squashed;
# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 15

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

func _ready() -> void:
	visible_on_screen_notifier.connect("screen_exited",_on_screen_exited);
	animation_player.speed_scale = randf_range(min_speed, max_speed)/ min_speed;

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player and straigth with Vector3.UP.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_screen_exited():
	queue_free();

func squash():
	squashed.emit()
	queue_free()
