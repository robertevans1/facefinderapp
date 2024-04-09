import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ListView(
          children: const <Widget>[
            _HomeListTile(title: 'Simple Text Test', route: '/text_test'),
            _HomeListTile(title: 'Blur Image', route: '/blur_image'),
          ],
        ),
      ),
    );
  }
}

class _HomeListTile extends StatelessWidget {
  final String title;
  final String route;

  const _HomeListTile({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, route),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      // Custom styling
      selectedTileColor: Colors.grey[300], // Background color when selected
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Adjust padding
    );
  }
}
