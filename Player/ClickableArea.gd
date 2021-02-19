extends Control

signal clicked(body)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#print(str(owner), " I've been clicked D:")
			emit_signal("clicked", owner)
