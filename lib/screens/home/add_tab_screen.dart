import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/models/twitch_stream.dart";
import "package:chitchat/screens/home/stream_card.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class AddTabScreen extends StatefulWidget {
  final void Function(String channelName)? onAdd;

  const AddTabScreen({super.key, this.onAdd});

  @override
  State<AddTabScreen> createState() => _AddTabScreenState();
}

class _AddTabScreenState extends State<AddTabScreen> {
  var loadingStreams = true;
  var loadingMoreStreams = false;
  var channelName = "";

  TwitchStreams? streams;

  @override
  void initState() {
    super.initState();
    _fetchStreams();
  }

  Future<void> _fetchStreams({String? cursor}) async {
    final authStore = context.read<AuthStore>();
    final twitchApi = context.read<TwitchApi>();

    if (authStore.userStore.user == null) {
      return;
    }

    try {
      final fetchedStreams = await twitchApi.getFollowedStreams(
        id: authStore.userStore.user!.id,
        headers: authStore.twitchHeaders,
        cursor: cursor,
      );

      if (cursor != null && streams != null) {
        fetchedStreams.data.insertAll(0, streams!.data);
        streams = fetchedStreams;
      } else {
        streams = fetchedStreams;
      }

      setState(() {
        loadingStreams = false;
        loadingMoreStreams = false;
      });
    } catch (e) {
      debugPrint("Error fetching followed streams: $e");
    }
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: TextField(
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
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilledButton(
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
          ),
          const Divider(height: 36.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
            child: Row(
              children: [
                const Text(
                  "Followed channels",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: loadingStreams || loadingMoreStreams
                      ? null
                      : () {
                          setState(() {
                            loadingStreams = true;
                          });
                          _fetchStreams();
                        },
                ),
              ],
            ),
          ),
          if (loadingStreams)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: (streams?.data.length ?? 0) +
                    (streams?.pagination["cursor"] != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == streams?.data.length &&
                      streams?.pagination["cursor"] != null) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Load more",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (loadingMoreStreams)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3),
                              ),
                            )
                        ],
                      ),
                      onTap: loadingMoreStreams
                          ? null
                          : () {
                              setState(() {
                                loadingMoreStreams = true;
                              });

                              _fetchStreams(
                                  cursor: streams!.pagination["cursor"]);
                            },
                    );
                  }

                  return StreamCard(
                    stream: streams!.data[index],
                    onTap: (stream) {
                      widget.onAdd?.call(stream.userLogin);
                      setState(() {
                        channelName = "";
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
