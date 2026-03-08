extends Control

var allitems: Array
## Everything here will cycle through when the body button is clicked you can add multiple if necessary
@export var base: Sprite2D
@export var ScreenshotRect: ReferenceRect
var uiHidden: bool = true

#resets the positions of all unequipped items
func cleanup() -> void:
	for item in allitems:
		if item.equipped == false:
			if item.optional_Panel == null:
				item.resetpos()

#fully resets each item in the game
func reset() -> void:
	for item in allitems:
		if item.optional_Panel == null:
			item.resetpos()
		else:
			item.reparent(item.world)
			item.position = item.originalpos

func _on_clean_up_button_pressed() -> void:
	cleanup()
	


func _on_reset_button_pressed() -> void:
	reset()
	


func _on_body_button_pressed() -> void:
	base.switch()





func _on_hide_ui_button_toggled(toggled_on: bool) -> void:
	$BgColor2.visible = !toggled_on
	$Containers.visible = !toggled_on
	$Tabs.visible = !toggled_on
	$MenuButtons/ResetButton.visible = !toggled_on
	$MenuButtons/CleanUpButton.visible = !toggled_on
	$MenuButtons/BodyButton.visible = !toggled_on
	uiHidden = !toggled_on

func _on_download_button_pressed() -> void:
	
	#hide everyhing for sure for the screenshot
	$BgColor2.visible = false
	$Containers.visible = false
	$Tabs.visible = false
	$MenuButtons/ResetButton.visible = false
	$MenuButtons/CleanUpButton.visible = false
	$MenuButtons/BodyButton.visible = false
	$MenuButtons/DownloadButton.visible = false
	$MenuButtons/HideUIButton.visible = false
	
	#wait a moment
	await get_tree().create_timer(0.5).timeout
	#Take the screenshot
	var region = Rect2(ScreenshotRect.position.x,ScreenshotRect.position.y,ScreenshotRect.size.x,ScreenshotRect.size.y)
	var img = get_viewport().get_texture().get_image().get_region(region)
	
	var base_path = "user://"
	var final_path = base_path + "Screenshot" + ".png"
	
	#Checks to see if game is running on web or on computer
	match OS.get_name():
		"Web":
			#downloads screenshot web or PC
			var buffer := img.save_png_to_buffer()
			JavaScriptBridge.download_buffer(buffer, "Screenshot.png", "image/png")
		"Windows","macOS","Linux":
			if FileAccess.file_exists(final_path):
				var file_index = 1
				while FileAccess.file_exists(base_path + "Screenshot" + str(file_index) + ".png"):
					file_index += 1
				final_path = base_path + "Screenshot" + str(file_index) + ".png"
			img.save_png(final_path)
			OS.shell_open(OS.get_user_data_dir())
		
	
	#bring back everything to how it was
	$BgColor2.visible = uiHidden
	$Containers.visible = uiHidden
	$Tabs.visible = uiHidden
	$MenuButtons/ResetButton.visible = uiHidden
	$MenuButtons/CleanUpButton.visible = uiHidden
	$MenuButtons/BodyButton.visible = uiHidden
	$MenuButtons/DownloadButton.visible = true
	$MenuButtons/HideUIButton.visible = true


func _on_theme_button_pressed():
	var theme = $ThemeManager.pick_theme()
	$ThemeLabel.text = "Theme: " + theme

	var score = calculate_score()
	print("SCORE:", score)

	$ScoreHeart/ScoreLabel.text = str(score) + "%"
	
#Doesnt work, let's check again later?
	if score >= 80:
		$ScoreHeart/ScoreLabel.modulate = Color(0.2, 0.8, 0.4) # green
	elif score >= 50:
		$ScoreHeart/ScoreLabel.modulate = Color(1.0, 0.85, 0.3) # yellow
	else:
		$ScoreHeart/ScoreLabel.modulate = Color(0.9, 0.3, 0.3) # red



func calculate_score() -> int:
	var current_theme = $ThemeManager.current_theme
	var total_items := 0
	var matching_items := 0

	for item in get_tree().get_nodes_in_group("Clothes"):
		if item.equipped:
			total_items += 1
			if current_theme in item.themes:
				matching_items += 1

	if total_items == 0:
		return 0

	return int((matching_items / float(total_items)) * 100)



	for item in get_tree().get_nodes_in_group("Clothes"):
		if item.visible:
			total_items += 1
			if current_theme in item.themes:
				matching_items += 1

	if total_items == 0:
		return 0

	return int((matching_items / float(total_items)) * 100)
