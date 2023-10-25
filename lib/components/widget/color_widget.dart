import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorSelect extends StatefulWidget {
  final Function(Color, BuildContext) onColorSelected;
  final Color previousColor;
  const ColorSelect({super.key, required this.onColorSelected, this.previousColor = Colors.black});

  @override
  State<ColorSelect> createState() => _ColorSelectState();
}

class _ColorSelectState extends State<ColorSelect> {
  double redValue = 0.0;
  double greenValue = 0.0;
  double blueValue = 0.0;
  @override
  void initState() {
    super.initState();
    redValue = widget.previousColor.red.toDouble();
    greenValue = widget.previousColor.green.toDouble();
    blueValue = widget.previousColor.blue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    return SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, redValue.round(), greenValue.round(), blueValue.round()),
              borderRadius: BorderRadius.circular(30),
            ),
            width: double.infinity,
            height: 100,
          ),
          //Red
          Slider(
            activeColor: Colors.red,
            inactiveColor: Theme.of(context).primaryColor,
            value: redValue,
            min: 0.0,
            max: 255.0,
            onChanged: (value) => {
              setState(() => redValue = value),
            },
          ),
          //Green
          Slider(
            activeColor: Colors.green,
            inactiveColor: Theme.of(context).primaryColor,
            value: greenValue,
            min: 0.0,
            max: 255.0,
            onChanged: (value) => {
              setState(() => greenValue = value),
            },
          ),
          //Blue
          Slider(
            activeColor: Colors.blue,
            inactiveColor: Theme.of(context).primaryColor,
            value: blueValue,
            min: 0.0,
            max: 255.0,
            onChanged: (value) => {
              setState(() => blueValue = value),
            },
          ),
          //Confirm
          ElevatedButton(
            onPressed: () => widget.onColorSelected(Color.fromARGB(255, redValue.round(), greenValue.round(), blueValue.round()), context),
            child: Text(Language.Translate("response_confirm", options.language) ?? "Confirm"),
          ),
        ],
      ),
    );
  }
}
