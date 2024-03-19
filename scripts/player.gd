extends CharacterBody2D

const movement_duration : float = 0.2
const grid_size : int = 16
const buffered_movement_frames : int = 10

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area : Area2D = $InteractionArea

var movement_tween : Tween
var look_direction : Vector2
var buffered_movement : Vector2
var buffered_frame : int

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	update_interaction_area()
	handle_movement()
	handle_interaction()

func handle_movement():
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	direction.y = 0.0 if direction.x else direction.y
	direction = direction.normalized()
	if direction:
		if not movement_tween or not movement_tween.is_running():
			if look_direction == direction and not interaction_area.has_overlapping_bodies():
				movement_tween = create_tween()
				movement_tween.tween_property(self, "position", position + direction * grid_size, movement_duration)
			else:
				movement_tween = create_tween()
				movement_tween.tween_interval(0.05)
			update_sprite(direction)
		else:
			buffered_movement = direction
			buffered_frame = buffered_movement_frames
	elif buffered_movement:
		buffered_frame -= 1
		pass

func update_sprite(direction : Vector2):
	look_direction = direction
	if direction.x < 0:
		sprite.animation = "idle_left"
	elif direction.x > 0:
		sprite.animation = "idle_right"
	elif direction.y < 0:
		sprite.animation = "idle_up"
	elif direction.y > 0:
		sprite.animation = "idle_down"

func update_interaction_area():
	interaction_area.global_position = global_position + look_direction * grid_size

func handle_interaction():
	if Input.is_action_just_pressed("select"):
		var areas : Array[Area2D] = interaction_area.get_overlapping_areas()
		print("Found %d areas to interact with." % [len(areas)])
		var bodies : Array[Node2D] = interaction_area.get_overlapping_bodies()
		print("Found %d bodies to interact with." % [len(bodies)])
		for body in bodies:
			print(body.name)
