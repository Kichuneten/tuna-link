import 'package:intl/intl.dart';

String formatTimeAgo(String dateString) {
  // カスタムフォーマットを指定して DateTime に変換
  DateFormat format = DateFormat('yyyy/MM/dd a hh:mm:ss');
  DateTime dateTime = format.parse(dateString);

  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}秒前';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}分前';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}時間前';
  } else if (difference.inDays < 5) {
    return '${difference.inDays}日前';
  } else {
    // それ以外の場合、元のフォーマットで表示
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }
}
