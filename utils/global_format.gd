class_name GlobalFormat

static func format_amount(amount: int) -> String:
	var power := floori(log(amount) / log(1000))
	var suffix := ""
	if power == 1:
		var quotient: float = amount / pow(10, 3)
		suffix = "K"
		return "%.1f%s" % [quotient, suffix]
	elif power == 2:
		var quotient: float = amount / pow(10, 6)
		suffix = "M"
		return "%.0f%s" % [quotient, suffix]
	else:
		return "%.0f" % amount