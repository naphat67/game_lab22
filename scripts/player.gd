extends Area2D

@export var speed := 310.0
var screen_size := Vector2(480, 720)

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += direction * speed * delta
	position.x = clampf(position.x, 28.0, screen_size.x - 28.0)
	position.y = clampf(position.y, 80.0, screen_size.y - 34.0)
