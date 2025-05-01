extends Node

@onready var player= $Player;
@onready var mob_spawn_location: PathFollow3D = $SpawnPath/PathFollow3D;
@onready var mob_spawn_timer : Timer = $MobSpawnTimer;
@onready var user_interface: UserInterface =  $UserInterface;

@export var mob_scene: PackedScene

func _ready() -> void:
	user_interface.connect('retry', _on_retry);
	player.connect('hit',_on_player_hit);

func _on_mob_spawn_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate() as Mob
	mob.connect("squashed",on_mob_squashed);
	# Chose random location on spawn location.
	mob_spawn_location.progress_ratio = randf()
	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)



func _on_player_hit():
	mob_spawn_timer.stop();
	user_interface.retry_pannel.show();

func on_mob_squashed():
	user_interface.update_score();

func _on_retry():
	get_tree().reload_current_scene()
