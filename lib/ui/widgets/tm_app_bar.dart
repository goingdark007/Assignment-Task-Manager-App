import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {

  const TMAppBar({
    super.key,
  });

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Helper to ensure UI updates once data is loaded
  Future<void> _loadUserData() async {
    await AuthController.getUserData();
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: InkWell(
        onTap: () => Navigator.pushNamed(context, '/update_profile'),
        child: Row(
          mainAxisAlignment: .start,
          children: [
            CircleAvatar(backgroundColor: Colors.lightGreen.shade300),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(AuthController.userModel?.email ?? 'Loading', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                Text(AuthController.userModel?.mobile ?? 'Loading', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white))
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () async {
          await AuthController.clearUserData();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
            icon: Icon(Icons.logout_rounded,color: Colors.white,))
      ],
      centerTitle: true,
      backgroundColor: Colors.lightGreen,
    );
  }
}