# ui.gd
extends Control

# References to the label nodes
@onready var level_label = $MarginContainer/Panel/VBoxContainer/LevelLabel
@onready var deaths_label = $MarginContainer/Panel/VBoxContainer/DeathsLabel
@onready var time_label = $MarginContainer/Panel/VBoxContainer/TimeLabel
@onready var checkpoint_label = $MarginContainer/Panel/VBoxContainer/CheckpointLabel
@onready var diamonds_label = $MarginContainer/Panel/VBoxContainer/DiamondsLabel
@onready var score_label: Label = $MarginContainer/Panel/VBoxContainer/ScoreLabel
@onready var modifier_label: Label = $MarginContainer/Panel/VBoxContainer/ModifierLabel

func _ready():
	# Initial update
	update_ui()
	
func _process(delta):
	# Update time
	StatsManager.time += delta
	update_ui()
	
func update_ui():
	# Update all labels with current values from StatsManager
	level_label.text = "LEVEL: " + str(StatsManager.level)
	deaths_label.text = "DEATHS: " + str(StatsManager.player_deaths)
	score_label.text = "SCORE: " + str(StatsManager.score)
	modifier_label.text = "MODIFIER: " + str(StatsManager.modifier)
	
	# Format time as minutes:seconds
	var minutes = int(StatsManager.time / 60)
	var seconds = int(StatsManager.time) % 60
	time_label.text = "TIME: %02d:%02d" % [minutes, seconds]
	
	# Show current checkpoint out of total checkpoints
	checkpoint_label.text = "CHECKPOINT: %d/%d" % [StatsManager.current_checkpoint, StatsManager.total_checkpoints]
	
	# Show current diamonds out of total diamonds
	diamonds_label.text = "DIAMONDS: %d/%d" % [StatsManager.current_diamonds, StatsManager.total_diamonds]
