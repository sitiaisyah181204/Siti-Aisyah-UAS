import 'package:flutter/material.dart';
import 'package:whazlansaja/data_saya.dart';

class PesanScreen extends StatefulWidget {
  final dosen;

  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  late Dosen selectedDosen;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDosen = widget.dosen;
    selectedDosen.unreadCount = 0; // reset unread saat dibuka
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      selectedDosen.details.add(
        ChatDetail(
          role: "user",
          message: text,
          time: DateTime.now().toIso8601String(),
        ),
      );
    });

    _controller.clear();
  }

  void _popWithUpdatedDosen() {
    Navigator.pop(context, selectedDosen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        _popWithUpdatedDosen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _popWithUpdatedDosen,
          ),
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: AssetImage(selectedDosen.img),
              radius: 16,
            ),
            title: Text(
              selectedDosen.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: const Text('Online'),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedDosen.details.length,
                itemBuilder: (context, index) {
                  final chat = selectedDosen.details[index];
                  final isDosen = chat.role == "dosen";
                  final chatTime = TimeOfDay.fromDateTime(DateTime.parse(chat.time)).format(context);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: isDosen ? MainAxisAlignment.start : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isDosen)
                          CircleAvatar(
                            backgroundImage: AssetImage(selectedDosen.img),
                            radius: 14,
                          ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.65,
                            ),
                            decoration: BoxDecoration(
                              color: isDosen ? colorScheme.tertiary : colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isDosen ? 0 : 12),
                                bottomRight: Radius.circular(isDosen ? 12 : 0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.message,
                                  style: TextStyle(
                                    color: isDosen ? colorScheme.onTertiary : colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chatTime,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isDosen)
                          CircleAvatar(
                            backgroundImage: AssetImage(DataSaya.gambar),
                            radius: 14,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: _controller,
                onFieldSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.emoji_emotions),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                  hintText: 'Ketikkan pesan',
                  filled: true,
                ),
              ),
            ),
          ],
        ),
     ),
);
}
}