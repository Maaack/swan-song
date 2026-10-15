extends Node

@export var time_series : Array :
	set(value):
		time_series = value
		var result = FourierTransform.dft(time_series)
		print(result.size())
