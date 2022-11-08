extends RigidBody

var shoot = false

const SPEED = 50

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body.is_in_group("enemy"):
		body.die()

	if not body.is_in_group("shoot_ignore_collision"):
		queue_free()
