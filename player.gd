extends Area2D
@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
signal hit
signal coinpicked(moneda)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Menú pause
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().change_scene_to_file("res://pause.tscn")
		
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # El $ es igual a get_node(...) = get_node("AnimatedSprite2D").play().
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # clamp limita el movimiento al tamaño de la misma
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(_body):
	if _body.is_in_group("mobs"):
		hit.emit()
		set_process(false)
		for n in 3:
			hide() # Player disappears after being hit.
			await get_tree().create_timer(0.3).timeout
			show()
			await get_tree().create_timer(0.3).timeout
		hide()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred(&"disabled", true)
	elif _body.is_in_group("coins"):
		coinpicked.emit(_body)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false



