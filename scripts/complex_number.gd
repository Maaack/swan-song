class_name Complex
extends RefCounted

var re : float
var im : float
func _init(a, b):
	re = a
	im = b

func add(c:Complex):
	re += c.re
	im += c.im

func mult(c:Complex) -> Complex:
	var re2 = re * c.re - im * c.im
	var im2 = re * c.im + im * c.re
	return Complex.new(re2, im2)
