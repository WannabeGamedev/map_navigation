extends Camera2D

const ZOOM_MIN = Vector2(0.5, 0.5)
const ZOOM_MAX = Vector2(10.0, 10.0)

func _unhandled_input(event):
    # Wheel Up Event
    if event.is_action_pressed("zoom_in"):
        _zoom_camera(-5)
    # Wheel Down Event
    elif event.is_action_pressed("zoom_out"):
        _zoom_camera(5)

# Zoom Camera
func _zoom_camera(dir):
	var res = Vector2(0.1, 0.1) * dir
	if dir < 0:
		if zoom+res > ZOOM_MIN:
			zoom += res
		else:
			zoom = ZOOM_MIN
	else:
		if zoom+res < ZOOM_MAX:
			zoom += res
		else:
			zoom = ZOOM_MAX