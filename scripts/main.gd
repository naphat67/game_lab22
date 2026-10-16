extends Node2D

const PLAYER_SCENE := preload("res://Player.tscn")
const MOB_SCENE := preload("res://Mob.tscn")
const HUD_SCENE := preload("res://HUD.tscn")
var player: Area2D
var hud: Node
var mob_timer: Timer
var score_timer: Timer
var score := 0
var running := false

func _ready() -> void:
	randomize()
	configure_controls()
	make_background()
	make_title()
	player = PLAYER_SCENE.instantiate()
	player.position = Vector2(240, 600)
	player.area_entered.connect(_on_player_hit)
	add_child(player)
	player.hide()
	player.set_process(false)
	hud = HUD_SCENE.instantiate()
	add_child(hud)
	hud.start_game.connect(start_game)
	mob_timer = Timer.new()
	mob_timer.wait_time = 0.72
	mob_timer.timeout.connect(spawn_mob)
	add_child(mob_timer)
	score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.timeout.connect(_on_score_tick)
	add_child(score_timer)

func configure_controls() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	bind_key("move_left", KEY_A)
	bind_key("move_left", KEY_LEFT)
	bind_key("move_right", KEY_D)
	bind_key("move_right", KEY_RIGHT)
	bind_key("move_up", KEY_W)
	bind_key("move_up", KEY_UP)
	bind_key("move_down", KEY_S)
	bind_key("move_down", KEY_DOWN)

func bind_key(action: String, key: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = key
	if not InputMap.action_has_event(action, event):
		InputMap.action_add_event(action, event)

func make_background() -> void:
	var bg := ColorRect.new()
	bg.color = Color("18253c")
	bg.size = Vector2(480, 720)
	add_child(bg)
	move_child(bg, 0)
	for i in range(54):
		var star := ColorRect.new()
		star.color = Color(0.78, 0.87, 1.0, 0.38)
		star.size = Vector2(2, 2)
		star.position = Vector2(float((i * 89 + 19) % 480), float((i * 137 + 72) % 720))
		add_child(star)
		move_child(star, 1)
	var ground := ColorRect.new()
	ground.color = Color("263d52")
	ground.position = Vector2(0, 678)
	ground.size = Vector2(480, 42)
	add_child(ground)

func make_title() -> void:
	var title := Label.new()
	title.text = "YOUR FIRST 2D GAME · GAME 22"
	title.position = Vector2(30, 80)
	title.add_theme_font_size_override("font_size", 19)
	title.add_theme_color_override("font_color", Color("9af1dd"))
	add_child(title)

func start_game() -> void:
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.queue_free()
	score = 0
	hud.set_score(score)
	running = true
	player.position = Vector2(240, 600)
	player.show()
	player.set_process(true)
	player.set_deferred("monitoring", true)
	mob_timer.start()
	score_timer.start()

func spawn_mob() -> void:
	if not running:
		return
	var size := get_viewport_rect().size
	var side := randi_range(0, 3)
	var start := Vector2.ZERO
	match side:
		0: start = Vector2(randf_range(0, size.x), -40)
		1: start = Vector2(size.x + 40, randf_range(80, size.y))
		2: start = Vector2(randf_range(0, size.x), size.y + 40)
		3: start = Vector2(-40, randf_range(80, size.y))
	var mob: Area2D = MOB_SCENE.instantiate()
	mob.add_to_group("mobs")
	var target := player.position + Vector2(randf_range(-60, 60), randf_range(-60, 60))
	var direction := (target - start).normalized()
	mob.start(start, direction * randf_range(145.0, 225.0))
	add_child(mob)
	mob_timer.wait_time = maxf(0.28, 0.72 - float(score) * 0.008)

func _on_score_tick() -> void:
	if running:
		score += 1
		hud.set_score(score)

func _on_player_hit(_area: Area2D) -> void:
	if not running:
		return
	running = false
	mob_timer.stop()
	score_timer.stop()
	player.hide()
	player.set_process(false)
	hud.show_game_over(score)
