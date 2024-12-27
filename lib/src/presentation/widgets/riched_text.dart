import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// 状態管理クラス
class TextProvider with ChangeNotifier {
  final Color fontColor;
  final Color highlightColor;
  final double fontSize;
  final double fontHeight;
  TextProvider({
    required this.fontColor,
    required this.highlightColor,
    required this.fontSize,
    required this.fontHeight,
  });
  final FocusNode focusNode = FocusNode();
  String _text = '';

  // リッチテキスト用のTextSpanリストを生成
  List<TextSpan> get richTextSpans {
    final RegExp tagExp =
        RegExp(r'@(\w+)|#([^\s\u3000\u200B\u200C\u200D]+){1,20}');

    final List<TextSpan> spans = [];
    final matches = tagExp.allMatches(_text);

    int lastMatchEnd = 0;

    for (final match in matches) {
      // 通常のテキスト部分を追加
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: _text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            height: fontHeight,
            textBaseline: TextBaseline.ideographic,
          ),
        ));
      }

      // ハッシュタグやメンション部分を追加
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          color: highlightColor, // デフォルト値を追加
          fontSize: fontSize,
          height: fontHeight,
          textBaseline: TextBaseline.ideographic,
        ),
      ));

      lastMatchEnd = match.end;
    }

    // 最後の通常テキストを追加
    if (lastMatchEnd < _text.length) {
      spans.add(TextSpan(
        text: _text.substring(lastMatchEnd),
        style: TextStyle(
          color: fontColor, // デフォルト値を追加
          fontSize: fontSize,
          height: fontHeight,
          textBaseline: TextBaseline.ideographic,
        ),
      ));
    }

    return spans;
  }

  // テキストを更新
  void updateText(String text) {
    _text = text;
    notifyListeners();
  }
}

class RichedEditableText extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final double fontSize;
  final double fontHeight;
  final Color? fontColor;
  final Color highlightColor;
  final String hintText;
  final Color hintTextColor;
  final Function(String value)? onChanged;
  const RichedEditableText({
    super.key,
    required this.controller,
    this.backgroundColor = Colors.transparent,
    this.fontSize = 20,
    this.fontHeight = 1.5,
    this.fontColor,
    this.highlightColor = Colors.blue,
    this.hintText = "",
    this.hintTextColor = Colors.grey,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TextProvider(
              fontSize: fontSize,
              fontHeight: fontHeight,
              fontColor: fontColor ?? Theme.of(context).colorScheme.onSurface,
              highlightColor: highlightColor,
            ),
        builder: (context, child) {
          final textProvider = Provider.of<TextProvider>(context, listen: true);
          textProvider._text=controller.text;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(textProvider.focusNode);
            },
            child: Container(
              height: 300,
              color: backgroundColor,
              child: SizedBox(
                width: double.infinity, // 親ウィジェットの幅を設定
                child: Stack(
                  children: [
                    // リッチテキスト表示用のレイヤー
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 3), //カーソルの分使える幅がEditableTextとずれるのでそれの解消に。
                      child: Consumer<TextProvider>(
                        builder: (context, provider, child) {
                          return RichText(
                            strutStyle: StrutStyle(
                              fontSize: fontSize,
                              height: fontHeight,
                            ),
                            text: TextSpan(
                                children: provider.richTextSpans,
                                style: TextStyle(fontSize: fontSize)),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          controller.text.isEmpty ? hintText : "",
                          style: TextStyle(
                            color: hintTextColor,
                            fontSize: fontSize,
                            height: fontHeight,
                          ),
                        ),
                      ],
                    ),
                    // 編集可能な透明テキストフィールド
                    IntrinsicWidth(
                      child: EditableText(
                        strutStyle: StrutStyle(
                          fontSize: fontSize,
                          height: fontHeight,
                        ),
                        cursorWidth: 3,
                        autofocus: true,
                        controller: controller,
                        focusNode: textProvider.focusNode,
                        style: TextStyle(
                          color: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          fontSize: fontSize,
                        ),
                        cursorColor: Colors.blue,
                        backgroundCursorColor: Colors.grey,
                        onChanged: (value) {
                          context
                              .read<TextProvider>()
                              .updateText(controller.text);
                          onChanged?.call(value);
                        },
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null, // 折り返しを許可
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class RichedText extends StatelessWidget {
  final Color backgroundColor;
  final double fontSize;
  final double fontHeight;
  final Color? fontColor;
  final Color highlightColor;
  final String hintText;
  final Color hintTextColor;
  final Function(String value)? onChanged;
  final String text;
  const RichedText(
    this.text, {
    super.key,
    this.backgroundColor = Colors.transparent,
    this.fontSize = 20,
    this.fontHeight = 1.5,
    this.fontColor,
    this.highlightColor = Colors.blue,
    this.hintText = "",
    this.hintTextColor = Colors.grey,
    this.onChanged,
  });

  // リッチテキスト用のTextSpanリストを生成
  List<TextSpan> _richTextSpans(BuildContext context, String text) {
    final RegExp tagExp =
        RegExp(r'@(\w+)|#([^\s\u3000\u200B\u200C\u200D]+){1,20}');

    final List<TextSpan> spans = [];
    final matches = tagExp.allMatches(text);

    int lastMatchEnd = 0;

    for (final match in matches) {
      // 通常のテキスト部分を追加
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
              color: fontColor,
              textBaseline: TextBaseline.ideographic,
              fontSize: fontSize),
        ));
      }

      // ハッシュタグやメンション部分を追加
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          color: highlightColor, // デフォルト値を追加
          fontSize: fontSize,
          textBaseline: TextBaseline.ideographic,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            final String? tagText = match.group(0);
            if (tagText != null) {
              if (tagText.startsWith('@')) {
                context.push("/user/${tagText.substring(1)}");
              }
              if (tagText.startsWith('#')) {
                String encodedQuery = Uri.encodeQueryComponent(tagText);

                String fullUrl = "/search?q=$encodedQuery";

                context.push(fullUrl);
              }
            }
          },
      ));

      lastMatchEnd = match.end;
    }

    // 最後の通常テキストを追加
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          color: fontColor, // デフォルト値を追加
          fontSize: fontSize,
          textBaseline: TextBaseline.ideographic,
        ),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      strutStyle: StrutStyle(
        fontSize: fontSize,
        height: fontHeight,
      ),
      text: TextSpan(
          children: _richTextSpans(context, text),
          style: TextStyle(fontSize: fontSize)),
    );
  }
}
