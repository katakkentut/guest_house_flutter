import 'package:flutter/material.dart';
import '../../gen/colors.gen.dart';
import 'app_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.buttonText,
    this.onPressed,
  }) : super(key: key);

  final String buttonText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(ColorName.yellow),
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        elevation: MaterialStateProperty.all(0),
      ),
      child: AppText.medium(
        buttonText,
        fontSize: 16,
      ),
    );
  }
}

class DetailScreenButton extends StatelessWidget {
  const DetailScreenButton({
    Key? key,
    required this.buttonText,
    this.onPressed,
    this.icon,
    this.color,
    this.textColor
  }) : super(key: key);

  final String buttonText;
  final Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(color ?? ColorName.yellow),
          minimumSize: MaterialStateProperty.all(const Size(200, 50)),
          elevation: MaterialStateProperty.all(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.medium(
              buttonText,
              fontSize: 15,
              color: textColor ?? Colors.black,
            ),
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(icon, color: Colors.blue[900]),
              ),
          ],
        ),
      ),
    );
  }
}

class SubmitFeedbackButton extends StatelessWidget {
  const SubmitFeedbackButton({
    Key? key,
    required this.buttonText,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  final String buttonText;
  final Function()? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(ColorName.yellow),
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        elevation: MaterialStateProperty.all(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.medium(
            buttonText,
            fontSize: 15,
          ),
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(icon, color: Colors.blue[900]),
            ),
        ],
      ),
    );
  }
}
