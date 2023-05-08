import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final String title;
  final double? maxTitleWidth;
  final String? subtitle;
  final List<Widget> children;

  const Skeleton({
    Key? key,
    required this.title,
    this.maxTitleWidth,
    this.subtitle,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: maxTitleWidth ?? size.width * 0.55),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.7),
                            child: Text(
                              subtitle!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
