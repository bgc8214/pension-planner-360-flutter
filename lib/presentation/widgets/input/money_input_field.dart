import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// 금액 입력 필드 위젯
class MoneyInputField extends StatefulWidget {
  final String label;
  final String? suffix;
  final int value;
  final ValueChanged<int> onChanged;
  final String? helperText;

  const MoneyInputField({
    super.key,
    required this.label,
    this.suffix,
    required this.value,
    required this.onChanged,
    this.helperText,
  });

  @override
  State<MoneyInputField> createState() => _MoneyInputFieldState();
}

class _MoneyInputFieldState extends State<MoneyInputField> {
  late TextEditingController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value == 0 ? '' : _numberFormat.format(widget.value),
    );
  }

  @override
  void didUpdateWidget(MoneyInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = widget.value == 0 ? '' : _numberFormat.format(widget.value);
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: widget.suffix ?? '원',
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ThousandsSeparatorInputFormatter(),
      ],
      onChanged: (value) {
        final cleanValue = value.replaceAll(',', '');
        final intValue = int.tryParse(cleanValue) ?? 0;
        widget.onChanged(intValue);
      },
    );
  }
}

/// 천 단위 구분 기호 자동 입력 Formatter
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _numberFormat = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanValue = newValue.text.replaceAll(',', '');
    final intValue = int.tryParse(cleanValue);
    if (intValue == null) {
      return oldValue;
    }

    final formattedValue = _numberFormat.format(intValue);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
