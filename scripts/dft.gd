class_name FourierTransform
extends Node

static func odd_dft(input_array: Array) -> Array[SpectrumData]:
	var data_array : Array[SpectrumData] = []
	var size : float = input_array.size()
	var start_time = Time.get_unix_time_from_system()
	data_array.resize(int(size))
	@warning_ignore("integer_division")
	for k in range(-(size - 1) / 2, ((size - 1) / 2) + 1):
		if (Time.get_unix_time_from_system() - start_time > 100):
			push_warning("breaking out 1")
			break
		var sum = Complex.new(0, 0)
		var start_time_2 = Time.get_unix_time_from_system()
		for l in range(0, size):
			if (Time.get_unix_time_from_system() - start_time_2 > 100):
				push_warning("breaking out 2")
				break
			var phi = k * 2 * PI * l / size
			var c = Complex.new(cos(phi), -sin(phi))
			sum.add(input_array[l].mult(c))
		sum.re = sum.re / size
		sum.im = sum.im / size
		var freq = k
		var amp = sqrt(sum.re * sum.re + sum.im * sum.im)
		var phase = atan2(sum.im, sum.re)
		@warning_ignore("integer_division")
		var data_key = k + (size - 1) / 2
		var value = SpectrumData.new(sum.re, sum.im, freq, amp, phase)
		data_array[data_key] = value
	return data_array

static func fourierSeries(fourier, t, terms) -> Vector2:
	var c = fourier
	var sumX = 0
	var sumY = 0
	var k = 0
	while (k < terms):
		var f = c[k].freq
		var r = c[k].re
		var i = c[k].im
		sumX += cos(f * t) * r - sin(f * t) * i;
		sumY += cos(f * t) * i + sin(f * t) * r;
		k += 1
	return Vector2(sumX, sumY);
