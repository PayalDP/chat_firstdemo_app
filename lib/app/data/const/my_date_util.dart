import 'package:flutter/material.dart';

class MyDateUtil {

  static String getFormattedTime({required BuildContext context, required String time}) {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

        return TimeOfDay.fromDateTime(date).format(context);
  }

  //get time format for read and sent time
  static getMessageTime(BuildContext context, String time) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return now.year == sent.year
        ? '${getFormattedTime(context: context, time: time)} - ${sent.day} ${_getMonth(sent)}'
        : '${getFormattedTime(context: context, time: time)} - ${sent.day} - ${_getMonth(sent)} - ${sent.year}';

  }

  //get last message time
  static String getLastMessageTime({required BuildContext context, required String time,bool showYear = false}){
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.month} ${_getMonth(sent)} ${sent.year}'
        : '${sent.month} ${_getMonth(sent)}';
  }

  static String getLastActiveTime ({required BuildContext context, required String lastActive}) {
    final int i =int.tryParse(lastActive) ?? -1;

    if(i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formatedTime = TimeOfDay.fromDateTime(time).format(context);

    if(time.day == now.day &&
        time.month == now.month &&
        time.year == now.year){
      return 'Last seen today at $formatedTime';
    }

    if((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday $formatedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month $formatedTime';
  }

  static String _getMonth (DateTime date) {

        switch(date.month) {
          case 1: return 'Jan';

          case 2: return 'Feb';

          case 3: return 'Mar';

          case 4: return 'Apr';

          case 5: return 'May';

          case 6: return 'Jun';

          case 7: return 'Jul';

          case 8: return 'Aug';

          case 9: return 'Sept';

          case 10: return 'Oct';

          case 11: return 'Nov';

          case 12: return 'Des';
        }

        return 'NA';
  }
}