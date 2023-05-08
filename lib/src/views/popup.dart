import 'package:flutter/material.dart';

enum PopupType {
  success,
  fail,
}

class Popup extends StatelessWidget {
  final String message;
  final PopupType type;
  final Widget? actions;

  const Popup(
      {Key? key, required this.type, required this.message, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                top: -50,
                child: ClipOval(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: type == PopupType.success
                            ? Colors.lightGreen
                            : const Color.fromRGBO(244, 116, 88, 1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        )),
                    child: Icon(
                      type == PopupType.success
                          ? Icons.check_outlined
                          : Icons.clear_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type == PopupType.success ? "Congratulations" : "Error",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    actions!,
                  ]
                ],
              ),
            ),
          ],
        ));
  }
}
