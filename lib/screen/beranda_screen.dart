import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/data_saya.dart';
import 'pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<Dosen> daftarDosen = [];

  @override
  void initState() {
    super.initState();
    loadDosenData();
  }

  Future<void> loadDosenData() async {
    final String data =
        await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> jsonList = jsonDecode(data);
    setState(() {
      daftarDosen = jsonList.map((e) => Dosen.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'WhAzlansaja',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(
                    child: Text(
                      'Belum ada pencarian',
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      body: daftarDosen.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: daftarDosen.length,
              itemBuilder: (context, index) {
                final dosen = daftarDosen[index];
                final lastChat = dosen.details.isNotEmpty
                    ? dosen.details.last.message
                    : 'Belum ada chat';

                final lastChatTime = dosen.details.isNotEmpty
                    ? TimeOfDay.fromDateTime(DateTime.parse(dosen.details.last.time))
                        .format(context)
                    : '';

                return ListTile(
                  onTap: () async {
                    final updatedDosen = await Navigator.push<Dosen>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PesanScreen(dosen: dosen),
                      ),
                    );

                    if (updatedDosen != null) {
                      setState(() {
                        daftarDosen[index] = updatedDosen;
                      });
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(dosen.img),
                  ),
                  title: Text(dosen.name.split(',')[0]),
                  subtitle: Text(lastChat),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lastChatTime,
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (dosen.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${dosen.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat), 
            label: 'Chat'),
          NavigationDestination(
            icon: Icon(Icons.sync), 
            label: 'Pembaruan'),
          NavigationDestination(
            icon: Icon(Icons.groups), 
            label: 'Komunitas'),
          NavigationDestination(
            icon: Icon(Icons.call), 
            label: 'Panggilan'),
        ],
     ),
);
}
}