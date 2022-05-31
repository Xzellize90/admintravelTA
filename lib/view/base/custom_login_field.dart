import 'package:flutter/material.dart';
import 'package:travel_admin/provider/language_provider.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sizer/sizer.dart';
import 'package:travel_admin/utill/styles.dart';

class CustomLoginField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function onTap;
  final Function onChanged;
  final Function validator;
  final Function onSuffixTap;
  final IconData suffixIcon;
  final String prefixIconUrl;
  final bool isSearch;
  final Function onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final LanguageProvider languageProvider;
  final int maxLength;
  final bool readOnly;

  CustomLoginField({
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.validator,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIconUrl,
    this.isSearch = false,
    this.languageProvider,
    this.maxLength,
    this.readOnly = false,
  });

  @override
  _CustomLoginFieldState createState() => _CustomLoginFieldState();
}

class _CustomLoginFieldState extends State<CustomLoginField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.left,
      maxLines: widget.maxLines,
      controller: widget.controller,
      textAlignVertical: TextAlignVertical.center,
      focusNode: widget.focusNode,
      style: rockSaltMedium.copyWith(
        fontSize: 14.sp,
      ),
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ]
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
        border: (widget.isShowBorder)
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey,
                ),
              ),
        enabledBorder: (widget.isShowBorder)
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey,
                ),
              ),
        focusedBorder: (widget.isShowBorder)
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Colors.grey),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey,
                ),
              ),
        isDense: true,
        hintText: widget.hintText,
        fillColor: Colors.white,
        hintStyle: rockSaltMedium.copyWith(
          fontSize: 14.sp,
          color: Colors.grey,
        ),
        labelStyle: rockSaltMedium.copyWith(
          fontSize: 14.sp,
          color: Colors.grey,
        ),
        errorStyle: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: 12.0.sp,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
        counterStyle: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: 14.0.sp,
              color: Colors.grey,
            ),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon
            ? Padding(
                padding: EdgeInsets.only(
                    left: 1.0.h,
                    right: 1.0.h),
                child: Icon(
                  widget.suffixIcon,
                  size: 12.0.sp,
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                ),
              )
            : SizedBox.shrink(),
        prefixIconConstraints:
            BoxConstraints(minWidth: 2.0.h, maxHeight: 2.0.h),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      size: 14.0.sp,
                      color: Theme.of(context).hintColor.withOpacity(0.3),
                    ),
                    onPressed: _toggle,
                  )
                : widget.isIcon
                    ? Icon(
                        widget.suffixIcon,
                        size: 12.0.sp,
                        color: Colors.grey,
                      )
                    : null
            : Icon(
                widget.suffixIcon,
                size: 14.0.sp,
                color: Colors.grey,
              ),
      ),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: (widget.inputType == TextInputType.emailAddress)
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong';
              } else if (!EmailValidator.validate(value)) {
                return 'Email anda tidak valid';
              }

              return null;
            }
          : (widget.isPassword)
              ? (value) {
                  RegExp regex =
                      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
                  print('password >> ${regex.hasMatch(value)}');
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password harus lebih dari 6 karakter';
                  } else if (value.length > 6 && !regex.hasMatch(value)) {
                    return 'Pasword harus berupa kombinasi huruf kapital dan angka';
                  }

                  return null;
                }
              : widget.validator,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
