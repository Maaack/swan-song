extends Node

var x = []
var fourierX : Array[SpectrumData]

@export_range(0, 100, 0.01, "or_greater") var scale : float = 1

@onready var dataset = %Dataset

func get_fourier_x() -> Array[SpectrumData]:
	var drawing = dataset.drawing
	for i in range(0, drawing.size()):
		var c = Complex.new(scale * drawing[i].x, -scale * drawing[i].y)
		x.append(c)
	return FourierTransform.odd_dft(x);
