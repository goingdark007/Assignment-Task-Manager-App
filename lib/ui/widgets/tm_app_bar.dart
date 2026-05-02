import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {

  const TMAppBar({
    super.key,
  });

  // @override
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final userModel = authProvider.userModel;
    final profilePhoto = userModel?.photo;

    return AppBar(
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          final String? routeName = ModalRoute.of(context)?.settings.name;
          if (routeName == '/update_profile') return; // checking if already on update profile screen
          Navigator.pushNamed(context, '/update_profile');
          },
        child: Row(
          mainAxisAlignment: .start,
          children: [
            CircleAvatar(
                backgroundImage: profilePhoto != null && profilePhoto.isNotEmpty ? MemoryImage(
                  Uint8List.fromList(
                    List<int>.from(jsonDecode(profilePhoto)),
                  ),
                ) : null,
                child: profilePhoto != null ? Icon(Icons.person) : null
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text('${userModel?.firstName ?? 'Loading'} ${userModel?.lastName ?? ' '}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                Text(userModel?.email ?? 'Loading', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white))
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () async {
          await authProvider.clearUserData();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
            icon: Icon(Icons.logout_rounded,color: Colors.white,))
      ],
      centerTitle: true,
      backgroundColor: Colors.lightGreen,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}