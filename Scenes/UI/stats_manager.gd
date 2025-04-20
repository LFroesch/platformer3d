#stats_manager.gd (autoload)
extends Node

var player_deaths: int = 0
var level: int = 1
var time: float = 0.0
var current_checkpoint: int = 0
var total_checkpoints: int = 0
var current_diamonds: int = 0
var total_diamonds: int = 0
var score: float = 0.0
var modifier: float = 1.0

func record_death() -> void:
	player_deaths += 1

func reset_stats() -> void:
	player_deaths = 0
	level = 1
	time = 0.0
	score = 0.0
	modifier = 1.0
	current_checkpoint = 0
	
func increase_level() -> void:
	level += 1

func increase_score(amount: float) -> void:
	score += amount * modifier

func increase_modifier(amount: float) -> void:
	modifier += amount

func set_checkpoint(checkpoint_number: int) -> void:
	current_checkpoint = checkpoint_number
	
func collect_diamond() -> void:
	current_diamonds += 1
	
func set_total_diamonds(total: int) -> void:
	total_diamonds = total
	
func reset_diamonds() -> void:
	current_diamonds = 0
