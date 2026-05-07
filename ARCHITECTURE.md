# Recipe App - Architecture Documentation

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      USER INTERFACE                         │
│  ┌──────────────┬──────────────┬──────────────┬───────────┐ │
│  │ Login Page   │ Register Page│  Home Page   │ Detail Page│ │
│  │              │              │   GridView   │ Favorites │ │
│  │              │              │   + NavBar   │  Toggle   │ │
│  └──────────────┴──────────────┴──────────────┴───────────┘ │
│                           ▲                                   │
└───────────────────────────┼───────────────────────────────────┘
                            │ Navigation
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    CONTROLLERS/PROVIDERS                     │
│              (State Management Layer)                        │
│  (Optional: Provider, GetX for advanced features)           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      SERVICES LAYER                          │
│  ┌────────────────┬─────────────────┬──────────────────┐   │
│  │ ApiService     │ AuthService     │ FavoritesService │   │
│  │ ────────────   │ ────────────    │ ────────────────│   │
│  │ • Fetch by Cat │ • Register      │ • Init Hive      │   │
│  │ • Fetch by ID  │ • Login         │ • Add/Remove     │   │
│  │ • Error Handle │ • Logout        │ • Get All        │   │
│  │                │ • Check Login   │ • Is Favorite    │   │
│  └────────────────┴─────────────────┴──────────────────┘   │
└──────┬──────────────────────────────────┬──────────────────┘
       │                                  │
       ▼                                  ▼
┌──────────────────────────    ───────────────────────────┐
│  TheMealDB API               │ Local Storage Layer      │
│  ────────────────            │ ──────────────────       │
│  • filter.php?c=Seafood      │ SharedPreferences:      │
│  • lookup.php?i={id}         │ • User credentials      │
│  • search.php?f={letter}     │ • Session token         │
│                              │                         │
│                              │ Hive Database:          │
│                              │ • Favorite recipes      │
│                              │ • Recipe metadata       │
└──────────────────────────    ───────────────────────────┘
```

## Data Flow

### 1. Authentication Flow
```
User Input (Login/Register)
         ↓
   AuthService
         ↓
SharedPreferences (Store/Verify)
         ↓
   Success/Error
         ↓
   Navigation to Home or Error Message
```

### 2. Recipe Discovery Flow
```
Home Page Load
         ↓
  ApiService.fetchRecipesByCategory('Seafood')
         ↓
  HTTP Request to TheMealDB
         ↓
  Parse JSON Response
         ↓
  Build Model Objects
         ↓
  Display in GridView
```

### 3. Recipe Detail Flow
```
User Taps Recipe Card
         ↓
  Navigate to Detail Page (Pass Recipe ID)
         ↓
  ApiService.fetchRecipeDetail(recipeId)
         ↓
  Check if Favorite (FavoritesService.isFavorite)
         ↓
  Display Recipe Details + Toggle Button State
```

### 4. Favorites Flow
```
User Taps Heart Icon
         ↓
  Check Current State
         ↓
  If Not Favorite:
    FavoritesService.addFavorite(recipe)
    Save to Hive
    Update UI
         ↓
  If Favorite:
    FavoritesService.removeFavorite(recipeId)
    Remove from Hive
    Update UI
```

## Model Relationships

```
┌──────────────────┐
│      User        │
├──────────────────┤
│ - username: String
│ - password: String
└──────────────────┘
         │
         ├─► Stored in SharedPreferences
         │
         └─► Used for Authentication

┌──────────────────────────────┐
│       Recipe                 │
├──────────────────────────────┤
│ - id: String                 │
│ - name: String               │
│ - image: String (URL)        │
│ - category: String           │
│ - area: String               │
│ - instructions: String       │
│ - ingredients: List<String>  │
│ - measures: List<String>     │
└──────────────────────────────┘
         │
         ├─► From API (Dynamic)
         │
         └─► Stored in Hive (Favorites)
