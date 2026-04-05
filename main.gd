extends Node

@export_category("Game Config")
@export var prueba: int

@export_category("Scenes")
@export var mob_scene: PackedScene
@export var coin_scene: PackedScene


var score
var monedas

func game_over():
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CoinTimer.stop()
	$Music.stop()
	$HUD.show_game_over()

func new_game():
	var player = get_node("Player")
	player.coinpicked.connect(_on_player_coinpicked)
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	$Music.play()
	score = 0
	monedas = 0
	$Player.start($StartPosition.position)
	$Player.set_process(true)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD.update_coins(monedas)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$CoinTimer.start()
	var screenSize = get_viewport().get_visible_rect().size
	
func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
func _ready():
	#new_game()
	pass


func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)
	coin.position = Vector2(rndX, rndY)
	add_child(coin)

func _on_player_coinpicked(_moneda):
	$CoinPickedSound.play()
	monedas += 1
	$HUD.update_coins(monedas)
	_moneda.free()
	
