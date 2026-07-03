String monthYearLabel(DateTime value, String languageCode) {
  const enMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  if (languageCode == 'vi') {
    return 'Tháng ${value.month} ${value.year}';
  }
  return '${enMonths[value.month - 1]} ${value.year}';
}

int daysInMonth(DateTime value) {
  final beginningNextMonth = value.month < 12
      ? DateTime(value.year, value.month + 1)
      : DateTime(value.year + 1);
  return beginningNextMonth.subtract(const Duration(days: 1)).day;
}

int leadingEmptyDays(DateTime value) {
  final firstDay = DateTime(value.year, value.month);
  return firstDay.weekday % 7;
}