```

## File Organization

```
lib/
├── main.dart
│   ├── Initializes Hive
│   ├── Sets up routing
│   ├── Checks auth state
│   └── Builds MaterialApp
│
├── models/
│   ├── recipe.dart ─────────► Recipe data structure
│   └── user.dart ───────────► User data structure
│
├── services/
│   ├── api_service.dart
│   │   ├── fetchRecipesByCategory()
│   │   ├── fetchRecipesByLetter()
│   │   └── fetchRecipeDetail()
│   │
│   ├── auth_service.dart
│   │   ├── register()
│   │   ├── login()
│   │   ├── logout()
│   │   ├── getCurrentUser()
│   │   └── isLoggedIn()
│   │
│   └── favorites_service.dart
│       ├── initHive()
│       ├── addFavorite()
│       ├── removeFavorite()
│       ├── getAllFavorites()
│       ├── isFavorite()
│       └── RecipeAdapter (Hive serialization)
│
└── views/
    ├── auth/
    │   ├── login_page.dart ────► Authentication UI
    │   └── register_page.dart
    │
    ├── home/
    │   └── home_page.dart
    │       ├── GridView layout
    │       ├── Bottom nav bar
    │       ├── Logout button
    │       └── API integration
    │
    ├── detail/
    │   └── detail_page.dart
    │       ├── Full recipe display
    │       ├── Favorite toggle
    │       └── Ingredients list
    │
    └── favorites/
        └── favorites_page.dart
            ├── Hive list display
            ├── Delete functionality
            └── Navigation to detail
```

## Dependency Injection & State Management

### Current Implementation
- Services are static utility classes
- Direct function calls without state management
- Suitable for simple to medium complexity apps

### Potential Enhancement
```dart
// Add Provider/GetX for more complex apps
// Example with Provider:

class RecipeProvider extends ChangeNotifier {
  List<Recipe> recipes = [];
  
  Future<void> fetchRecipes() async {
    recipes = await ApiService.fetchRecipesByCategory('Seafood');
    notifyListeners();
  }
}

// Usage in Widget:
Consumer<RecipeProvider>(
  builder: (context, provider, child) {
    return GridView(...);
  },
)
```

## Error Handling Strategy

```
API Call
    │
    ├─► Success (200)
    │       └─► Parse & Return Data
    │
    ├─► Timeout (> 10 seconds)
    │       └─► Throw Timeout Exception
    │
    ├─► Network Error
    │       └─► Catch & Rethrow with Message
    │
    └─► Caught Exception
            ├─► Show Error UI
            ├─► Display Retry Button
            └─► Log Error
```

## Storage Strategy

### SharedPreferences (Credentials)
- Fast key-value storage
- Suitable for small data (username, password)
- Not suitable for sensitive data without encryption
- User data is simple strings

### Hive (Favorites)
- NoSQL embedded database
- Better for complex objects (Recipe)
- Faster than SharedPreferences
- Supports custom type adapters
- Better for large datasets

## Security Considerations

### Current Implementation
- Passwords stored in plain text (⚠️ Development Only)
- No encryption on SharedPreferences (⚠️ Development Only)

### Recommended Enhancements
- Use flutter_secure_storage for passwords
- Implement token-based authentication
- Use HTTPS for all API calls (✅ Already done)
- Add input validation (✅ Already done)

## Performance Optimizations

### Implemented
- ✅ HTTP timeouts (10 seconds)
- ✅ Error boundary handling
- ✅ Loading states
- ✅ Efficient Hive queries

### Potential Improvements
- [ ] Image caching with cached_network_image
- [ ] Lazy loading for long lists
- [ ] API response caching
- [ ] Pagination for recipe lists
- [ ] Background syncing

## Testing Strategy

### Unit Tests (To implement)
```dart
test('AuthService registers user', () {
  expect(AuthService.register('user', 'pass'), completes);
});
```

### Integration Tests (To implement)
```dart
testWidgets('User can register and login', (tester) {
  // Full flow testing
});
```

### Manual Testing
- See REQUIREMENTS_CHECKLIST.md
- See QUICKSTART.md

## Future Enhancements

1. **Search & Filter**
   - Add category dropdown
   - Search by recipe name
   - Filter by difficulty/time

2. **User Features**
   - User profile page
   - Recipe ratings
   - Recipe reviews
   - Share recipes

3. **Advanced Features**
   - Meal planning
   - Shopping list from ingredients
   - Recipe notifications
   - Offline support

4. **Performance**
   - Image caching
   - Pagination
   - API response caching
   - Database optimization

## Conclusion

The Recipe App follows a clean architecture pattern with:
- Clear separation of concerns
- Service-oriented approach
- Minimal dependencies
- Easy to test and extend
- Scalable structure for future features
