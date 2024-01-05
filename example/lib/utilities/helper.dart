class Helper {
  static String formatDateTime(int time) {
    final now = DateTime.now();
    final messageTime = DateTime.fromMillisecondsSinceEpoch(time);

    if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day) {
      final amPm = messageTime.hour < 12 ? 'AM' : 'PM';
      final formattedHour = messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
      return '$formattedHour:${messageTime.minute.toString().padLeft(2, '0')} $amPm';
    } else {
      return '${messageTime.month}/${messageTime.day}/${messageTime.year}';
    }
  }
}
