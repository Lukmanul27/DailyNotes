import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dailynotes/router/app_route.dart';
import 'package:dailynotes/databases/database.dart';
import 'package:dailynotes/eksensi/format.dart';
import 'package:dailynotes/models/note.dart';
import 'package:sidebarx/sidebarx.dart';

class PageUtama extends StatefulWidget {
  const PageUtama({super.key});

  @override
  State<PageUtama> createState() => _PageUtamaState();
}

class _PageUtamaState extends State<PageUtama> {
  final Databaseservice dbservice = Databaseservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarX(
        controller: SidebarXController(selectedIndex: 0, extended: true),
        items: const [
          SidebarXItem(
            icon: Icons.home,
            label: 'Home',
          ),
          SidebarXItem(
            icon: Icons.lock_outline,
            label: 'Kunci Apps',
          ),
          SidebarXItem(
            icon: Icons.import_export_rounded,
            label: 'Export/Import',
          ),
          SidebarXItem(
            icon: Icons.help_outline,
            label: 'Label',
          ),
          SidebarXItem(
            icon: Icons.settings_applications,
            label: 'Setting',
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 205, 212, 246),
      appBar: AppBar(
        title: const Text("DailyNotes"),
        backgroundColor: Color.fromRGBO(96, 103, 240, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(
            AppRoutes.addNote,
          );
        },
        child: const Icon(
          Icons.add_circle_outline,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Databaseservice.boxName).listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Text("Tidak Ada catatan"),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(box.getAt(index).key.toString()),
                  child: NoteCard(note: box.getAt(index)),
                  onDismissed: (_) async {
                    await dbservice.deleteNotes(box.getAt(index)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "${box.getAt(index).title} Data telah dihapus",
                        ),
                      ));
                    });
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemCount: box.length,
            );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 212, 224, 45),
      ),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRoutes.editNote,
            extra: note,
          );
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.description,
          maxLines: 1,
        ),
        trailing: Text(note.creation.formatDate()),
      ),
    );
  }
}
