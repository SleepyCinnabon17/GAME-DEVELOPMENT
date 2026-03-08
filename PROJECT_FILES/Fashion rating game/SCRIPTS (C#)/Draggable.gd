extends TextureButton

# themes this item belongs to (used by % calculator)
@export var themes: Array[String] = []

# state
var equipped: bool = false
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

# references
var world: Control
var mypanel
var originalpos: Vector2 = Vector2.ZERO

@export var optional_Panel: Panel

# x-position threshold:
# left of this = worn
# right of this = wardrobe
var wardrobe_edge := 545


func _ready() -> void:
	# determine which panel this item belongs to
	if optional_Panel == null:
		mypanel = get_parent()
	else:
		mypanel = optional_Panel

	originalpos = position
	world = owner

	# ensure the calculator can find this item
	if not is_in_group("Clothes"):
		add_to_group("Clothes")



func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - offset


func resetpos() -> void:
	reparent(mypanel)
	position = originalpos
	equipped = false


func _on_button_down() -> void:
	self.reparent(world)
	self.move_to_front()
	dragging = true
	offset = get_global_mouse_position() - global_position

	equipped = true  # 👈 ADD THIS LINE



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_released("click"):
		dragging = false

		if global_position.x < wardrobe_edge:
			# item is worn
			equipped = true
			reparent(world)
		else:
			# item is back in wardrobe
			equipped = false
			reparent(mypanel)
