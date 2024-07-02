class_name GlobalFormat

static func format_amount(amount : int) -> String:
	var pow := log(amount) / log(10)
	var suffix := ""
	if pow >= 3:
		suffix = "K"
	elif pow >= 6:
		suffix = "M"
	
	var quotient : float = amount if pow < 3 else amount / pow(10, floori(pow/3) * 3)
	return ("%.1f%s" if pow > 3 else "%.0f%s") % [quotient, suffix]
