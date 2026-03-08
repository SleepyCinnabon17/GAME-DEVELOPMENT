extends Node

var themes := [
	"Trendy",
	"Pastel",
	"Summer"
]

var current_theme := ""

func pick_theme() -> String:
	# Only pick a theme ONCE
	if current_theme == "":
		current_theme = themes.pick_random()
	return current_theme

func reset_theme() -> void:
	# Optional: call this if you ever want a new round
	current_theme = ""
