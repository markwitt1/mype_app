import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            title: const Text('Card title 1'),
            subtitle: Text(
              'Secondary Text',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 2'),
              ),
            ],
          ),
          Image.network(
              "https://foldingbed.net/media/ecom/prodlg/32_4200_redafad.jpg"),
        ],
      ),
    );
  }
}
