import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/person.dart';
import '../models/person_details.dart';
import '../models/person_images.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'image_viewer_screen.dart';

class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  PersonDetailsScreen({required this.person});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  PersonDetails? personDetails;
  PersonImages? personImages;
  bool isLoading = true;
  String? error;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadData();
    checkFavoriteStatus();
  }

  Future<void> loadData() async {
    try {
      final [details, images] = await Future.wait([
        ApiService.fetchPersonDetails(widget.person.id),
        ApiService.fetchPersonImages(widget.person.id),
      ]);

      setState(() {
        personDetails = details as PersonDetails;
        personImages = images as PersonImages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> checkFavoriteStatus() async {
    final favorite = await FavoritesService.isFavorite(widget.person.id);
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.removeFromFavorites(widget.person.id);
    } else {
      await FavoritesService.addToFavorites(widget.person);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            error = null;
                          });
                          loadData();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image and Basic Info
                      Container(
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: personDetails?.profilePath != null
                                      ? CachedNetworkImage(
                                          imageUrl: ApiService.getImageUrl(
                                              personDetails!.profilePath),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[300],
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[300],
                                            child: Icon(Icons.person, size: 50),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: Center(
                                              child:
                                                  Icon(Icons.person, size: 50)),
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      personDetails?.name ?? widget.person.name,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    if (personDetails?.knownForDepartment !=
                                        null)
                                      Text(
                                        personDetails!.knownForDepartment!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    SizedBox(height: 8),
                                    if (personDetails?.birthday != null)
                                      Text(
                                        'Born: ${personDetails!.birthday}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    if (personDetails?.placeOfBirth != null)
                                      Text(
                                        'Place: ${personDetails!.placeOfBirth}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Popularity: ${personDetails?.popularity.toStringAsFixed(1) ?? widget.person.popularity.toStringAsFixed(1)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Biography
                      if (personDetails?.biography != null &&
                          personDetails!.biography!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Biography',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                personDetails!.biography!,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Images Section
                      if (personImages != null &&
                          personImages!.profiles.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Photos (${personImages!.profiles.length})',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: personImages!.profiles.length,
                                itemBuilder: (context, index) {
                                  final imageData =
                                      personImages!.profiles[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImageViewerScreen(
                                            imageUrl: ApiService.getImageUrl(
                                                imageData.filePath,
                                                original: true),
                                            personName: personDetails?.name ??
                                                widget.person.name,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: ApiService.getImageUrl(
                                            imageData.filePath),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.grey[300],
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Colors.grey[300],
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
