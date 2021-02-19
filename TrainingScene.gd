extends Node2D

var fps_count
var score = 0
var max_speed
var highscore = score
var algoritm_ds = 0
var agent_path = "res://Player/Player.tscn"
var ga = GeneticAlgorithm.new(7, 2, agent_path, false, "player_params")
var inspected_genome = null


func _ready():
	max_speed = int($LineEdit.get_text())
	add_child(ga)
	place_bodies(ga.get_curr_bodies())
#	PlayerSpawn.add_child(load(agent_path).instance())



func _process(delta):
	fps_count = Engine.get_frames_per_second()
	$fps_label.set_text(str(fps_count))
	if fps_count < 30:
		$fps_label.add_color_override("font_color", Color(1,0,0,1))
	elif OS.vsync_enabled == true and (fps_count < 57 or fps_count > 62):
		$fps_label.add_color_override("font_color", Color(1,0,0,1))
	else:
		$fps_label.add_color_override("font_color", Color(0,1,0,1))
	var alive_g_c = 0
	for i in ga.get_curr_bodies():
		alive_g_c += 1
	$Child_count.text = str(alive_g_c) + " agents left alive\nAlgorithm died " + str(algoritm_ds) + " times"
	$OtherData.set_text("highscore: " + str(highscore) + "\ngen " + str(ga.curr_generation))





func _physics_process(delta):
	$Network_im.update()
	ga.next_timestep()
	if ga.all_agents_dead or Input.is_action_just_pressed("burn_all_down"):
		ga.evaluate_generation()
		ga.next_generation()
		reset_score()
		place_bodies(ga.get_curr_bodies())
		print("PlayerSpawn child c: ", $PlayerSpawn.get_child_count())
		print("Number of curr bodies by ga: ", str(len(ga.get_curr_bodies())) , "\n")



func place_bodies(bodies: Array) -> void:
	# remove the bodies from the last generation
	for last_gen_body in $PlayerSpawn.get_children():
		if last_gen_body.name in ["AlgorithmPlayer", "RealPlayer"]:
			pass
		else:
			last_gen_body.queue_free()
	for body in bodies:
		$PlayerSpawn.add_child(body)
		body.get_node("Clickable").connect("clicked", self, "onagentclicked")
		
	reset_score()



func update_score(new_score):
	new_score = round(new_score)
	if new_score > score:
		score = new_score
		if score > highscore:
			highscore = score
		$"ScoreLabel".set_text(str(score))
	if new_score > 27:
		$"RaceTrack1/finish_cp/CollisionShape2D".set_deferred("disabled", false)


func reset_score():
	score = 0
	$"ScoreLabel".set_text(str(score))
	$"RaceTrack1/finish_cp/CollisionShape2D".set_deferred("disabled", true)




func onagentclicked(body):
	for ch_agent in ga.curr_agents:
		if ch_agent.body == body:
			print(str(ch_agent), " is owner of this agent")
			inspected_genome = ch_agent
			ch_agent.enable_highlight(true)
		else:
			ch_agent.enable_highlight(false)
	



func _on_LineEdit_text_entered(new_text):
	max_speed = int(new_text)


func _on_AlgorithmPlayer_death():
	algoritm_ds += 1


func _on_hide_al_toggled(button_pressed):
	$PlayerSpawn/AlgorithmPlayer.visible = button_pressed
	$PlayerSpawn/AlgorithmPlayer.set_physics_process(button_pressed)
	$PlayerSpawn/AlgorithmPlayer.set_process(button_pressed)


func _on_hide_pl_toggled(button_pressed):
	$rPlayerSpawn/RealPlayer.visible = button_pressed
	$rPlayerSpawn/RealPlayer.set_physics_process(button_pressed)
	$rPlayerSpawn/RealPlayer.set_process(button_pressed)

func _on_hide_casts_toggled(button_pressed):
	$rPlayerSpawn/RealPlayer/Ray_dots.visible = button_pressed
	$PlayerSpawn/AlgorithmPlayer/Ray_dots.visible = button_pressed
	for car in $PlayerSpawn.get_children():
		car.get_node("Ray_dots").visible = button_pressed
