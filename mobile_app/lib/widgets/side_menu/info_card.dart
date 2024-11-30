import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/mesh_gradient_background.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({super.key, required this.name});

  final String name;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: ClipOval(
          child: MeshGradientBackgroundPage(
            child: Icon(CupertinoIcons.person),
          ),
        ),
      ),
      title: Text(widget.name,
          style: const TextStyle(color: Colors.black54)),
      subtitle: const Text(
        "User info",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
