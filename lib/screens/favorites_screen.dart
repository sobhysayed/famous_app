import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/person.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'person_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Person> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favoritesList = await FavoritesService.getFavorites();
    setState(() {
      favorites = favoritesList;
      isLoading = false;
    });
  }

  Future<void> removeFromFavorites(Person person) async {
    await FavoritesService.removeFromFavorites(person.id);
    setState(() {
      favorites.removeWhere((p) => p.id == person.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${person.name} removed from favorites'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await FavoritesService.addToFavorites(person);
            loadFavorites();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add some famous persons to your favorites list',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final person = favorites[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: person.profilePath != null
                              ? CachedNetworkImageProvider(
                                  ApiService.getImageUrl(person.profilePath),
                                )
                              : null,
                          child: person.profilePath == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          person.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: person.knownForDepartment != null
                            ? Text(person.knownForDepartment!)
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '★ ${person.popularity.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => removeFromFavorites(person),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PersonDetailsScreen(person: person),
                            ),
                          ).then(
                              (_) => loadFavorites()); // Refresh when returning
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
