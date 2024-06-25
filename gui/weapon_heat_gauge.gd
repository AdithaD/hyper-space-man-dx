extends Control

@export var cooling_off_gradient : Gradient

@onready var segmented_progress_bar: Control = $SegmentedProgressBar
@onready var default_gradient :Gradient = segmented_progress_bar.segment_color_gradient

func set_overheat_mode(is_overheated: bool) -> void:
	$SegmentedProgressBar.segment_color_gradient = cooling_off_gradient if is_overheated else default_gradient
	$SegmentedProgressBar/CoolingOffLabel.visible = is_overheated
	
func set_ratio(ratio):
	$SegmentedProgressBar.set_ratio(ratio)
