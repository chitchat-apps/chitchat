import "package:flutter/material.dart";

class AddTabScreen extends StatefulWidget {
  final void Function(String channelName)? onAdd;

  const AddTabScreen({super.key, this.onAdd});

  @override
  State<AddTabScreen> createState() => _AddTabScreenState();
}

class _AddTabScreenState extends State<AddTabScreen> {
  var channelName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a channel"),
        leading: IconButton(
          tooltip: "Back",
          icon: Icon(Icons.adaptive.arrow_back_rounded, size: 20),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter a channel name",
              ),
              onChanged: (value) => setState(() => channelName = value),
              onSubmitted: (value) {
                widget.onAdd?.call(value);
                setState(() {
                  channelName = "";
                });
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 16.0),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                widget.onAdd?.call(channelName);
                setState(() {
                  channelName = "";
                });
                Navigator.of(context).pop();
              },
              child: const Text("Add channel"),
            ),
          ],
        ),
      ),
    );
  }
}
