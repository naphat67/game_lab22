extends Area2D

var velocity := Vector2.ZERO

func start(at: Vector2, movement: Vector2) -> void:
	position = at
	velocity = movement
	rotation = velocity.angle()

func _process(delta: float) -> void:
	position += velocity * delta
	if not Rect2(Vector2(-100, -100), get_viewport_rect().size + Vector2(200, 200)).has_point(position):
		queue_free()
