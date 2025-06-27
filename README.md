# Famous Personalities App

## 📱 About

A Flutter app that showcases famous personalities using the [TMDB API](https://www.themoviedb.org/documentation/api).  
It displays popular celebrities along with their profile details, movies, and more.

## 🚀 Features

- Fetches data from TMDB API  
- Displays famous personalities with photos and bios  
- Image zooming with PhotoView  
- Caching and efficient image loading  
- Save and share functionality  
- Clean and responsive UI

## 🛠️ Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/your-username/famous-personalities-app.git
cd famous-personalities-app
```

# Run the app
flutter pub get
flutter run

## Dependencies
The app uses the following packages:
http ^0.13.6 – For API requests
shared_preferences ^2.2.2 – For storing simple data
cached_network_image ^3.3.0 – For image caching
photo_view ^0.14.0 – For zoomable image views
path_provider ^2.1.1 – For accessing local file system
permission_handler ^11.1.0 – For runtime permissions
dio ^5.3.3 – Advanced networking
photo_manager ^3.0.0 – For managing device media
share_plus ^7.2.1 – For sharing content
