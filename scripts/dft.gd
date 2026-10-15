class_name FourierTransform
extends Node

static func dft(data: Array) -> Array[SpectrumData]:
	var size := float(data.size())
	var frequencies : Array[SpectrumData] = []
	frequencies.resize(int(size))

	for freq in range (0, size):
		var re : float = 0
		var im : float = 0

		for t in range(0, size):
			var rate = -1 * (2 * PI) * freq
			var time = t / size
			var distance = rate * time
			var re_part = data[t] * cos(distance)
			var im_part = data[t] * sin(distance)
			re += re_part
			im += im_part

		if (abs(re) < 1e-10): re = 0
		if (abs(im) < 1e-10): im = 0
		re = re / size
		im = im / size
		var amp = sqrt(re * re + im * im)
		var phase = atan2(im, re) * 180 / PI
		var value = SpectrumData.new(re, im, freq, amp, phase)
		frequencies[freq] = value

	return frequencies

static func idft(cycles : Array) -> Array:
	var timeseries := []
	var size := float(cycles.size())
	for i in range(0, int(size)):
		var pos = i / size * 2 * PI
		var total = total_value(pos, cycles)
		timeseries.append(total)
	return timeseries

static func odd_dft(input_array: Array) -> Array[SpectrumData]:
	var data_array : Array[SpectrumData] = []
	var size : float = input_array.size()
	data_array.resize(int(size))
	@warning_ignore("integer_division")
	for k in range(-(size - 1) / 2, ((size - 1) / 2) + 1):
		var sum = Complex.new(0, 0)
		for l in range(0, size):
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

static func total_value(x : float, cycles : Array):
	var re : float = 0
	var im : float = 0

	for cycle in cycles:
		re += cycle.amp * cos(x * cycle.freq + cycle.phase * PI/180)
		im += cycle.amp * sin(x * cycle.freq + cycle.phase * PI/180)

	var amp = sqrt(re * re + im * im)
	var phase = atan2(im, re) * 180 / PI
	return SpectrumData.new(re, im, 0, amp, phase)
