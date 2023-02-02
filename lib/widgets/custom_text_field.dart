import 'package:flutter/material.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';

customTextField({required String hintText,
  TextInputType? keyboardType,
  String? errorText,
  bool obscureText=false,
  FormFieldValidator? validator,required String labelText,required TextEditingController controller})  {
  return  Container(
    margin: EdgeInsets.symmetric(vertical: errorText!=null&& errorText.isNotEmpty?5:12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyleConstant.grey16.copyWith(fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextFormField(
keyboardType: keyboardType??TextInputType.text,
            // enableInteractiveSelection: false,
            obscureText: obscureText,
            validator: validator,
            controller: controller,
            style: TextStyleConstant.titleStyle
                .copyWith(color: ColorConstant.black24,fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              errorBorder: _customBorder(), disabledBorder: _customBorder(),
              focusedBorder: _customBorder(),
              enabledBorder: _customBorder(),
              focusedErrorBorder:_customBorder(),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyleConstant.grey16,
            ),
          ),
        ),
        if( errorText!=null && errorText.isNotEmpty)
        const SizedBox(height:8),
        if( errorText!=null && errorText.isNotEmpty)
        Text(errorText,style: TextStyle(color: Colors.redAccent))
      ],
    ),
  );

}

_customBorder() {

  return OutlineInputBorder(
      borderSide: BorderSide(color: ColorConstant.grey80.withOpacity(.3) ),
      borderRadius: BorderRadius.circular(8)
  );
}