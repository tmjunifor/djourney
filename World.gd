extends Spatial

var shoot = load("res://Shoot.tscn")

onready var _musicBg = $AudioStreamPlayer2D

func _ready():
	pass

func _process(_delta):
	$Label.set_text("MUNIÇÃO : " + str($Player.bullets))
	if not _musicBg.is_playing():
		_musicBg.play()
