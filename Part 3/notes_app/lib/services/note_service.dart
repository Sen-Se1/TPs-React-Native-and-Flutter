import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class NoteService {
  final Databases databases;

  NoteService() : databases = Databases(AppwriteConfig.client);

  Future<List<Document>> getNotes(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: [
          Query.equal('userId', userId) // Filter by user_id
        ],
      );

      return response.documents;
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  Future<Document?> addNote(String text, String userId) async {
    try {
      final response = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: ID.unique(),
        data: {
          'text': text,
          'userId': userId // Add user ID to the note
        },
      );

      return response;
    } catch (e) {
      print('Error adding note: $e');
      return null;
    }
  }

  Future<Document> createNote(Map<String, dynamic> data) async {
    try {
      // Create a document in the database
      final response = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: ID.unique(), // Generate a unique ID
        data: data,
      );

      return response;
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      // Delete the document with the specified ID
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: noteId,
      );

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Update an existing note
  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      // Update the document in the database
      final response = await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: noteId,
        data: data,
      );

      return response;
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }
}