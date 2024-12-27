
//値自体に意味はないサイズのプリセット
import 'package:flutter/widgets.dart';

class RawSize{

}

class MyFontSize{
  static const ss=8.0;
  static const s=9.0;
  static const m=13.0;
  static const ml=14.0;
  static const l=17.0;
  static const ll=20.0;
}



//FeactionSizedBox(親要素のサイズに対する比率でサイズ指定：参考)


double sw(BuildContext context,double x){
    // 画面の幅と高さ
    final screenWidth = MediaQuery.of(context).size.width;
  return x*screenWidth/100;
}


double sh(BuildContext context,double x){
    // 画面の幅と高さ
    final screenWidth = MediaQuery.of(context).size.height;
  return x*screenWidth/100;
}