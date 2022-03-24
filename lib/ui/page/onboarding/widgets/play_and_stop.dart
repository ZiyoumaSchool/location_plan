import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localise/common/app_color.dart';

class PlayAndStop extends StatelessWidget {
  const PlayAndStop({
    Key? key,
    required this.isStop,
    required this.value,
  }) : super(key: key);

  final bool isStop;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Icon(
                isStop
                    ? CupertinoIcons.arrowtriangle_right_fill
                    : CupertinoIcons.square_fill,
                color: AppColor.primary,
              ),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: AppColor.primary,
              value: value,
            ),
          ],
        ),
      ),
    );
  }
}
