# Recipe App - Flutter Application

A beautiful Flutter application that allows users to explore recipes from TheMealDB API and save their favorite recipes locally.

## Features

### 1. Authentication (15%)
- **Register**: Create a new account with username and password validation
- **Login**: Sign in to your account
- **Logout**: Securely logout and clear session data
- Data stored locally using SharedPreferences

### 2. Home Page (35%)
- Browse recipes using GridView with 2-column layout
- Display recipe image and name for each item
- Loading indicators while fetching data from API
- BottomNavigationBar with Home and Favorite tabs
- Logout button in AppBar for quick access

### 3. Detail Page (25%)
- Full recipe details including:
  - High-quality recipe image
  - Recipe name, category, and origin country
  - Complete list of ingredients with measurements
  - Detailed cooking instructions
- Add/Remove from favorites with visual feedback
- Button state changes based on favorite status

### 4. Favorite Page (25%)
- View all saved favorite recipes
- Persistent storage using Hive database
- Delete recipes from favorites with confirmation
- Click to view recipe details

## Getting Started

### Prerequisites
- Flutter SDK (3.11.0 or higher)
- Dart SDK
- Android Studio or Xcode for emulator/device

### Installation

1. **Clone or extract the project**
   ```bash
   cd flutter_application_1
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── models/
│   ├── recipe.dart          # Recipe data model
│   └── user.dart            # User data model
├── services/
│   ├── api_service.dart     # TheMealDB API integration
│   ├── auth_service.dart    # Authentication with SharedPreferences
│   └── favorites_service.dart # Hive database for favorites
└── views/
    ├── auth/
    │   ├── login_page.dart  # Login page
    │   └── register_page.dart # Register page
    ├── home/
    │   └── home_page.dart   # Home page with GridView
    ├── detail/
    │   └── detail_page.dart # Recipe detail page
    └── favorites/
        └── favorites_page.dart # Favorite recipes page
```

## Dependencies

- **http**: For API requests to TheMealDB
- **shared_preferences**: For storing user credentials
- **hive**: For local database storage of favorites
- **hive_flutter**: Flutter integration for Hive
- **provider**: State management (optional, can be added for advanced features)

## API Integration

The app uses **TheMealDB API** (https://www.themealdb.com/api/json/v1/1/)

### Endpoints Used:
- `/filter.php?c={category}` - Fetch recipes by category
- `/search.php?f={query}` - Search recipes by first letter
- `/lookup.php?i={id}` - Get detailed recipe information

## How to Use

### Registration
1. Open the app
2. Tap "Register" on the login page
3. Enter username, password, and confirm password
4. Tap "Register" button
5. Automatically redirected to login page

### Login
1. Enter your username and password
2. Tap "Login" button
3. Navigate to home page on success

### Browse Recipes
1. View recipes in a grid format
2. Tap any recipe to view details
3. Use BottomNavigationBar to switch between Home and Favorites

### Save Favorites
1. On detail page, tap the heart icon to add to favorites
2. Icon fills when added successfully
3. Favorites persist even after closing the app

### View Favorites
1. Tap "Favorite" tab in BottomNavigationBar
2. View all saved recipes
3. Tap a recipe to view its details
4. Swipe left or tap delete icon to remove from favorites

### Logout
1. Tap logout icon in AppBar
2. Confirm logout
3. Redirected to login page

## Technical Details

### Architecture
- **Model-View-Service** pattern for clean architecture
- Separation of concerns with dedicated service classes
- Future-based asynchronous programming

### Local Storage
- **SharedPreferences**: User credentials and session management
- **Hive**: Fast, efficient local database for favorites

### Error Handling
- Try-catch blocks for API calls
- User-friendly error messages
- Retry functionality on failed requests

## Testing

### Manual Testing Checklist
- [ ] Register with new username
- [ ] Login with registered account
- [ ] View recipes on home page
- [ ] Click on recipe to view details
- [ ] Add recipe to favorites
- [ ] Check favorite button state changes
- [ ] View favorites page
- [ ] Delete from favorites
- [ ] Close and reopen app - verify favorites persist
- [ ] Logout successfully
- [ ] Login again to verify account persists

## Known Limitations
- Home page currently shows Seafood category. Can be expanded with category selection
- No network image caching (can be optimized with cached_network_image package)

## Future Enhancements
- Category filter dropdown on home page
- Search functionality for recipes
- Recipe ratings and reviews
- Meal planning features
- Offline mode with cached recipes
- Push notifications for new recipes

## Troubleshooting

### App crashes on startup
- Run `flutter clean` then `flutter pub get`
- Ensure all dependencies are properly installed

### Favorites not persisting
- Check that Hive initialization completes in main()
- Verify app has write permissions

### API errors
- Check internet connection
- Verify TheMealDB API is accessible
- Check for rate limiting

## License
This project is created for educational purposes.

## Support
For issues or questions, please refer to the Flutter documentation:
- Flutter: https://flutter.dev/docs
- TheMealDB API: https://www.themealdb.com/documentation

---

**Happy Cooking! 🍳**
