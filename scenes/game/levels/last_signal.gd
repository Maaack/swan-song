extends Control

@onready var homer_simpson_transform = %HomerSimpsonTransform
@onready var fourier_cycles = %FourierCycles

# Called when the node enters the scene tree for the first time.
func _ready():
	var fourier_x : Array[SpectrumData] = homer_simpson_transform.get_fourier_x()
	fourier_x.sort_custom(func(a, b) : return a.amp > b.amp )
	fourier_cycles.data = fourier_x
