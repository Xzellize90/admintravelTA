import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final Color backgroundColor;
  final Color borderColor;
  final Icon icon;
  final Alignment txtAlign;
  final Color txtColor;
  final bool border;

  CustomButton({
    this.onTap,
    @required this.btnTxt,
    this.backgroundColor,
    this.icon,
    this.txtAlign,
    this.txtColor,
    this.border,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.grey,
      minimumSize: Size(MediaQuery.of(context).size.width, 50),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      alignment: txtAlign == null ? Alignment.center : txtAlign,
      shadowColor: Colors.grey,
      side: border == true
          ? BorderSide(
              color:Colors.grey,
              width: 1,
              style: BorderStyle.solid)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );

    return TextButton(
        onPressed: onTap,
        style: flatButtonStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Text(
                    btnTxt ?? "",
                    style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Colors.white,
                          fontSize: 12.0.sp,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: icon,
                ),
              ],
            )
          ],
        ));
  }
}
