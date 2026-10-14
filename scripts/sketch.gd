extends Node

var x = []
var fourierX : Array
var time
var path = []

@export_range(0, 1000, 1.0, "or_greater") var terms : int
var sel
var show = true
@export_range(0, 100, 0.01, "or_greater") var scale : float
@export var x_offset : float = 0
@export var y_offset : float = 0

func setup(drawing: Array = []):
	var skip = 1
	for i in range(0, drawing.size(), skip):
		var c = Complex.new(scale * (drawing[i].x + x_offset), -scale * (drawing[i].y + y_offset))
		x.push(c)
	fourierX = FourierTransform.odd_dft(x);
	fourierX.sort_custom(func(a, b) : b.amp - a.amp)

	# Set initial potition
	time = -PI;

	print(fourierX.size())

func clearPath():
	path = [];
	time = -PI;
