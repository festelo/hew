part of 'mounted_expansion.dart';

/// Brige between [MountedExpansion] and Widgets (Elements) tree that bind
/// [MountedExpansion.mounted] field's value with `mounted` state of this widget.
///
/// Usually you want to use this widget with `Presenter` that mixes in with [MountedExpansion].
/// You don't need to use this widget directly if you use default configuration of [HewConfiguration]
/// and [BridgeHook] widget, [PresenterWidget], [PresenterStatefulWidget] or [PresenterBuilder].
class MountedBridge extends StatelessWidget {
  /// Creates [MountedBridge] and binds [presenter]'s [MountedExpansion.mounted] state.
  /// Builds [child] without any changes.
  const MountedBridge({
    Key? key,
    required this.presenter,
    required this.child,
  }) : super(key: key);

  /// Presenter that should be connected with this widget.
  final MountedExpansion presenter;

  /// Child passed directly to [build] method of this widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    presenter._setMountedResolver(() => context.mounted);
    return child;
  }
}
