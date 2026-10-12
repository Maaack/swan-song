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
	fourierX = FourierTransform.dft(x);
	fourierX.sort_custom(func(a, b) : b.amp - a.amp)

	# Set initial potition
	time = -PI;

	print(fourierX.size())

func draw():
	if (show == true):

		var v = epicycles(0, 0, 0, fourierX, terms, time);

		if (-PI <= time && time <= PI + PI / 10):
			path.unshift(v)
		for i in range(0, path.length):
			pass
			#vertex(path[i].x, path[i].y);
	else:
		for k in range(-180, 180):
			var vs = FourierTransform.fourierSeries(fourierX, deg_to_rad(k), terms)
			#vertex(vs.x, vs.y);

	var dt : float = 0.009
	#var dt = TWO_PI / fourierX.length;
	time += dt;

func clearPath():
	path = [];
	time = -PI;

func epicycles(x, y, rotation, fourier, terms, t):
	for i in range(0, terms):
		var prevx = x;
		var prevy = y;
		var freq = fourier[i].freq;
		var radius = fourier[i].amp;
		var phase = fourier[i].phase;
	
		x += radius * cos(freq * t + phase + rotation);
		y += radius * sin(freq * t + phase + rotation);

		# draw vector and ellipse
		#stroke(3 * i / fourier.length, 1, 1);
		#noFill();
		#ellipse(prevx, prevy, radius * 2);
		#stroke(1, 0, 1);
		#line(prevx, prevy, x, y);
		
	#return createVector(x, y);
