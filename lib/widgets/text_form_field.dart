import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

class CustomTextField extends StatefulWidget {
  String? hintText;
  String? errorText;
  String? helperText;
  IconData? icon;
  TextInputAction? textInputAction;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  int? minLines;
  int? maxLines;
  dynamic validator;
  TextEditingController? controller;
  var obscureText = false;

  CustomTextField(
      {super.key,
      required this.hintText,
      this.errorText,
      this.helperText,
      this.icon,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText = false,
      this.minLines,
      this.maxLines,
      this.validator,
      this.textInputAction,
      this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return (widget.obscureText)
        ? TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              helperText: widget.helperText,
              helperMaxLines: 23,
              filled: true,
              fillColor: const AppColors().light2,
              prefixIcon: Icon(
                widget.icon,
                color: const AppColors().primary,
              ),
              labelText: widget.hintText,
              labelStyle:
                  TextStyle(color: const AppColors().grey.withOpacity(.8)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const AppColors().primary),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
            ),
            validator: widget.validator,
          )
        : TextFormField(
            controller: widget.controller,
            minLines: widget.maxLines,
            maxLines: widget.maxLines,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              helperText: widget.helperText,
              helperMaxLines: 23,
              filled: true,
              fillColor: const AppColors().light2,
              prefixIcon: Icon(
                widget.icon,
                color: const AppColors().primary,
              ),
              labelText: widget.hintText,
              labelStyle:
                  TextStyle(color: const AppColors().grey.withOpacity(.8)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const AppColors().primary),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
            ),
            validator: widget.validator,
          );
  }
}

class CustomDropDownMenu extends StatefulWidget {
  List list;
  String? hintText;
  String? errorText;
  String? helperText;
  IconData? icon;
  dynamic onChanged;
  CustomDropDownMenu({
    super.key,
    required this.list,
    required this.hintText,
    this.errorText,
    this.helperText,
    this.icon,
    dynamic validator,
    required this.onChanged,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.list.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value!,
          child: Text(value!),
        );
      }).toList(),
      value: widget.list[0].toString(),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        helperText: widget.helperText,
        helperMaxLines: 23,
        filled: true,
        fillColor: const AppColors().light2,
        prefixIcon: Icon(
          widget.icon,
          color: const AppColors().primary,
        ),
        labelText: widget.hintText,
        labelStyle: TextStyle(color: const AppColors().grey.withOpacity(.8)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const AppColors().primary),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
