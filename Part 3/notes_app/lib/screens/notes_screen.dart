import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import '../services/appwrite_config.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';
import '../providers/auth_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Pass the user ID when fetching notes
      final fetchedNotes = await _noteService.getNotes(authProvider.user!.$id);
      setState(() {
        _notes = fetchedNotes.cast<Document>();
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch notes: $e');
      setState(() {
        _isLoading = false;
        _error = 'Failed to load notes. Please check your connection.';
      });
    }
  }

  Future<void> _addNote(String text) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    try {
      // Pass the user ID when adding a note
      final newNote = await _noteService.addNote(text, authProvider.user!.$id);
      if (newNote != null) {
        setState(() {
          _notes.insert(0, newNote as Document);
        });
        Navigator.of(context).pop(); // Close the modal
      }
    } catch (e) {
      print('Failed to add note: $e');
    }
  }

  // Show the add note dialog
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // Add the new note to the state and avoid refetching
  void _handleNoteAdded(Map<String, dynamic> noteData) {
    // Create a temporary Document object
    final newNote = Document(
      $id: noteData['\$id'] ?? 'temp-id',
      $collectionId: AppwriteConfig.collectionId,
      $databaseId: AppwriteConfig.databaseId,
      $createdAt: DateTime.now().toString(),
      $updatedAt: DateTime.now().toString(),
      $permissions: [],
      data: noteData,
    );

    setState(() {
      _notes = [newNote, ..._notes];
    });
  }

  // Handle note deletion by removing it from state
  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes = _notes.where((note) => note.$id != noteId).toList();
    });
  }

  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You don't have any notes yet.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tap the + button to create your first note!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? _buildEmptyNotesView()
              : RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        note: _notes[index],
                        onNoteDeleted: _handleNoteDeleted,
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}