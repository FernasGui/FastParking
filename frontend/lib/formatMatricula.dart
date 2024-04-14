import 'package:flutter/services.dart';
import 'dart:math' as math;

class MatriculaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove qualquer coisa que não seja letra ou número e converte para maiúsculas
    String text = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Adiciona hífens após o segundo e quarto caracteres, se necessário
    if (text.length > 2 && text.length <= 4) {
      text = '${text.substring(0, 2)}-${text.substring(2)}';
    } else if (text.length > 4) {
      text = '${text.substring(0, 2)}-${text.substring(2, 4)}-${text.substring(4)}';
    }

    // Certifica-se de não exceder o tamanho máximo com os hífens
    text = text.substring(0, math.min(8, text.length));

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
