import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class DatabaseService {
  final Databases _databases = Databases(AppwriteConfig.client);

  // List all documents/notes in the collection
  Future<List<Document>> listDocuments({List<String>? queries}) async {
    try {
      // Fetch documents from the specified database and collection
      final response = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: queries,
      );
      // Return the documents list from the response
      return response.documents;
    } catch (e) {
      // Log and rethrow any errors
      print('Error listing documents: $e');
      throw e;
    }
  }
}