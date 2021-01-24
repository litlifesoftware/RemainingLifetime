import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/model/goal.dart';

class GoalPreviewCardActionButton extends StatefulWidget {
  final Goal goal;
  final bool darkMode;
  final TextEditingController textEditingController;
  final void Function() saveGoalCallback;

  /// Create a [GoalPreviewCardActionButton] used to conditionally render the
  /// action button on the [GoalPreviewCard].
  ///
  /// If the provided [Goal] title and the currently entered text are different,
  /// allow the User to save his input.
  const GoalPreviewCardActionButton({
    Key key,
    @required this.goal,
    @required this.darkMode,
    @required this.textEditingController,
    @required this.saveGoalCallback,
  }) : super(key: key);

  @override
  _GoalPreviewCardActionButtonState createState() =>
      _GoalPreviewCardActionButtonState();
}

class _GoalPreviewCardActionButtonState
    extends State<GoalPreviewCardActionButton> with TickerProviderStateMixin {
  AnimationController _saveButtonAnimation;

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
      builder: (BuildContext context, Widget child) {
        return widget.goal.title != widget.textEditingController.text
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Transform.scale(
                  scale: 1 + (_saveButtonAnimation.value * 0.2),
                  child: InkWell(
                    splashColor: Colors.black,
                    onTap: widget.saveGoalCallback,
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
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(widget.darkMode ? 0.5 : 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 14.0,
                    ),
                    child: Text(
                      // Increase the id by one to display the month number.
                      "# ${widget.goal.id + 1}",
                      style: LitTextStyles.sansSerif.copyWith(
                        fontSize: 16.5,
                        color: widget.darkMode ? Colors.white : Colors.black45,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
