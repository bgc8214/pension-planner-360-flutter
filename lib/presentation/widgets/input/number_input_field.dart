import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 숫자 입력 필드 위젯 (정수)
class NumberInputField extends StatefulWidget {
  final String label;
  final String? suffix;
  final int value;
  final ValueChanged<int> onChanged;
  final String? helperText;
  final int? min;
  final int? max;

  const NumberInputField({
    super.key,
    required this.label,
    this.suffix,
    required this.value,
    required this.onChanged,
    this.helperText,
    this.min,
    this.max,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(NumberInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
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
        suffixText: widget.suffix,
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        var intValue = int.tryParse(value) ?? 0;

        // min/max 범위 체크
        if (widget.min != null && intValue < widget.min!) {
          intValue = widget.min!;
          _controller.text = intValue.toString();
        }
        if (widget.max != null && intValue > widget.max!) {
          intValue = widget.max!;
          _controller.text = intValue.toString();
        }

        widget.onChanged(intValue);
      },
    );
  }
}

/// 숫자 입력 필드 위젯 (실수)
class DecimalInputField extends StatefulWidget {
  final String label;
  final String? suffix;
  final double value;
  final ValueChanged<double> onChanged;
  final String? helperText;
  final double? min;
  final double? max;
  final int decimals;

  const DecimalInputField({
    super.key,
    required this.label,
    this.suffix,
    required this.value,
    required this.onChanged,
    this.helperText,
    this.min,
    this.max,
    this.decimals = 1,
  });

  @override
  State<DecimalInputField> createState() => _DecimalInputFieldState();
}

class _DecimalInputFieldState extends State<DecimalInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(DecimalInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
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
        suffixText: widget.suffix,
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,' + widget.decimals.toString() + r'}')),
      ],
      onChanged: (value) {
        var doubleValue = double.tryParse(value) ?? 0.0;

        // min/max 범위 체크
        if (widget.min != null && doubleValue < widget.min!) {
          doubleValue = widget.min!;
          _controller.text = doubleValue.toString();
        }
        if (widget.max != null && doubleValue > widget.max!) {
          doubleValue = widget.max!;
          _controller.text = doubleValue.toString();
        }

        widget.onChanged(doubleValue);
      },
    );
  }
}
