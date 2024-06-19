import 'package:flutter/material.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/theme/color.dart';

import '../../gen/assets.gen.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatefulWidget {
  // late FocusNode focus;
  final IconData? icon;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final String? labelText;
  final ETextField? type;
  final bool? autoFocus;
  final String? errorText;
  final TextInputType? keyboardType;
  final String? label;
  final bool? obscureText;
  final Icon? surFixIcon;
  final bool readOnly;
  final bool? errBorder;
  final Color? emailColors;
  void Function()? onTap;

  TextFieldCustom({
    Key? key,
    this.icon,
    required this.controller,
    required this.onChanged,
    this.labelText,
    this.type = ETextField.none,
    this.autoFocus = false,
    this.errorText = '',
    this.validator,
    this.keyboardType,
    this.label = '',
    this.obscureText = false,
    this.errBorder = false,
    this.emailColors,
    this.surFixIcon,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  final FocusNode _focus = FocusNode();
  late bool _focusState;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _focusState = false;
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _onFocusChange() {
    setStateIfMounted(() {
      _focusState = _focus.hasFocus;
    });
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unrelated_type_equality_checks
    if (widget.type == ETextField.textArea) {
      return Column(
        children: [
          if (widget.label != null)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.label!,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                          const TextStyle(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w600),
                        ),
                  ),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            height: 150,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyText2!.merge(
                    const TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600),
                  ),
              autofocus: widget.autoFocus ?? false,
              readOnly: widget.readOnly,
              focusNode: _focus,
              minLines: 5,
              maxLength: 1000,
              keyboardType: TextInputType.multiline,
              controller: widget.controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                alignLabelWithHint: true, // textVertical top textare
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: _focusState ? const Color(0xFF09af00) : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Color(0xFF09af00)),
                ),
                errorText: widget.errorText,
                // errorStyle: TextStyle(
                //   fontSize: 10.0,
                // ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (widget.label != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label!,
              textAlign: TextAlign.left,
              style: widget.emailColors == null
                  ? Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                          color: widget.emailColors ?? AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      )
                  : Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontFamily: Assets.googleFonts.montserratBold,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        //height:1,
                      ),
            ),
          ),
        if (widget.label != null) const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 48),
          child: TextFormField(
            cursorColor: AppColors.textBlue,
            style: Theme.of(context).textTheme.subtitle1!.merge(
                  const TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
            textInputAction: TextInputAction.next,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            autofocus: widget.autoFocus ?? false,
            focusNode: _focus,
            obscureText: widget.obscureText ?? false,
            controller: widget.controller,
            onChanged: (text) => widget.onChanged(text),
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            validator: (text) {
              if (widget.validator != null) {
                return widget.validator!(text);
              }
              return null;
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(width: 1, color: AppColors.textBlue),
                ),
                labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
                      const TextStyle(
                          color: AppColors.textLightGray,
                          fontWeight: FontWeight.w400),
                    ),
                alignLabelWithHint: true,
                prefixIcon: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color:
                            _focusState ? const Color(0xFF09af00) : Colors.grey,
                      )
                    : null,
                border: OutlineInputBorder(
                    borderSide: widget.errBorder!
                        ? const BorderSide(width: 1, color: AppColors.red)
                        : BorderSide.none,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                // border: InputBorder.none,
                labelText: widget.labelText,
                errorText: widget.errorText,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                errorStyle: Theme.of(context).textTheme.subtitle2!.merge(
                      const TextStyle(
                        color: AppColors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                suffixIcon: widget.surFixIcon),
          ),
        ),
      ],
    );
  }
}
