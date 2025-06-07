extends Node

# Formats the size based on whether it's below 1
func format_size(value: float) -> float:
	if value < 1.0:
		return 0
	return round(value * 100) / 100.0  # Two decimal places

# Converts string to JSON-like size breakdown
func get_string_file_size_json(text: String) -> Dictionary:
	var byte_count = text.to_utf8_buffer().size()

	var size_data = {
		"bytes": byte_count,
		"kb": format_size(byte_count / 1024.0),
		"mb": format_size(byte_count / 1048576.0),
		"gb": format_size(byte_count / 1073741824.0),
		"tb": format_size(byte_count / 1099511627776.0)
	}
	
	return size_data

# Finds the smallest non-zero unit (ignores "bytes" unless it's the only non-zero)
func get_smallest_nonzero_unit(size_data: Dictionary) -> String:
	var units = ["kb", "mb", "gb", "tb"]
	for unit in units:
		if size_data[unit] > 0:
			return str(size_data[unit]) + " " + unit.to_upper()
	
	# Fallback to bytes if all others are zero
	return str(size_data["bytes"]) + " bytes"

# Example usage
func _ready():
	var example := "Sample string with\nsome data\nand formatting."
	var size_data := get_string_file_size_json(example)
	var smallest_unit := get_smallest_nonzero_unit(size_data)
	
	print(JSON.new().stringify(size_data, "\t"))
	print("Smallest non-zero unit: " + smallest_unit)
