extends Control

@export var segments : int = 10:
	set(value):
		segments = value
		queue_redraw()
@export var separation : int = 6:
	set(value):
		separation = value
		queue_redraw()

@export var segment_color : Color = Color.GREEN
@export var segment_color_gradient : Gradient

var value : int = 10:
	set(v):
		value = v
		queue_redraw()



func _draw() -> void:
	var segment_width = (size.x - (separation * (segments - 1))) / segments
	
	for i in range(value):
		var x := floori(i * (segment_width + separation))
		
		var colour = segment_color
		if segment_color_gradient:
			colour = segment_color_gradient.sample(value / float(segments))
		
		draw_rect(Rect2(Vector2(x, 0), Vector2(segment_width, size.y)), colour)
