import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/.rewriting/service/user/user_service.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({super.key, required this.name, required this.onTap});

  final VoidCallback? onTap;
  final String name;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _userService.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title:
                  Text("Loading...", style: TextStyle(color: Colors.black54)),
              subtitle: Text(
                "Fetching data...",
                style: TextStyle(color: Colors.black54),
              ),
            );
          } else if (snapshot.hasError) {
            return const ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text("Error", style: TextStyle(color: Colors.red)),
              subtitle: Text(
                "Failed to load data",
                style: TextStyle(color: Colors.black54),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text("No Data", style: TextStyle(color: Colors.black54)),
              subtitle: Text(
                "User data not found.",
                style: TextStyle(color: Colors.black54),
              ),
            );
          } else {
            final userData = snapshot.data!;
            final userInfo = userData['userInfo'] ?? "No info available";
            final userEmail = userData['email'] ?? "No email available";

            return ListTile(
              leading: const CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title:
                  Text(userInfo, style: const TextStyle(color: Colors.black54)),
              subtitle: Text(
                userEmail,
                style: const TextStyle(color: Colors.black54),
              ),
            );
          }
        },
      ),
    );
  }
}
