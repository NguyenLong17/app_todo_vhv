import 'package:flutter/material.dart';



class DialogShow extends StatefulWidget {
  final String? title;
  final String message;

  const DialogShow({
    super.key,
    this.title,
    required this.message,
  });

  @override
  State<DialogShow> createState() => _DialogShowState();
}

class _DialogShowState extends State<DialogShow> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title ?? 'Title...',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showAlertDialog({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) {
        return Container(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: AlertDialog(
              title: Text(message),
              backgroundColor: Colors.greenAccent,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.other_houses_rounded),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}