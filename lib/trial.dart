import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';

class trial extends StatefulWidget {
  @override
  _trialState createState() => _trialState();
}

class _trialState extends State<trial> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('CupertinoStepper for Flutter'),
      ),
      child: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return _buildStepper(StepperType.horizontal);
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) {
        setState(() => currentStep = step);
      },
      steps: [
        for (var i = 0; i < 3; ++i)
          _buildStep(
            title: Text('Step ${i + 1}'),
            isActive: i == currentStep,
            state: i == currentStep
                ? StepState.editing
                : i < currentStep ? StepState.complete : StepState.indexed,
          ),
      ],
      controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
          Container(),
    );
  }

  Step _buildStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title,
        subtitle: Text(''),
        state: state,
        isActive: isActive,
        content: SizedBox(
          height: 10.0,
        ));
  }
}
