extends KinematicBody

var isAlive = true
var accTranslation = 0
var dyingDirection = 0

onready var zombieMesh  = $Mesh
onready var ghostSprite = $Sprite3D

func _ready():
	ghostSprite.visible = false
	
func _process(_delta):
	if isAlive:
		pass
	else:
		_handleDying()

func _handleDying():
	if accTranslation > 8:
		queue_free()
	var step = 0.2
	accTranslation = accTranslation + step
	
	if _accTranslationAt(2) or _accTranslationAt(4) or _accTranslationAt(6):
		randomizeDyingDirection()
	
	translate(Vector3(0, step, 0))
	rotate_object_local(Vector3(0, 0, 1), deg2rad(dyingDirection))

func die():
	isAlive = false
	zombieMesh.visible = false
	ghostSprite.visible = true
#	queue_free()

func randomizeDyingDirection():
	randomize()
	dyingDirection = randi()%2+1
	if dyingDirection != 1:
		dyingDirection = -1

func _accTranslationAt(_value):
	return accTranslation > _value - 0.1 and accTranslation < _value + 0.1
