import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class EditPreferencesPopup extends StatefulWidget {
  EditPreferencesPopup(
      {Key key, this.callback, this.valueToDisplay, this.initValue})
      : super(key: key);

  final List<String> valueToDisplay;
  final List<String> initValue;
  final Function(List<String>) callback;

  @override
  _EditPreferencesPopupState createState() => _EditPreferencesPopupState();
}

class _EditPreferencesPopupState extends State<EditPreferencesPopup> {
  List<String> selectedOptions;

  @override
  void initState() {
    // TODO: implement initState
    selectedOptions = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 15,
              children: List<Widget>.generate(
                  widget.valueToDisplay.length,
                  (index) => ChoiceChip(
                      backgroundColor: Color(0xff424242),
                      selectedColor: Color(0xff424242),
                      labelPadding: EdgeInsets.zero,
                      labelStyle: TextStyles()
                          .regularTextStyle()
                          .copyWith(fontSize: 14, color: Colors.white),
                      onSelected: (selected) {
                        setState(() {
                          if (selectedOptions
                              .contains(widget.valueToDisplay[index])) {
                            selectedOptions
                                .remove(widget.valueToDisplay[index]);
                          } else if (selectedOptions.length < 3) {
                            selectedOptions.add(widget.valueToDisplay[index]);
                          }
                        });
                      },
                      label: Container(
                          padding: EdgeInsets.zero,
                          height: 30,
                          decoration: BoxDecoration(
                              gradient: selectedOptions
                                      .contains(widget.valueToDisplay[index])
                                  ? TextStyles().baseGrad()
                                  : null,
                              borderRadius: BorderRadius.circular(15.0)),
                          width: 80,
                          child: Center(
                            child: Text(
                              widget.valueToDisplay[index],
                              textAlign: TextAlign.center,
                            ),
                          )),
                      selected: selectedOptions
                          .contains(widget.valueToDisplay[index]))).toList()),
        ),
      ]),
      actions: [
        GradientButton(
          gradient: TextStyles().baseGrad(),
          child: Text("Cancel"),
          callback: () => Navigator.pop(context),
        ),
        GradientButton(
          gradient: TextStyles().baseGrad(),
          callback: () {
            widget.callback(selectedOptions);
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        )
      ],
    );
  }
}
