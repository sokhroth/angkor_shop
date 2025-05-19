import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactItems = [
      _ContactItem(
        iconUrl:
            'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6f6878d1-8a56-4e0f-addf-95a2f13a61ab.png',
        label: 'Customer Service',
      ),
      _ContactItem(
        iconUrl:
            'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F489e8f87-a2bd-4d2a-8f4d-8a0ae0c3ba1e.png',
        label: 'Whatsapp',
      ),
      _ContactItem(
        iconUrl:
            'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F671543aa-24fa-4c63-bc42-719cbf5c7921.png',
        label: 'Facebook',
      ),
      _ContactItem(
        iconUrl:
            'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F0df2f67e-77ea-4b00-8dc8-01b3ef2d061c.png',
        label: 'Instagram',
      ),
      _ContactItem(
        iconUrl:
            'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4f070b08-2c14-4e98-8657-9e402656411a.png',
        label: 'Twitter',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Color(0xCC000000),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 0, color: Color(0x19000000)),
          const SizedBox(height: 12),
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xBF000000),
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF00CFFF),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 20),
          ...contactItems.map((item) => _ContactTile(item: item)).toList(),
        ],
      ),
    );
  }
}

class _ContactItem {
  final String iconUrl;
  final String label;

  _ContactItem({required this.iconUrl, required this.label});
}

class _ContactTile extends StatelessWidget {
  final _ContactItem item;

  const _ContactTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 3)],
      ),
      child: Row(
        children: [
          Image.network(item.iconUrl, width: 25, height: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                color: Color(0xB2000000),
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lato',
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
