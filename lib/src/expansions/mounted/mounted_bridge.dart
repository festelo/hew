part of 'mounted_expansion.dart';

class MountedBridge extends StatelessWidget {
  const MountedBridge({
    Key? key,
    required this.presenter,
    required this.child,
  }) : super(key: key);

  final MountedExpansion presenter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    presenter._setMountedResolver(() => context.mounted);
    return child;
  }
}
