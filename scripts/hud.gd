extends Node
signal start_game

var info: Label
var score_label: Label
var start_button: Button
var card: PanelContainer

func _ready() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	score_label = Label.new()
	score_label.position = Vector2(14, 14)
	score_label.add_theme_font_size_override("font_size", 20)
	score_label.add_theme_color_override("font_color", Color("fff1a8"))
	root.add_child(score_label)
	var student := Label.new()
	student.text = "673380076-1  นายณภัทร โสดาดง"
	student.position = Vector2(14, 43)
	student.add_theme_font_size_override("font_size", 13)
	student.add_theme_color_override("font_color", Color("dce7f8"))
	root.add_child(student)
	card = PanelContainer.new()
	card.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	card.position = Vector2(-195, -150)
	card.custom_minimum_size = Vector2(390, 300)
	root.add_child(card)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	card.add_child(box)
	var title := Label.new()
	title.text = "DODGE THE CREEPS!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color("ffe8a3"))
	box.add_child(title)
	info = Label.new()
	info.text = "Move with arrow keys or WASD.\nAvoid the creeps for as long as you can.\n\nA first 2D game · Game 22"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.add_theme_font_size_override("font_size", 16)
	info.add_theme_color_override("font_color", Color("e1eafa"))
	box.add_child(info)
	start_button = Button.new()
	start_button.text = "Start Game"
	start_button.custom_minimum_size = Vector2(150, 46)
	start_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	start_button.pressed.connect(_on_start_pressed)
	box.add_child(start_button)
	set_score(0)

func set_score(value: int) -> void:
	if score_label:
		score_label.text = "SCORE  %03d" % value

func show_game_over(value: int) -> void:
	info.text = "Game over! You survived %d seconds.\n\nDodge the creeps and try again." % value
	start_button.text = "Play Again"
	card.show()

func _on_start_pressed() -> void:
	card.hide()
	start_game.emit()
