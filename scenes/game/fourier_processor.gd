extends Node

var x = []
var fourierX : Array[SpectrumData]
var time
var path = []

@export_range(0, 1000, 1.0, "or_greater") var terms : int = 1
var sel
var show = true
@export_range(0, 100, 0.01, "or_greater") var scale : float = 1
@export var x_offset : float = 0
@export var y_offset : float = 0

@onready var dataset = %Dataset
@onready var fourier_cycles = %FourierCycles

func _ready():
	var drawing = dataset.drawing
	var skip = 1
	for i in range(0, drawing.size(), skip):
		var c = Complex.new(scale * (drawing[i].x + x_offset), -scale * (drawing[i].y + y_offset))
		x.append(c)
	fourierX = FourierTransform.dft(x);
	fourierX.sort_custom(func(a, b) : return a.amp > b.amp )

	fourier_cycles.data = fourierX
	fourier_cycles.time = -PI
