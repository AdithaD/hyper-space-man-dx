extends TextureProgressBar

@export var timer: Timer

## Hide the progress bar when the timer isn't running
@export var hide_when_stopped = true

func _process(_delta):
	if not timer.is_stopped():
		if not visible:
			show()

		ratio = (timer.wait_time - timer.time_left) / timer.wait_time
	else:
		if hide_when_stopped and visible:
			hide()
