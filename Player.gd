extends KinematicBody

################################################################################
# PLAYER CONFIG                                                                #
################################################################################

var _shootScene = preload("res://Shoot.tscn")

onready var _headNode = $Head
onready var _anim     = $AnimationPlayer
onready var _raycast  = $Head/Camera/RayCast
onready var _muzzle   = $Head/Gun/Muzzle

onready var _sfxShoot = $Shoot
onready var _sfxNoBullets = $FailShoot

const MOUSE_SENSITIVITY = 0.3

################################################################################
# PLAYER INTERNAL STATE                                                        #
################################################################################

var shouldLockCamera = false
export var bullets = 30

################################################################################
# HANDLE GAME LOOP                                                             #
################################################################################

func _ready():
	_handleMouseMode(shouldLockCamera)
	
func _process(_delta):
	_polling()

func _input(ev):
	if ev is InputEventMouseMotion:
		_handleCamera(ev)
	if ev is InputEventMouseButton and ev.pressed:
		_handleFire()

################################################################################
# HELPERS                                                                      #
################################################################################

func _polling():
	if Input.is_action_just_pressed("ui_cancel"):
		shouldLockCamera = !shouldLockCamera
		_handleMouseMode(shouldLockCamera)

func _handleCamera(evMouseMotion):
	if shouldLockCamera:
		return
	rotate_y(_calcRotation(-evMouseMotion.relative.x))
	_headNode.rotate_x(_calcRotation(-evMouseMotion.relative.y))
	_headNode.rotation.x = clamp(_headNode.rotation.x, deg2rad(-90), deg2rad(90))

func _handleFire():
	if bullets > 0:
		bullets = bullets - 1
		_sfxShoot.play()
		_fire()
	else:
		_sfxNoBullets.play()

func _fire():
	_anim.play("AssaultFire")
	var b = _shootScene.instance()
	_muzzle.add_child(b)
	b.look_at(_raycast.get_collision_point(), Vector3.UP)
	b.shoot = true

func _calcRotation(rotDeg):
	return deg2rad(rotDeg * MOUSE_SENSITIVITY)

func _handleMouseMode(_shouldShowMouse):
	if _shouldShowMouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
