import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/model/goal.dart';

/// A widget conditionally displaying the either a label or a button.
///
/// If the provided [Goal] title and the currently entered text are different,
/// allow the User to save his input.
class GoalCardActionButton extends StatefulWidget {
  final Goal goal;
  final bool darkMode;
  final TextEditingController textEditingController;
  final void Function() saveGoalCallback;

  /// Create a [GoalCardActionButton].
  const GoalCardActionButton({
    Key? key,
    required this.goal,
    required this.darkMode,
    required this.textEditingController,
    required this.saveGoalCallback,
  }) : super(key: key);

  @override
  _GoalCardActionButtonState createState() => _GoalCardActionButtonState();
}

class _GoalCardActionButtonState extends State<GoalCardActionButton>
    with TickerProviderStateMixin {
  late AnimationController _saveButtonAnimation;

  bool get _modified {
    return widget.goal.title != widget.textEditingController.text;
  }

  @override
  void initState() {
    super.initState();
    _saveButtonAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _saveButtonAnimation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _saveButtonAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _saveButtonAnimation,
      builder: (BuildContext context, Widget? child) {
        return _modified
            ? _SaveButton(
                animationController: _saveButtonAnimation,
                onPressed: widget.saveGoalCallback,
              )
            : _GoalNumberLabel(
                darkMode: widget.darkMode,
                goal: widget.goal,
              );
      },
    );
  }
}

/// A widget displaying the [goal]'s number.
class _GoalNumberLabel extends StatelessWidget {
  final bool darkMode;
  final Goal goal;
  const _GoalNumberLabel({
    Key? key,
    required this.darkMode,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(darkMode ? 0.5 : 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 14.0,
          ),
          child: Text(
            // Increase the id by one to display the month number.
            "# ${goal.id! + 1}",
            style: LitSansSerifStyles.body2.copyWith(
              color: darkMode ? Colors.white : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget allowing to save the user's changes.
class _SaveButton extends StatelessWidget {
  final AnimationController animationController;
  final void Function() onPressed;
  const _SaveButton({
    Key? key,
    required this.animationController,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Transform.scale(
        scale: 1 + (animationController.value * 0.2),
        child: InkWell(
          splashColor: Colors.black,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white70,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Icon(
                  LitIcons.disk_alt,
                  color: LitColors.mediumGrey,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
