# Quick Start Guide - Recipe App

## Prerequisites
Make sure you have:
- ✅ Flutter SDK installed (3.11.0+)
- ✅ Android Studio or Xcode
- ✅ An Android emulator or iOS simulator running
- ✅ Internet connection for API calls

## Setup Steps

### 1. Navigate to Project Directory
```bash
cd c:\Users\User\Documents\ngoding\mobile\tugasprak\flutter_application_1
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

Or specify a device:
```bash
flutter run -d chrome    # Web
flutter run -d emulator-5554  # Android emulator
```

## First Time Setup Checklist

- [ ] Dependencies installed successfully
- [ ] No compilation errors
- [ ] App launches on emulator/device
- [ ] Login page displays

## Example Test Data

Use these credentials to test:

### First Time User
- Tap "Register"
- Username: `testuser`
- Password: `password123`
- Confirm Password: `password123`
- Tap Register → Redirects to Login

### Login
- Username: `testuser`
- Password: `password123`
- Tap Login → Home page with recipes

## Testing Features

### 1. Home Page
- See recipes in grid format
- Scroll to view more recipes
- Each card shows recipe image and name

### 2. View Recipe Detail
- Tap any recipe card
- See full details: ingredients, instructions, category, country
- Heart icon on top right to add to favorites

### 3. Add to Favorites
- On detail page, tap heart icon
- Icon fills with red color
- Bottom message confirms addition

### 4. View Favorites
- Back to home page
- Tap "Favorite" tab in bottom navigation
- See list of saved recipes
- Can delete by tapping trash icon

### 5. Persistence Test
- Add a favorite recipe
- Close the app completely
- Reopen the app
- Login again
- Go to Favorites → Recipe should still be there

### 6. Logout
- On home page, tap logout icon in top-right
- Confirm logout
- Redirected to login page
- All favorites remain saved for next login

## Common Issues & Solutions

### "Packages not found"
```bash
flutter clean
flutter pub get
flutter run
```

### "API calls failing"
- Check internet connection
- Verify device can access https://www.themealdb.com
- Try restarting the app

### "Favorites not saving"
- Ensure Hive initialization completes
- Check device storage permissions
- Try deleting app and reinstalling

### "Black screen on startup"
- Wait 3-5 seconds for auth check to complete
- Check debug console for errors
- Run with: `flutter run -v`

## Build Commands

### Debug Build
```bash
flutter build apk --debug  # Android
flutter build ios          # iOS
```

### Release Build
```bash
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Debugging

### View Logs
```bash
flutter logs
```

### Run with Verbose Output
```bash
flutter run -v
```

### Connect to Specific Device
```bash
flutter devices          # List connected devices
flutter run -d <device>  # Run on specific device
```

## Development Notes

### Project Structure
```
lib/
├── main.dart              ← App entry point
├── models/                ← Data models
├── services/              ← Business logic
└── views/                 ← UI pages
```

### Key Files to Modify
- `lib/services/api_service.dart` - Change default category in home page
- `lib/main.dart` - Modify routes or theme
- `pubspec.yaml` - Add more dependencies

## API Testing

To test API directly before running app:

1. Open browser and visit:
   ```
   https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood
   ```

2. Or use Postman to test:
   - GET: `https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772`

## Performance Tips

- Images are loaded from network - may be slow on slow connections
- First load might take 3-5 seconds
- Favorites search/filter can be added for better UX

## Next Steps / Enhancements

- [ ] Add category filter dropdown
- [ ] Search by recipe name
- [ ] Add more filters (difficulty, time, etc.)
- [ ] Cache recipe images locally
- [ ] Add favorites counter
- [ ] Create settings page
- [ ] Add recipe sharing feature
- [ ] Dark mode support

---

**Ready to test! 🚀**

For more detailed information, see `GUIDE.md`
