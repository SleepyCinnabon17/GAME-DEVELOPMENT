extends TextureButton

@export var MyScrollContainer: ScrollContainer
var allcontainers

# Called when the node enters the scene tree for the first time.
#automatically sets up a signal to listen for the button being pressed
func _ready() -> void:
	self.pressed.connect(_button_pressed)
	allcontainers = MyScrollContainer.get_parent()

func _button_pressed() -> void:
	changetabs()
	
func changetabs() -> void:
		for item in allcontainers.get_children():
			item.hide()
		MyScrollContainer.show()
