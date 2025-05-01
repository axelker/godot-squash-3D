class_name UserInterface
extends Control

@onready var score_label: Label = $Header/Score;
@onready var retry_pannel : ColorRect = $Retry;

signal retry;

var score = 0

func _ready() -> void:
	update_score_label();
	retry_pannel.hide();

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and retry_pannel.visible:
		retry.emit();

func update_score():
	score +=1;
	update_score_label();

func update_score_label():
	score_label.text = "Score: " + str(score);
	
