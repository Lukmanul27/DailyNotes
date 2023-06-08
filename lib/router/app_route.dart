import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dailynotes/models/note.dart';
import 'package:dailynotes/pages/add_note_page.dart';
import 'package:dailynotes/pages/page_utama.dart';

class AppRoutes {
  static const home = "home";
  static const addNote = "add-note";
  static const editNote = "edit-note";
  static const sidesBar = "side-bar";

  static Page _homePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: PageUtama(),
    );
  }

  static Page _addNotePageBuider(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: AddNotePage(),
    );
  }

  static Page _editNotePageBuider(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage(
      child: AddNotePage(
        note: state.extra as Note,
      ),
    );
  }

  static Page _sidebarPageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage(
      key: state.pageKey,
      child: PageUtama(),
    );
  }

  static GoRouter goRouter = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        name: home,
        path: "/",
        pageBuilder: _homePageBuilder,
        routes: [
          GoRoute(
            name: addNote,
            path: "add-note",
            pageBuilder: _addNotePageBuider,
          ),
          GoRoute(
            name: editNote,
            path: "edit-note",
            pageBuilder: _editNotePageBuider,
          ),
          GoRoute(
            name: sidesBar,
            path: "side-bar",
            pageBuilder: _sidebarPageBuilder,
          ),
        ],
      ),
    ],
  );
}
