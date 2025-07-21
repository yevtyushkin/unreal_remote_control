import 'package:shadcn_flutter/shadcn_flutter.dart';

class SendRefreshButtons extends StatelessWidget {
  const SendRefreshButtons({
    required this.send,
    required this.refresh,
    super.key,
  });

  final VoidCallback send;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button.primary(
          onPressed: send,
          child: const Text('Send'),
        ),
        const Gap(8),
        Button.secondary(
          onPressed: refresh,
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}
