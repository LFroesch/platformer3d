extends Node3D

@onready var score_label: Label3D = $Score
@onready var deaths_label: Label3D = $Deaths
@onready var time_label: Label3D = $Time

func _ready():
	# Initial update
	update_ui()
	
func update_ui():
	# Update all labels with current values from StatsManager
	deaths_label.text = "DEATHS: " + str(StatsManager.player_deaths)
	score_label.text = "SCORE: " + str(StatsManager.score)
	
	# Format time as minutes:seconds
	var minutes = int(StatsManager.time / 60)
	var seconds = int(StatsManager.time) % 60
	time_label.text = "TIME: %02d:%02d" % [minutes, seconds]
