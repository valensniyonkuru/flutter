import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';
  final ScrollController _expressionScrollController = ScrollController();
  final ScrollController _resultScrollController = ScrollController();
  final ScrollController _mainScrollController = ScrollController();

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          _result = _calculate(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_result.isNotEmpty && !_isOperator(buttonText)) {
          _expression = '';
          _result = '';
        }
        _expression += buttonText;
      }
    });

    // Scroll to end of the expression
    _expressionScrollController
        .jumpTo(_expressionScrollController.position.maxScrollExtent);
  }

  bool _isOperator(String buttonText) {
    return buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '×' ||
        buttonText == '÷' ||
        buttonText == '%' ||
        buttonText == '(' ||
        buttonText == ')';
  }

  String _calculate(String expression) {
    try {
      String modifiedExpression =
          expression.replaceAll('×', '*').replaceAll('÷', '/');
      modifiedExpression = _handlePercentage(modifiedExpression);
      final parser = Parser();
      final expressionAst = parser.parse(modifiedExpression);
      final result =
          expressionAst.evaluate(EvaluationType.REAL, ContextModel());
      return result.toString();
    } catch (e) {
      print('Error: $e'); // Debugging line
      return 'Error';
    }
  }

  String _handlePercentage(String expression) {
    return expression.replaceAll('%', '/100');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF00897B),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Color(0xFF1E1E1E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    controller: _expressionScrollController,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expression,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    controller: _resultScrollController,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _result,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 6,
              child: Scrollbar(
                radius: Radius.circular(8.0),
                controller: _mainScrollController,
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButtonRow(['(', ')', 'C', '÷']),
                      buildButtonRow(['7', '8', '9', '×']),
                      buildButtonRow(['4', '5', '6', '-']),
                      buildButtonRow(['1', '2', '3', '+']),
                      buildButtonRow(['0', '.', '=', '%']),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttonTexts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonTexts
          .map((text) =>
              Flexible(child: CalculatorButton(text, _onButtonPressed)))
          .toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;

  CalculatorButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF64FFDA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          child: Text(
            _text,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          onPressed: () => _onPressed(_text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
