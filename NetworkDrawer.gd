extends Control

export (Font) var minefont #load("res://minecraft-font/MinecraftRegular-Bmg3.otf")

var show_n_values = true


func _draw():
	"""Loops through every neuron and draws it along with it's input connections.
	"""
	#yield(get_tree().create_timer(2.0), "timeout")
	# get the required information from it's owner (a GenomeDetail)
	#var depth = owner.inspected_genome.agent.network.depth
	
	if owner.inspected_genome == null or owner.inspected_genome.is_dead:
		$value_sw.visible = false
		$agent_v.visible = false
		return
	$value_sw.visible = true
	$agent_v.visible = true
	var neurons_dict = owner.inspected_genome.network.all_neurons
	for neuron_id in neurons_dict.keys():
		# determine the position of the neuron on the canvas and it's color
		var neuron = neurons_dict[neuron_id]
		var draw_pos = neuron.position * rect_size + Vector2(0, 0)
		if neuron.neuron_type == 3:
			draw_pos = neuron.position * rect_size + Vector2(-20, 0)
		var draw_col = Params.neuron_colors[neuron.neuron_type]
		# first draw all links connecting to the neuron
		for link in neuron.input_connections:
			# color strength is determined by how strong weight relative to wmc
			var w_col = Color(1, 1, 1, 1)
			var wmc = Params.weight_max_color
			var w_col_str = (wmc - min(abs(link[1]), wmc)) / wmc
			# color red by decreasing green and blue
			if link[1] >= 0:
				w_col.g = w_col_str; w_col.b = w_col_str
			# color blue by decreasing red and green
			elif link[1] <= 0:
				w_col.r = w_col_str; w_col.g = w_col_str
			# draw links as tris to indicate their firing direction
			var in_pos = link[0].position * rect_size + Vector2(0, 30)
			var spacing = Vector2(0, 5)
			var tri_points = PoolVector2Array([in_pos, draw_pos])
			var colors = PoolColorArray([w_col, Color.red])
			draw_primitive(tri_points, colors, tri_points)
		# finally draw the neuron last, so it overlaps all the links
		draw_circle(draw_pos, 6, draw_col)
		if show_n_values:
			draw_string(minefont, draw_pos + Vector2(-5, minefont.size / 2-2), str(neuron.output), Color.black)
		# mark if a loop link is connected to the neuron
	$agent_v.set_text("body speed: " + str(owner.inspected_genome.body.v))


func _on_value_sw_toggled(button_pressed):
	show_n_values = button_pressed
