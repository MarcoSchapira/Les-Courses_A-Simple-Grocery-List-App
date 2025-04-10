import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hive/hive.dart';

// -------------------- LOCALIZATION --------------------

// Language support enum
enum AppLanguage { english, french }

// String extensions for localization
extension LocalizedString on String {
  String localized(LanguageProvider languageProvider) {
    return languageProvider.getLocalizedString(this);
  }
}

// Language Provider
class LanguageProvider with ChangeNotifier {
  final Box _settingsBox;
  AppLanguage _currentLanguage;

  static const String _languageKey = 'app_language';
  static const String _firstRunKey = 'first_run';

  LanguageProvider({required Box settingsBox})
      : _settingsBox = settingsBox,
        _currentLanguage = AppLanguage.english {
    _loadLanguagePreference();
  }

  AppLanguage get currentLanguage => _currentLanguage;

  bool get isFirstRun {
    return _settingsBox.get(_firstRunKey, defaultValue: true);
  }

  void setFirstRunComplete() {
    _settingsBox.put(_firstRunKey, false);
  }

  void _loadLanguagePreference() {
    final languageString =
        _settingsBox.get(_languageKey, defaultValue: 'english');
    _currentLanguage =
        languageString == 'french' ? AppLanguage.french : AppLanguage.english;
  }

  void setLanguage(AppLanguage language) {
    _currentLanguage = language;
    _settingsBox.put(
        _languageKey, language == AppLanguage.french ? 'french' : 'english');
    notifyListeners();
  }

  String getLocalizedValue(String key) {
    return _localizedStrings[key]?[_currentLanguage] ?? key;
  }

  String getLocalizedString(String englishText) {
    // Try to find the text in our dictionary
    for (var entry in _localizedStrings.entries) {
      if (entry.value[AppLanguage.english] == englishText) {
        return entry.value[_currentLanguage] ?? englishText;
      }
    }
    // If not found, return the original text
    return englishText;
  }

  // Localized strings dictionary
  static final Map<String, Map<AppLanguage, String>> _localizedStrings = {
    // App navigation and common terms
    'grocery_list': {
      AppLanguage.english: 'Grocery List',
      AppLanguage.french: 'Liste d\'épicerie',
    },
    'food_items': {
      AppLanguage.english: 'Food Items',
      AppLanguage.french: 'Aliments',
    },
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.french: 'Paramètres',
    },
    'add': {
      AppLanguage.english: 'Add',
      AppLanguage.french: 'Ajouter',
    },
    'delete': {
      AppLanguage.english: 'Delete',
      AppLanguage.french: 'Supprimer',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.french: 'Annuler',
    },
    'save': {
      AppLanguage.english: 'Save',
      AppLanguage.french: 'Enregistrer',
    },
    'edit': {
      AppLanguage.english: 'Edit',
      AppLanguage.french: 'Modifier',
    },
    'clear': {
      AppLanguage.english: 'Clear',
      AppLanguage.french: 'Effacer',
    },

    // Grocery list screen
    'shopping_list': {
      AppLanguage.english: 'Shopping List',
      AppLanguage.french: 'Liste de courses',
    },
    'checked_items': {
      AppLanguage.english: 'Checked Items',
      AppLanguage.french: 'Articles cochés',
    },
    'clear_all': {
      AppLanguage.english: 'Clear All',
      AppLanguage.french: 'Tout effacer',
    },
    'delete_completed_items': {
      AppLanguage.english: 'Delete completed items?',
      AppLanguage.french: 'Supprimer les articles complétés?',
    },
    'remove_checked_items': {
      AppLanguage.english: 'This will remove all checked items from your list.',
      AppLanguage.french:
          'Cela supprimera tous les articles cochés de votre liste.',
    },
    'add_item_to_list': {
      AppLanguage.english: 'Add item to your list...',
      AppLanguage.french: 'Ajouter un article à votre liste...',
    },
    'list_empty': {
      AppLanguage.english: 'Your grocery list is empty',
      AppLanguage.french: 'Votre liste d\'épicerie est vide',
    },
    'add_items_search': {
      AppLanguage.english: 'Add items using the search bar above',
      AppLanguage.french:
          'Ajoutez des articles en utilisant\u{00A0}la\u{00A0}barre\u{00A0}de\u{00A0}recherche\u{00A0}ci-dessus',
    },
    'categories': {
      AppLanguage.english: 'Categories',
      AppLanguage.french: 'Catégories',
    },
    'filter_categories': {
      AppLanguage.english: 'Filter categories',
      AppLanguage.french: 'Filtrer les catégories',
    },

    // Food items screen
    'search_food_items': {
      AppLanguage.english: 'Search food items...',
      AppLanguage.french: 'Rechercher des aliments...',
    },
    'all': {
      AppLanguage.english: 'All',
      AppLanguage.french: 'Tous',
    },
    'no_food_items': {
      AppLanguage.english: 'No food items found',
      AppLanguage.french: 'Aucun aliment trouvé',
    },
    'change_search_filter': {
      AppLanguage.english: 'Try changing your search or filter',
      AppLanguage.french: 'Essayez de modifier votre recherche ou filtre',
    },
    'add_food_items_start': {
      AppLanguage.english: 'Add some food items to get started',
      AppLanguage.french: 'Ajoutez des aliments pour commencer',
    },
    'used': {
      AppLanguage.english: 'Used',
      AppLanguage.french: 'Utilisé',
    },
    'time': {
      AppLanguage.english: 'time',
      AppLanguage.french: 'fois',
    },
    'times': {
      AppLanguage.english: 'times',
      AppLanguage.french: 'fois',
    },
    'delete_food_item': {
      AppLanguage.english: 'Delete Food Item?',
      AppLanguage.french: 'Supprimer cet aliment?',
    },
    'add_food_item': {
      AppLanguage.english: 'Add Food Item',
      AppLanguage.french: 'Ajouter un aliment',
    },
    'edit_food_item': {
      AppLanguage.english: 'Edit Food Item',
      AppLanguage.french: 'Modifier l\'aliment',
    },
    'food_name': {
      AppLanguage.english: 'Food Name',
      AppLanguage.french: 'Nom de l\'aliment',
    },
    'enter_food_name': {
      AppLanguage.english: 'Enter food name',
      AppLanguage.french: 'Entrez le nom de l\'aliment',
    },
    'select_category': {
      AppLanguage.english: 'Select Category',
      AppLanguage.french: 'Sélectionner une catégorie',
    },
    'add_item': {
      AppLanguage.english: 'ADD ITEM',
      AppLanguage.french: 'AJOUTER',
    },
    'save_changes': {
      AppLanguage.english: 'SAVE CHANGES',
      AppLanguage.french: 'ENREGISTRER',
    },

    // Settings screen
    'appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.french: 'Apparence',
    },
    'app_theme': {
      AppLanguage.english: 'App Theme',
      AppLanguage.french: 'Thème de l\'application',
    },
    'change_app_looks': {
      AppLanguage.english: 'Change how the app looks',
      AppLanguage.french: 'Changer l\'apparence de l\'application',
    },
    'system': {
      AppLanguage.english: 'System',
      AppLanguage.french: 'Système',
    },
    'dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.french: 'Sombre',
    },
    'light': {
      AppLanguage.english: 'Light',
      AppLanguage.french: 'Clair',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.french: 'Langue',
    },
    'app_language': {
      AppLanguage.english: 'App Language',
      AppLanguage.french: 'Langue de l\'application',
    },
    'change_app_language': {
      AppLanguage.english: 'Change the app language',
      AppLanguage.french: 'Changer la langue de l\'application',
    },
    'english': {
      AppLanguage.english: 'English',
      AppLanguage.french: 'Anglais',
    },
    'french': {
      AppLanguage.english: 'French',
      AppLanguage.french: 'Français',
    },
    'default_categories': {
      AppLanguage.english: 'Default Categories',
      AppLanguage.french: 'Catégories par défaut',
    },
    'default': {
      AppLanguage.english: 'Default',
      AppLanguage.french: 'Par défaut',
    },
    'custom_categories': {
      AppLanguage.english: 'Custom Categories',
      AppLanguage.french: 'Catégories personnalisées',
    },
    'no_custom_categories': {
      AppLanguage.english:
          'You haven\'t added any custom categories yet. Tap the + button to add a new category.',
      AppLanguage.french:
          'Vous n\'avez pas encore ajouté de catégories personnalisées. Appuyez sur le bouton + pour ajouter une nouvelle catégorie.',
    },
    'add_new_category': {
      AppLanguage.english: 'Add New Category',
      AppLanguage.french: 'Ajouter une nouvelle catégorie',
    },
    'category_name': {
      AppLanguage.english: 'Category Name',
      AppLanguage.french: 'Nom de la catégorie',
    },
    'enter_category_name': {
      AppLanguage.english: 'Enter a new category name',
      AppLanguage.french: 'Entrez un nouveau nom de catégorie',
    },
    'edit_category': {
      AppLanguage.english: 'Edit Category',
      AppLanguage.french: 'Modifier la catégorie',
    },
    'enter_new_name': {
      AppLanguage.english: 'Enter a new name for this category',
      AppLanguage.french: 'Entrez un nouveau nom pour cette catégorie',
    },
    'delete_category': {
      AppLanguage.english: 'Delete Category?',
      AppLanguage.french: 'Supprimer la catégorie?',
    },
    'about': {
      AppLanguage.english: 'About',
      AppLanguage.french: 'À propos',
    },
    'version': {
      AppLanguage.english: 'Version',
      AppLanguage.french: 'Version',
    },
    'feedback_support': {
      AppLanguage.english: 'Feedback & Support',
      AppLanguage.french: 'Commentaires et support',
    },
    'report_issues': {
      AppLanguage.english: 'Report issues or suggest features',
      AppLanguage.french:
          'Signaler des problèmes ou suggérer des fonctionnalités',
    },
    'coming_soon': {
      AppLanguage.english: 'Coming soon!',
      AppLanguage.french: 'Bientôt disponible!',
    },
    'data_management': {
      AppLanguage.english: 'Data Management',
      AppLanguage.french: 'Gestion des données',
    },
    'clear_all_data': {
      AppLanguage.english: 'Clear All Data',
      AppLanguage.french: 'Effacer toutes les données',
    },
    'delete_all_grocery': {
      AppLanguage.english: 'Delete all grocery and food items',
      AppLanguage.french: 'Supprimer tous les articles et aliments',
    },
    'clear_data_confirm': {
      AppLanguage.english:
          'This will delete all your grocery lists and food items. This action cannot be undone.',
      AppLanguage.french:
          'Cela supprimera toutes vos listes d\'épicerie et aliments. Cette action ne peut pas être annulée.',
    },
    'export_data': {
      AppLanguage.english: 'Export Data',
      AppLanguage.french: 'Exporter les données',
    },
    'save_data_file': {
      AppLanguage.english: 'Save your data to a file',
      AppLanguage.french: 'Enregistrer vos données dans un fichier',
    },
    'import_data': {
      AppLanguage.english: 'Import Data',
      AppLanguage.french: 'Importer des données',
    },
    'load_data_file': {
      AppLanguage.english: 'Load data from a file',
      AppLanguage.french: 'Charger des données à partir d\'un fichier',
    },
    'choose_language': {
      AppLanguage.english: 'Choose Language',
      AppLanguage.french: 'Choisir la langue',
    },
    'select_app_language': {
      AppLanguage.english: 'Select your preferred language',
      AppLanguage.french: 'Sélectionnez votre langue préférée',
    },
    'continue': {
      AppLanguage.english: 'Continue',
      AppLanguage.french: 'Continuer',
    },
    'about_app': {
      AppLanguage.english:
          'Les Courses app to simplify your shopping experience. Organize your items, save favourites, and never forget what you need at the store.',
      AppLanguage.french:
          'Les Courses app pour simplifier votre expérience de shopping. Organisez vos articles, enregistrez vos favoris et n\'oubliez jamais ce que vous avez besoin au magasin.',
    },

    // Category names
    'Fruits': {
      AppLanguage.english: 'Fruits',
      AppLanguage.french: 'Fruits',
    },
    'Vegetables': {
      AppLanguage.english: 'Vegetables',
      AppLanguage.french: 'Légumes',
    },
    'Dairy': {
      AppLanguage.english: 'Dairy',
      AppLanguage.french: 'Produits laitiers',
    },
    'Meat': {
      AppLanguage.english: 'Meat',
      AppLanguage.french: 'Viande',
    },
    'Bakery': {
      AppLanguage.english: 'Bakery',
      AppLanguage.french: 'Boulangerie',
    },
    'Pantry': {
      AppLanguage.english: 'Pantry',
      AppLanguage.french: 'Garde-manger',
    },
    'Frozen': {
      AppLanguage.english: 'Frozen',
      AppLanguage.french: 'Surgelés',
    },
    'Beverages': {
      AppLanguage.english: 'Beverages',
      AppLanguage.french: 'Boissons',
    },
    'Snacks': {
      AppLanguage.english: 'Snacks',
      AppLanguage.french: 'Collations',
    },
    'Household': {
      AppLanguage.english: 'Household',
      AppLanguage.french: 'Maison',
    },
    'Spices': {
      AppLanguage.english: 'Spices',
      AppLanguage.french: 'Épices',
    },
    'Seafood': {
      AppLanguage.english: 'Seafood',
      AppLanguage.french: 'Fruits de mer',
    },
    'Health': {
      AppLanguage.english: 'Health',
      AppLanguage.french: 'Santé',
    },
    'Personal': {
      AppLanguage.english: 'Personal',
      AppLanguage.french: 'Personnel',
    },
    'Other': {
      AppLanguage.english: 'Other',
      AppLanguage.french: 'Autre',
    },
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(GroceryItemAdapter());
  Hive.registerAdapter(FoodItemAdapter());

  // Open boxes
  await Hive.openBox<GroceryItem>('groceryItems');
  await Hive.openBox<FoodItem>('foodItems');
  await Hive.openBox('settings');

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create providers
  final settingsBox = Hive.box('settings');
  final languageProvider = LanguageProvider(settingsBox: settingsBox);
  final groceryProvider = GroceryProvider(
    languageProvider: languageProvider,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: groceryProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Ultimate Grocery List',
      debugShowCheckedModeBanner: false,
      darkTheme: themeProvider.darkTheme,
      theme: themeProvider.lightTheme,
      themeMode: themeProvider.themeMode,
      home: languageProvider.isFirstRun
          ? const LanguageSelectionScreen()
          : const HomeScreen(),
    );
  }
}

// Language Selection Screen
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final groceryProvider = Provider.of<GroceryProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Icon(
                Icons.shopping_cart,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Les Courses de Papoum et Mamoune',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              Text(
                'Choose Language'.localized(languageProvider),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Select your preferred language'.localized(languageProvider),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // English option
              ElevatedButton(
                onPressed: () {
                  languageProvider.setLanguage(AppLanguage.english);
                  setState(() {}); // Refresh UI to show selection
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor:
                      languageProvider.currentLanguage == AppLanguage.english
                          ? theme.colorScheme.primary
                          : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 12),
                    Text(
                      'English',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // French option
              ElevatedButton(
                onPressed: () {
                  languageProvider.setLanguage(AppLanguage.french);
                  setState(() {}); // Refresh UI to show selection
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor:
                      languageProvider.currentLanguage == AppLanguage.french
                          ? theme.colorScheme.primary
                          : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 12),
                    Text(
                      'Français',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Continue button
              FilledButton(
                onPressed: () {
                  _continueToApp(context, languageProvider, groceryProvider);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Continue'.localized(languageProvider),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToApp(BuildContext context, LanguageProvider languageProvider,
      GroceryProvider groceryProvider) async {
    // Mark first run as completed
    languageProvider.setFirstRunComplete();

    // Add default food items in selected language
    await groceryProvider.addDefaultFoodItemsIfNeeded();

    // Navigate to home screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}

// -------------------- MODELS --------------------

// GroceryItem Model
class GroceryItemAdapter extends TypeAdapter<GroceryItem> {
  @override
  final int typeId = 0;

  @override
  GroceryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroceryItem(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      isCompleted: fields[3] as bool,
      isStarred: fields[4] as bool,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroceryItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.isStarred)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroceryItem extends HiveObject {
  final String id;
  String name;
  String category;
  bool isCompleted;
  bool isStarred;
  DateTime createdAt;

  GroceryItem({
    required this.id,
    required this.name,
    required this.category,
    this.isCompleted = false,
    this.isStarred = false,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
}

// FoodItem Model
class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 1;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      usageCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodItem extends HiveObject {
  final String id;
  String name;
  String category;
  int usageCount;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    this.usageCount = 0,
  });
}

// -------------------- PROVIDERS --------------------

// Theme Provider without ThemeService
class ThemeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');
  static const String _themeKey = 'theme_mode';

  // Scandinavian Minimalist Palette
  static const Color primaryColor = Color(0xFF2C3E50); // Deep Blue-Gray
  static const Color accentColor = Color(0xFF34495E); // Slate Gray
  static const Color secondaryColor = Color(0xFF7F8C8D); // Cool Gray

  // Dark Theme Nordic Variants
  static const Color darkPrimaryColor = Color(0xFF1A242F); // Almost Black
  static const Color darkAccentColor = Color(0xFF2C3E50); // Dark Blue-Gray
  static const Color darkSecondaryColor = Color(0xFF34495E); // Deep Slate

  // Get current theme mode from storage or default to system
  ThemeMode get themeMode {
    final themeString = _settingsBox.get(_themeKey, defaultValue: 'system');
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Update theme mode and save to storage
  void setThemeMode(ThemeMode mode) {
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    _settingsBox.put(_themeKey, themeString);
    notifyListeners();
  }

  // Light theme definition
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          backgroundColor:
              Colors.grey.shade400, // Change button background color
          //foregroundColor: Colors.pink, // Change text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Dark theme definition
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: darkPrimaryColor,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// Grocery Provider
// Grocery Provider// Grocery Provider
class GroceryProvider with ChangeNotifier {
  final _groceryBox = Hive.box<GroceryItem>('groceryItems');
  final _foodBox = Hive.box<FoodItem>('foodItems');
  final _settingsBox = Hive.box('settings');
  final _uuid = Uuid();
  final LanguageProvider languageProvider;

  GroceryProvider({required this.languageProvider});

  // Get active grocery items (not completed)
  List<GroceryItem> get activeItems {
    final items =
        _groceryBox.values.where((item) => !item.isCompleted).toList();

    // Sort: starred first, then by creation date
    items.sort((a, b) {
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;

      // Sort by creation date if other factors are equal
      return b.createdAt.compareTo(a.createdAt);
    });

    return items;
  }

  // Get completed grocery items
  List<GroceryItem> get completedItems {
    final items = _groceryBox.values.where((item) => item.isCompleted).toList();

    // Sort by completion date (most recent first)
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  // Get all grocery items
  List<GroceryItem> get groceryItems {
    return [...activeItems, ...completedItems];
  }

  // Get all food items for suggestions
  List<FoodItem> get foodItems {
    final items = _foodBox.values.toList();
    // Sort by usage count (most used first)
    items.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return items;
  }

  // Get food items filtered by search query
  List<FoodItem> getFoodSuggestions(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return _foodBox.values
        .where((item) => item.name.toLowerCase().contains(lowercaseQuery))
        .toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
  }

  // Get categories used in the active grocery list
  List<String> getGroceryListCategories() {
    // Get unique categories from active grocery items
    final categories = activeItems.map((item) => item.category).toSet();
    // Convert internal English categories to display language
    final displayCategories =
        categories.map((c) => getDisplayCategory(c)).toSet().toList();
    displayCategories.sort();
    return displayCategories;
  }

  // Translate a display category name to internal (English) category name
  String getInternalCategory(String displayCategory) {
    // Try to match with a base category
    for (final baseCategory in _baseCategories) {
      final translatedCategory = baseCategory.localized(languageProvider);
      if (displayCategory == translatedCategory) {
        return baseCategory;
      }
    }
    // If not a default category, return as is (custom category)
    return displayCategory;
  }

  // Translate an internal (English) category name to display language
  String getDisplayCategory(String internalCategory) {
    // Check if it's a default category that needs translation
    if (_baseCategories.contains(internalCategory)) {
      return internalCategory.localized(languageProvider);
    }
    // If not a default category, return as is (custom category)
    return internalCategory;
  }

  /// Updates all existing *default* FoodItems from the old language to the new language.
  /// Matches items by exact name from the old language default list, then renames them
  /// to the corresponding name in the new language default list.
  void updateDefaultFoodItemsForLanguage(
      AppLanguage oldLang, AppLanguage newLang) {
    if (oldLang == newLang) return; // No change needed

    // 1) Get the old default items map
    final oldMap = (oldLang == AppLanguage.french)
        ? {
            'Fruits': [
              'Pommes',
              'Bananes',
              'Oranges',
              'Fraises',
              'Myrtilles',
              'Citrons',
              'Avocats',
              'Pêches'
            ],
            'Vegetables': [
              'Carottes',
              'Brocoli',
              'Épinards',
              'Tomates',
              'Oignons',
              'Pommes de terre',
              'Poivrons',
              'Concombre'
            ],
            'Dairy': [
              'Lait',
              'Œufs',
              'Fromage',
              'Yaourt',
              'Beurre',
              'Fromage à la crème',
              'Lait d\'amande'
            ],
            'Meat': [
              'Cuisses de poulet',
              'Bœuf haché',
              'Bacon',
              'Steak',
              'Côtelettes de porc',
              'Jambon'
            ],
            'Bakery': [
              'Pain',
              'Bagels',
              'Tortillas',
              'Croissants',
              'Muffins',
              'Biscuits'
            ],
            'Pantry': [
              'Riz',
              'Pâtes',
              'Farine',
              'Sucre',
              'Céréales',
              'Beurre d\'arachide',
              'Confiture',
              'Huile d\'olive',
              'Ketchup',
              'Moutarde',
              'Sauce soja'
            ],
            'Frozen': [
              'Crème glacée',
              'Pizza surgelée',
              'Légumes surgelés',
              'Nuggets de poulet',
              'Poisson surgelé'
            ],
            'Beverages': [
              'Eau',
              'Café',
              'Thé',
              'Jus',
              'Soda',
              'Eau pétillante'
            ],
            'Snacks': [
              'Chips',
              'Bretzels',
              'Popcorn',
              'Noix',
              'Barres granola',
              'Chocolat'
            ],
            'Household': [
              'Essuie-tout',
              'Papier toilette',
              'Liquide vaisselle',
              'Lessive',
              'Sacs poubelle',
              'Produits de nettoyage'
            ],
            'Spices': [
              'Sel',
              'Poivre',
              'Poudre d\'ail',
              'Cannelle',
              'Paprika',
              'Origan'
            ],
            'Seafood': ['Saumon', 'Thon', 'Crevettes', 'Crabe'],
            'Health': [
              'Vitamines',
              'Pastilles pour la toux',
              'Pansements',
              'Analgésiques',
              'Médicaments contre le rhume'
            ],
            'Personal': [
              'Shampooing',
              'Savon',
              'Déodorant',
              'Dentifrice',
              'Rince-bouche',
              'Crème solaire'
            ],
            'Other': [
              'Bloc-notes',
              'Stylos',
              'Chargeur de téléphone',
              'Parapluie',
              'Ciseaux'
            ],
          }
        : {
            // English version
            'Fruits': [
              'Apples',
              'Bananas',
              'Oranges',
              'Strawberries',
              'Blueberries',
              'Lemons',
              'Avocados',
              'Peaches'
            ],
            'Vegetables': [
              'Carrots',
              'Broccoli',
              'Spinach',
              'Tomatoes',
              'Onions',
              'Potatoes',
              'Bell Peppers',
              'Cucumber'
            ],
            'Dairy': [
              'Milk',
              'Eggs',
              'Cheese',
              'Yogurt',
              'Butter',
              'Cream Cheese',
              'Almond Milk'
            ],
            'Meat': [
              'Chicken Breast',
              'Ground Beef',
              'Bacon',
              'Steak',
              'Pork Chops',
              'Ham'
            ],
            'Bakery': [
              'Bread',
              'Bagels',
              'Tortillas',
              'Croissants',
              'Muffins',
              'Cookies'
            ],
            'Pantry': [
              'Rice',
              'Pasta',
              'Flour',
              'Sugar',
              'Cereal',
              'Peanut Butter',
              'Jam',
              'Olive Oil',
              'Ketchup',
              'Mustard',
              'Soy Sauce'
            ],
            'Frozen': [
              'Ice Cream',
              'Frozen Pizza',
              'Frozen Vegetables',
              'Frozen Chicken Nuggets',
              'Frozen Fish'
            ],
            'Beverages': [
              'Water',
              'Coffee',
              'Tea',
              'Juice',
              'Soda',
              'Sparkling Water'
            ],
            'Snacks': [
              'Chips',
              'Pretzels',
              'Popcorn',
              'Nuts',
              'Granola Bars',
              'Chocolate'
            ],
            'Household': [
              'Paper Towels',
              'Toilet Paper',
              'Dish Soap',
              'Laundry Detergent',
              'Trash Bags',
              'Cleaning Supplies'
            ],
            'Spices': [
              'Salt',
              'Pepper',
              'Garlic Powder',
              'Cinnamon',
              'Paprika',
              'Oregano'
            ],
            'Seafood': ['Salmon', 'Tuna', 'Shrimp', 'Crab'],
            'Health': [
              'Vitamins',
              'Cough Drops',
              'Band-Aids',
              'Pain Relievers',
              'Cold Medicine'
            ],
            'Personal': [
              'Shampoo',
              'Soap',
              'Deodorant',
              'Toothpaste',
              'Mouthwash',
              'Sunscreen'
            ],
            'Other': [
              'Notepad',
              'Pens',
              'Phone Charger',
              'Umbrella',
              'Scissors'
            ],
          };

    // 2) Get the new language’s default items map
    final newMap = (newLang == AppLanguage.french)
        ? defaultFoodItems // we already have "defaultFoodItems" for French
        : defaultFoodItems; // for English

    // For each "old name" in oldMap, rename it to the "new name" in newMap
    oldMap.forEach((categoryKey, oldNames) {
      final newNames = newMap[categoryKey] ?? [];

      // We assume oldNames and newNames match up in index (the same items)
      for (int i = 0; i < oldNames.length; i++) {
        final oldName = oldNames[i];
        if (i < newNames.length) {
          final newName = newNames[i];

          // Find existing FoodItem by oldName (case-insensitive)
          final match = _foodBox.values.firstWhere(
            (foodItem) => foodItem.name.toLowerCase() == oldName.toLowerCase(),
            orElse: () => FoodItem(
              id: '',
              name: '',
              category: '',
            ),
          );

          // If found, rename it
          if (match.id.isNotEmpty) {
            match.name = newName;
            match.save();
          }
        }
      }
    });

    notifyListeners();
  }

  // Category icons mapping - use base category names only
  final Map<String, IconData> _baseIcons = {
    'Fruits': Icons.apple,
    'Vegetables': Icons.eco,
    'Dairy': Icons.egg,
    'Meat': Icons.kebab_dining,
    'Bakery': Icons.bakery_dining,
    'Pantry': Icons.kitchen,
    'Frozen': Icons.ac_unit,
    'Beverages': Icons.local_drink,
    'Snacks': Icons.cookie,
    'Household': Icons.cleaning_services,
    'Spices': Icons.spa,
    'Seafood': Icons.set_meal,
    'Health': Icons.medical_services,
    'Personal': Icons.face,
    'Other': Icons.category,
  };

  // Get icon for a category
  IconData getCategoryIcon(String category) {
    // Convert to internal name first if it's a display name
    final internalCategory = getInternalCategory(category);
    return _baseIcons[internalCategory] ?? Icons.category;
  }

  // Category colors mapping - use base category names only
  final Map<String, Color> _baseColors = {
    'Fruits': Colors.red.shade200,
    'Vegetables': Colors.green.shade200,
    'Dairy': Colors.blue.shade200,
    'Meat': Colors.brown.shade200,
    'Bakery': Colors.orange.shade200,
    'Pantry': Colors.purple.shade200,
    'Frozen': Colors.cyan.shade200,
    'Beverages': Colors.teal.shade200,
    'Snacks': Colors.pink.shade200,
    'Household': Colors.grey.shade300,
    'Spices': Colors.amber.shade200,
    'Seafood': Colors.lightBlue.shade200,
    'Health': Colors.lightGreen.shade200,
    'Personal': Colors.blueGrey.shade200,
    'Other': Colors.deepPurple.shade300,
  };

  // Get color for a category
  Color getCategoryColor(String category) {
    // Convert to internal name first if it's a display name
    final internalCategory = getInternalCategory(category);
    return _baseColors[internalCategory] ?? Colors.grey.shade500;
  }

  // Base category names (in English) - internal representation
  final List<String> _baseCategories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat',
    'Bakery',
    'Pantry',
    'Frozen',
    'Beverages',
    'Snacks',
    'Household',
    'Spices',
    'Seafood',
    'Health',
    'Personal',
    'Other',
  ];

  // Get localized default category names for display
  List<String> get defaultCategoryNames {
    return _baseCategories.map((c) => c.localized(languageProvider)).toList();
  }

  // Get both default and custom categories for display
  List<String> get displayCategories {
    // Get default categories (translated)
    final defaults =
        _baseCategories.map((c) => c.localized(languageProvider)).toList();
    // Get custom categories (already in display form)
    final customs = customCategories;
    // Combine both
    final allCategories = [...defaults, ...customs];
    allCategories.sort();
    return allCategories;
  }

  Map<String, List<String>> get defaultFoodItems {
    if (languageProvider.currentLanguage == AppLanguage.french) {
      return {
        'Fruits': [
          'Pommes',
          'Bananes',
          'Oranges',
          'Fraises',
          'Myrtilles',
          'Citrons',
          'Avocats',
          'Pêches'
        ],
        'Vegetables': [
          'Carottes',
          'Brocoli',
          'Épinards',
          'Tomates',
          'Oignons',
          'Pommes de terre',
          'Poivrons',
          'Concombre'
        ],
        'Dairy': [
          'Lait',
          'Œufs',
          'Fromage',
          'Yaourt',
          'Beurre',
          'Fromage à la crème',
          'Lait d\'amande'
        ],
        'Meat': [
          'Cuisses de poulet',
          'Bœuf haché',
          'Bacon',
          'Steak',
          'Côtelettes de porc',
          'Jambon'
        ],
        'Bakery': [
          'Pain',
          'Bagels',
          'Tortillas',
          'Croissants',
          'Muffins',
          'Biscuits'
        ],
        'Pantry': [
          'Riz',
          'Pâtes',
          'Farine',
          'Sucre',
          'Céréales',
          'Beurre d\'arachide',
          'Confiture',
          'Huile d\'olive',
          'Ketchup',
          'Moutarde',
          'Sauce soja'
        ],
        'Frozen': [
          'Crème glacée',
          'Pizza surgelée',
          'Légumes surgelés',
          'Nuggets de poulet',
          'Poisson surgelé'
        ],
        'Beverages': ['Eau', 'Café', 'Thé', 'Jus', 'Soda', 'Eau pétillante'],
        'Snacks': [
          'Chips',
          'Bretzels',
          'Popcorn',
          'Noix',
          'Barres granola',
          'Chocolat'
        ],
        'Household': [
          'Essuie-tout',
          'Papier toilette',
          'Liquide vaisselle',
          'Lessive',
          'Sacs poubelle',
          'Produits de nettoyage'
        ],
        'Spices': [
          'Sel',
          'Poivre',
          'Poudre d\'ail',
          'Cannelle',
          'Paprika',
          'Origan'
        ],
        'Seafood': ['Saumon', 'Thon', 'Crevettes', 'Crabe'],
        'Health': [
          'Vitamines',
          'Pastilles pour la toux',
          'Pansements',
          'Analgésiques',
          'Médicaments contre le rhume'
        ],
        'Personal': [
          'Shampooing',
          'Savon',
          'Déodorant',
          'Dentifrice',
          'Rince-bouche',
          'Crème solaire'
        ],
        'Other': [
          'Bloc-notes',
          'Stylos',
          'Chargeur de téléphone',
          'Parapluie',
          'Ciseaux'
        ],
      };
    } else {
      // English default items
      return {
        'Fruits': [
          'Apples',
          'Bananas',
          'Oranges',
          'Strawberries',
          'Blueberries',
          'Lemons',
          'Avocados',
          'Peaches'
        ],
        'Vegetables': [
          'Carrots',
          'Broccoli',
          'Spinach',
          'Tomatoes',
          'Onions',
          'Potatoes',
          'Bell Peppers',
          'Cucumber'
        ],
        'Dairy': [
          'Milk',
          'Eggs',
          'Cheese',
          'Yogurt',
          'Butter',
          'Cream Cheese',
          'Almond Milk'
        ],
        'Meat': [
          'Chicken Breast',
          'Ground Beef',
          'Bacon',
          'Steak',
          'Pork Chops',
          'Ham'
        ],
        'Bakery': [
          'Bread',
          'Bagels',
          'Tortillas',
          'Croissants',
          'Muffins',
          'Cookies'
        ],
        'Pantry': [
          'Rice',
          'Pasta',
          'Flour',
          'Sugar',
          'Cereal',
          'Peanut Butter',
          'Jam',
          'Olive Oil',
          'Ketchup',
          'Mustard',
          'Soy Sauce'
        ],
        'Frozen': [
          'Ice Cream',
          'Frozen Pizza',
          'Frozen Vegetables',
          'Frozen Chicken Nuggets',
          'Frozen Fish'
        ],
        'Beverages': [
          'Water',
          'Coffee',
          'Tea',
          'Juice',
          'Soda',
          'Sparkling Water'
        ],
        'Snacks': [
          'Chips',
          'Pretzels',
          'Popcorn',
          'Nuts',
          'Granola Bars',
          'Chocolate'
        ],
        'Household': [
          'Paper Towels',
          'Toilet Paper',
          'Dish Soap',
          'Laundry Detergent',
          'Trash Bags',
          'Cleaning Supplies'
        ],
        'Spices': [
          'Salt',
          'Pepper',
          'Garlic Powder',
          'Cinnamon',
          'Paprika',
          'Oregano'
        ],
        'Seafood': ['Salmon', 'Tuna', 'Shrimp', 'Crab'],
        'Health': [
          'Vitamins',
          'Cough Drops',
          'Band-Aids',
          'Pain Relievers',
          'Cold Medicine'
        ],
        'Personal': [
          'Shampoo',
          'Soap',
          'Deodorant',
          'Toothpaste',
          'Mouthwash',
          'Sunscreen'
        ],
        'Other': ['Notepad', 'Pens', 'Phone Charger', 'Umbrella', 'Scissors'],
      };
    }
  }

  // Get custom categories from settings
  List<String> get customCategories {
    final List<dynamic>? customList = _settingsBox.get('custom_categories');
    return customList?.cast<String>() ?? [];
  }

  // Set custom categories
  Future<void> setCustomCategories(List<String> categories) async {
    await _settingsBox.put('custom_categories', categories);
    notifyListeners();
  }

  // Add a new category
  Future<void> addCategory(String category) async {
    if (category.isEmpty) return;

    final categories = customCategories;
    if (!categories.contains(category)) {
      categories.add(category);
      await setCustomCategories(categories);
    }
  }

  // Remove a category
  Future<void> removeCategory(String category) async {
    if (_baseCategories
        .map((c) => c.localized(languageProvider))
        .contains(category)) return; // Can't remove default categories

    final categories = customCategories;
    if (categories.contains(category)) {
      categories.remove(category);
      await setCustomCategories(categories);
    }
  }

  // Update a category
  Future<void> updateCategory(String oldCategory, String newCategory) async {
    if (oldCategory == newCategory || newCategory.isEmpty) return;
    if (_baseCategories
        .map((c) => c.localized(languageProvider))
        .contains(oldCategory)) return; // Can't update default categories

    // Update category in custom categories list
    final categories = customCategories;
    final index = categories.indexOf(oldCategory);
    if (index != -1) {
      categories[index] = newCategory;
      await setCustomCategories(categories);
    }

    // Update category in food items
    final foodItems =
        _foodBox.values.where((item) => item.category == oldCategory).toList();
    for (final item in foodItems) {
      item.category = newCategory;
      item.save();
    }

    // Update category in grocery items
    final groceryItems = _groceryBox.values
        .where((item) => item.category == oldCategory)
        .toList();
    for (final item in groceryItems) {
      item.category = newCategory;
      item.save();
    }

    notifyListeners();
  }

  // Check if default food items have been added
  bool get hasDefaultFoodItems {
    return _settingsBox.get('default_food_items_added', defaultValue: false);
  }

  // Set default food items as added
  Future<void> setDefaultFoodItemsAdded() async {
    await _settingsBox.put('default_food_items_added', true);
  }

  // Add default food items if not already added
  Future<void> addDefaultFoodItemsIfNeeded() async {
    if (!hasDefaultFoodItems) {
      // Clear existing food items if any
      await _foodBox.clear();

      // Add each default item in the selected language
      // Categories in defaultFoodItems are already in English (internal representation)
      defaultFoodItems.forEach((category, items) {
        for (final item in items) {
          // Add only if it doesn't already exist
          if (!_foodBox.values
              .any((food) => food.name.toLowerCase() == item.toLowerCase())) {
            // Category is already in English, so no need to convert
            addFoodItem(item, category);
          }
        }
      });

      await setDefaultFoodItemsAdded();
    }
  }

  // Get all available categories
  List<String> get categories {
    // Start with default categories (already in display language)
    final result = defaultCategoryNames.toList();

    // Add custom categories
    result.addAll(customCategories);

    // Add additional categories from food items that might not be default or custom
    final foodCategories = _foodBox.values
        .map((item) => getDisplayCategory(item.category))
        .toSet()
        .where((category) => !result.contains(category))
        .toList();

    result.addAll(foodCategories);
    result.sort();
    return result;
  }

  // Add a new grocery item
  void addGroceryItem(String name, String displayCategory) {
    // Convert display category to internal category
    final internalCategory = getInternalCategory(displayCategory);

    final item = GroceryItem(
      id: _uuid.v4(),
      name: name,
      category: internalCategory, // Store with internal (English) category name
    );

    _groceryBox.add(item);

    // Update or add to food suggestions
    final existingFoodItem = _foodBox.values.firstWhere(
        (food) => food.name.toLowerCase() == name.toLowerCase(),
        orElse: () => FoodItem(id: '', name: '', category: ''));

    if (existingFoodItem.id.isEmpty) {
      // Add new food item
      final newFoodItem = FoodItem(
        id: _uuid.v4(),
        name: name,
        category:
            internalCategory, // Store with internal (English) category name
        usageCount: 1,
      );
      _foodBox.add(newFoodItem);
    } else {
      // Update existing food item usage count
      existingFoodItem.usageCount++;
      existingFoodItem.save();
    }

    notifyListeners();
  }

  // Add a new food item to suggestions
  void addFoodItem(String name, String category) {
    final existingItem = _foodBox.values.firstWhere(
        (item) => item.name.toLowerCase() == name.toLowerCase(),
        orElse: () => FoodItem(id: '', name: '', category: ''));

    if (existingItem.id.isEmpty) {
      final item = FoodItem(
        id: _uuid.v4(),
        name: name,
        category: category, // Already in internal (English) form
      );
      _foodBox.add(item);
      notifyListeners();
    }
  }

  // Update a food item
  void updateFoodItem(FoodItem item, {String? name, String? displayCategory}) {
    if (name != null) item.name = name;
    if (displayCategory != null) {
      // Convert display category to internal category
      item.category = getInternalCategory(displayCategory);
    }
    item.save();
    notifyListeners();
  }

  // Delete a food item
  void deleteFoodItem(FoodItem item) {
    item.delete();
    notifyListeners();
  }

  // Toggle completion status of a grocery item
  void toggleItemCompletion(GroceryItem item) {
    item.isCompleted = !item.isCompleted;
    item.save();
    notifyListeners();
  }

  // Toggle star status of a grocery item
  void toggleItemStar(GroceryItem item) {
    item.isStarred = !item.isStarred;
    item.save();
    notifyListeners();
  }

  // Delete a grocery item
  void deleteGroceryItem(GroceryItem item) {
    item.delete();
    notifyListeners();
  }

  // Delete all completed grocery items
  void deleteCompletedItems() {
    final completedItems =
        _groceryBox.values.where((item) => item.isCompleted).toList();
    for (final item in completedItems) {
      item.delete();
    }
    notifyListeners();
  }
}
// -------------------- SCREENS --------------------

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const GroceryListScreen(),
    const FoodItemsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //final groceryProvider = Provider.of<GroceryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    //final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 8), // Adjust padding
          //constraints:
          //const BoxConstraints(maxWidth: 250), // Set max width for wrapping
          child: Text(
            _getTitle().localized(languageProvider),
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: 'Grocery List'.localized(languageProvider),
          ),
          NavigationDestination(
            icon: const Icon(Icons.fastfood_outlined),
            selectedIcon: const Icon(Icons.fastfood),
            label: 'Food Items'.localized(languageProvider),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'Settings'.localized(languageProvider),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Les Courses de Papoum et Mamoune';
      case 1:
        return 'Food Items';
      case 2:
        return 'Settings';
      default:
        return 'Les Courses de Papoum et Mamoune';
    }
  }
}

// Grocery List Screen
// Grocery List Screen
class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<FoodItem> _suggestions = [];
  String _selectedCategory = 'Other'; // Default category
  String _selectedFilter = ''; // For category filtering

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groceryProvider = Provider.of<GroceryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    // Update selected category for the current language
    _selectedCategory = 'Other'.localized(languageProvider);

    // Get categories in the grocery list for filtering
    final listCategories = groceryProvider.getGroceryListCategories();

    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Search bar and add button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    decoration: InputDecoration(
                      hintText: 'Add item to your list...'
                          .localized(languageProvider),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _suggestions = [];
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _suggestions = [];
                        } else {
                          _suggestions =
                              groceryProvider.getFoodSuggestions(value);
                        }
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        groceryProvider.addGroceryItem(
                            value, _selectedCategory);
                        _searchController.clear();
                        setState(() {
                          _suggestions = [];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () =>
                      _showAddFoodItemDialog(context, languageProvider),
                ),
              ],
            ),
          ),

          // Category filter - Only show if there are grocery items
          if (groceryProvider.activeItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories'.localized(languageProvider),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // All categories option
                        FilterChip(
                          label: Text('All'.localized(languageProvider)),
                          selected: _selectedFilter.isEmpty,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = '';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        // Display each category in the grocery list
                        ...listCategories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(category),
                              selected: _selectedFilter == category,
                              backgroundColor: groceryProvider
                                  .getCategoryColor(category)
                                  .withOpacity(0.2),
                              avatar: Icon(
                                groceryProvider.getCategoryIcon(category),
                                size: 16,
                                color:
                                    groceryProvider.getCategoryColor(category),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = selected ? category : '';
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Suggestions list
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length > 5 ? 5 : _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: groceryProvider
                          .getCategoryColor(suggestion.category)
                          .withOpacity(0.2),
                      child: Icon(
                        groceryProvider.getCategoryIcon(suggestion.category),
                        color: groceryProvider
                            .getCategoryColor(suggestion.category),
                      ),
                    ),
                    title: Text(suggestion.name),
                    subtitle: Text(groceryProvider
                        .getDisplayCategory(suggestion.category)),
                    onTap: () {
                      groceryProvider.addGroceryItem(
                        suggestion.name,
                        suggestion.category,
                      );
                      _searchController.clear();
                      setState(() {
                        _suggestions = [];
                      });
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),

          // Grocery list
          Expanded(
            child: groceryProvider.groceryItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your grocery list is empty'
                              .localized(languageProvider),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items using the search bar above'
                              .localized(languageProvider),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      // Active items section - filtered by category if selected
                      if (groceryProvider.activeItems.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          child: Text(
                            'Shopping List'.localized(languageProvider),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        ...groceryProvider.activeItems
                            .where((item) =>
                                _selectedFilter.isEmpty ||
                                // Convert selected filter to internal category before comparing
                                item.category ==
                                    groceryProvider
                                        .getInternalCategory(_selectedFilter))
                            .map((item) => GroceryItemTile(
                                  item: item,
                                  onTap: () => groceryProvider
                                      .toggleItemCompletion(item),
                                  onStarToggle: () =>
                                      groceryProvider.toggleItemStar(item),
                                  onDelete: () =>
                                      groceryProvider.deleteGroceryItem(item),
                                ))
                            .toList(),
                      ],

                      // Completed items section - filtered by category if selected
                      if (groceryProvider.completedItems.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Checked Items'.localized(languageProvider),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_sweep, size: 16),
                                label: Text(
                                    'Clear All'.localized(languageProvider)),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.error,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete completed items?'
                                          .localized(languageProvider)),
                                      content: Text(
                                          'This will remove all checked items from your list.'
                                              .localized(languageProvider)),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancel'
                                              .localized(languageProvider)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            groceryProvider
                                                .deleteCompletedItems();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'
                                              .localized(languageProvider)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        ...groceryProvider.completedItems
                            .where((item) =>
                                _selectedFilter.isEmpty ||
                                // Convert selected filter to internal category before comparing
                                item.category ==
                                    groceryProvider
                                        .getInternalCategory(_selectedFilter))
                            .map((item) => GroceryItemTile(
                                  item: item,
                                  onTap: () => groceryProvider
                                      .toggleItemCompletion(item),
                                  onStarToggle: () =>
                                      groceryProvider.toggleItemStar(item),
                                  onDelete: () =>
                                      groceryProvider.deleteGroceryItem(item),
                                ))
                            .toList(),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddFoodItemDialog(
      BuildContext context, LanguageProvider languageProvider) {
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    String selectedCategory = _selectedCategory;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Add Food Item'.localized(languageProvider),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Food name input
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Food Name'.localized(languageProvider),
                      hintText: 'Enter food name'.localized(languageProvider),
                      filled: true,
                      prefixIcon: const Icon(Icons.food_bank),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category title
                  Text(
                    'Select Category'.localized(languageProvider),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category grid
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: groceryProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = groceryProvider.categories[index];
                          final isSelected = category == selectedCategory;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? groceryProvider.getCategoryColor(category)
                                    : groceryProvider
                                        .getCategoryColor(category)
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    groceryProvider.getCategoryIcon(category),
                                    color: isSelected
                                        ? Colors.white
                                        : groceryProvider
                                            .getCategoryColor(category),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add button
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        groceryProvider.addFoodItem(name, selectedCategory);
                        _selectedCategory = selectedCategory;
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ADD ITEM'.localized(languageProvider),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Food Items Screen
// Food Items Screen
class FoodItemsScreen extends StatefulWidget {
  const FoodItemsScreen({Key? key}) : super(key: key);

  @override
  State<FoodItemsScreen> createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  String _searchQuery = '';

  // Map to track expanded/collapsed state of each category
  final Map<String, bool> _categoryExpanded = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get or set expanded state for a category (default collapsed)
  bool isCategoryExpanded(String category) {
    _categoryExpanded[category] ??= false; // Initialize to false if not set
    return _categoryExpanded[category]!;
  }

  // Toggle expanded state for a category
  void toggleCategoryExpanded(String category) {
    setState(() {
      _categoryExpanded[category] = !isCategoryExpanded(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groceryProvider = Provider.of<GroceryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    // Group items by category
    final Map<String, List<FoodItem>> groupedItems = {};

    // Filter food items
    List<FoodItem> filteredItems = groceryProvider.foodItems;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredItems = filteredItems
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    }

    // Group items by category
    for (final item in filteredItems) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    return Scaffold(
      body: Column(
        children: [
          // Search bar with Add button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          'Search food items...'.localized(languageProvider),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () =>
                      _showAddFoodItemBottomSheet(context, languageProvider),
                ),
              ],
            ),
          ),

          // Items list grouped by category
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_food,
                          size: 64,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No food items found'.localized(languageProvider),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try changing your search or filter'
                                  .localized(languageProvider)
                              : 'Add some food items to get started'
                                  .localized(languageProvider),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: groupedItems.keys.length,
                    itemBuilder: (context, sectionIndex) {
                      final category =
                          groupedItems.keys.elementAt(sectionIndex);
                      final items = groupedItems[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category header - made clickable for collapsing/expanding
                          InkWell(
                            onTap: () => toggleCategoryExpanded(category),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    groceryProvider.getCategoryIcon(category),
                                    color: groceryProvider
                                        .getCategoryColor(category),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    // Display the translated category name
                                    groceryProvider
                                        .getDisplayCategory(category),
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${items.length})',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Add expand/collapse icon
                                  Icon(
                                    isCategoryExpanded(category)
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: theme.colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Items in this category - only show if expanded
                          if (isCategoryExpanded(category))
                            ...items
                                .map((item) => Dismissible(
                                      key: Key(item.id),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Delete Food Item?'
                                                .localized(languageProvider)),
                                            content: Text(
                                                'Are you sure you want to delete "${item.name}"?'
                                                    .localized(
                                                        languageProvider)),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: Text('Cancel'.localized(
                                                    languageProvider)),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: Text('Delete'.localized(
                                                    languageProvider)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onDismissed: (_) {
                                        groceryProvider.deleteFoodItem(item);
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: groceryProvider
                                                .getCategoryColor(category)
                                                .withOpacity(0.2),
                                            child: Icon(
                                              groceryProvider
                                                  .getCategoryIcon(category),
                                              color: groceryProvider
                                                  .getCategoryColor(category),
                                            ),
                                          ),
                                          title: Text(item.name),
                                          // Display the translated category name
                                          subtitle: Text(groceryProvider
                                              .getDisplayCategory(
                                                  item.category)),
                                          trailing: Text(
                                            '${languageProvider.getLocalizedValue('used')} ${item.usageCount} ${item.usageCount == 1 ? languageProvider.getLocalizedValue('time') : languageProvider.getLocalizedValue('times')}',
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                              fontSize: 12,
                                            ),
                                          ),
                                          onTap: () =>
                                              _showEditFoodItemBottomSheet(
                                                  context,
                                                  item,
                                                  languageProvider),
                                        ),
                                      ),
                                    ))
                                .toList(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditFoodItemBottomSheet(
      BuildContext context, FoodItem item, LanguageProvider languageProvider) {
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    // Use the display category (translated) for the UI
    String selectedCategory = groceryProvider.getDisplayCategory(item.category);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Edit Food Item'.localized(languageProvider),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Food name input
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Food Name'.localized(languageProvider),
                      hintText: 'Enter food name'.localized(languageProvider),
                      filled: true,
                      prefixIcon: const Icon(Icons.food_bank),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category title
                  Text(
                    'Select Category'.localized(languageProvider),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category grid
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: groceryProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = groceryProvider.categories[index];
                          final isSelected = category == selectedCategory;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? groceryProvider.getCategoryColor(category)
                                    : groceryProvider
                                        .getCategoryColor(category)
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    groceryProvider.getCategoryIcon(category),
                                    color: isSelected
                                        ? Colors.white
                                        : groceryProvider
                                            .getCategoryColor(category),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      // Delete button
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: Text('Delete'.localized(languageProvider)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: theme.colorScheme.error),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Food Item?'
                                    .localized(languageProvider)),
                                content: Text(
                                    'Are you sure you want to delete "${item.name}"?'
                                        .localized(languageProvider)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                        'Cancel'.localized(languageProvider)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      groceryProvider.deleteFoodItem(item);
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pop(
                                          context); // Close bottom sheet
                                    },
                                    child: Text(
                                        'Delete'.localized(languageProvider)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Save button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            if (name.isNotEmpty) {
                              groceryProvider.updateFoodItem(
                                item,
                                name: name,
                                displayCategory: selectedCategory,
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'SAVE CHANGES'.localized(languageProvider),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddFoodItemBottomSheet(
      BuildContext context, LanguageProvider languageProvider) {
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    String selectedCategory =
        'Other'.localized(languageProvider); // Default to "Other" category
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Add Food Item'.localized(languageProvider),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Food name input
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Food Name'.localized(languageProvider),
                      hintText: 'Enter food name'.localized(languageProvider),
                      filled: true,
                      prefixIcon: const Icon(Icons.food_bank),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category title
                  Text(
                    'Select Category'.localized(languageProvider),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category grid
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: groceryProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = groceryProvider.categories[index];
                          final isSelected = category == selectedCategory;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? groceryProvider.getCategoryColor(category)
                                    : groceryProvider
                                        .getCategoryColor(category)
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    groceryProvider.getCategoryIcon(category),
                                    color: isSelected
                                        ? Colors.white
                                        : groceryProvider
                                            .getCategoryColor(category),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add button
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        groceryProvider.addFoodItem(name, selectedCategory);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ADD ITEM'.localized(languageProvider),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  TextEditingController _newCategoryController = TextEditingController();
  TextEditingController _editCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    _editCategoryController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _showAddCategoryDialog(BuildContext context,
      GroceryProvider groceryProvider, LanguageProvider languageProvider) {
    _newCategoryController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Category'.localized(languageProvider)),
        content: TextField(
          controller: _newCategoryController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Category Name'.localized(languageProvider),
            hintText: 'Enter a new category name'.localized(languageProvider),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.localized(languageProvider)),
          ),
          TextButton(
            onPressed: () {
              final categoryName = _newCategoryController.text.trim();
              if (categoryName.isNotEmpty) {
                groceryProvider.addCategory(categoryName);
                Navigator.pop(context);
              }
            },
            child: Text('Add'.localized(languageProvider)),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext context,
      GroceryProvider groceryProvider,
      String category,
      LanguageProvider languageProvider) {
    _editCategoryController.text = category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'.localized(languageProvider)),
        content: TextField(
          controller: _editCategoryController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Category Name'.localized(languageProvider),
            hintText: 'Enter a new name for this category'
                .localized(languageProvider),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.localized(languageProvider)),
          ),
          TextButton(
            onPressed: () {
              final newName = _editCategoryController.text.trim();
              if (newName.isNotEmpty && newName != category) {
                groceryProvider.updateCategory(category, newName);
                Navigator.pop(context);
              }
            },
            child: Text('Save'.localized(languageProvider)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final groceryProvider = Provider.of<GroceryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Appearance Section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Appearance'.localized(languageProvider),
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),

              // Theme Mode
              ListTile(
                title: Text('App Theme'.localized(languageProvider)),
                subtitle: Text(
                    'Change how the app looks'.localized(languageProvider)),
                trailing: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  onChanged: (ThemeMode? newThemeMode) {
                    if (newThemeMode != null) {
                      themeProvider.setThemeMode(newThemeMode);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'.localized(languageProvider)),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'.localized(languageProvider)),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'.localized(languageProvider)),
                    ),
                  ],
                  underline: Container(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Language Section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Language'.localized(languageProvider),
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),

              // Language Selection
              ListTile(
                title: Text('App Language'.localized(languageProvider)),
                subtitle:
                    Text('Change the app language'.localized(languageProvider)),
                trailing: DropdownButton<AppLanguage>(
                  value: languageProvider.currentLanguage,
                  onChanged: (AppLanguage? newLanguage) {
                    if (newLanguage != null) {
                      // 1) Get the old language
                      final oldLanguage = languageProvider.currentLanguage;

                      // 2) Change to the new language as usual
                      languageProvider.setLanguage(newLanguage);

                      // 3) Now rename any existing default items from old -> new language
                      Provider.of<GroceryProvider>(context, listen: false)
                          .updateDefaultFoodItemsForLanguage(
                              oldLanguage, newLanguage);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: AppLanguage.english,
                      child: Text('English'.localized(languageProvider)),
                    ),
                    DropdownMenuItem(
                      value: AppLanguage.french,
                      child: Text('French'.localized(languageProvider)),
                    ),
                  ],
                  underline: Container(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Categories Section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Categories'.localized(languageProvider),
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _showAddCategoryDialog(
                          context, groceryProvider, languageProvider),
                      tooltip: 'Add Category'.localized(languageProvider),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Default Categories List
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Default Categories'.localized(languageProvider),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              ...groceryProvider.defaultCategoryNames
                  .map((category) => ListTile(
                        leading: Icon(
                          groceryProvider.getCategoryIcon(category),
                          color: groceryProvider.getCategoryColor(category),
                        ),
                        title: Text(category),
                        subtitle: Text('Default'.localized(languageProvider)),
                        enabled: false,
                      )),

              const Divider(height: 1),

              // Custom Categories List
              if (groceryProvider.customCategories.isNotEmpty) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Custom Categories'.localized(languageProvider),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                ...groceryProvider.customCategories.map((category) => ListTile(
                      leading: const Icon(Icons.label),
                      title: Text(category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditCategoryDialog(context,
                                groceryProvider, category, languageProvider),
                            tooltip: 'Edit'.localized(languageProvider),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Category?'
                                      .localized(languageProvider)),
                                  content: Text(
                                      'Are you sure you want to delete "$category"?'
                                          .localized(languageProvider)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                          'Cancel'.localized(languageProvider)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        groceryProvider
                                            .removeCategory(category);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                          'Delete'.localized(languageProvider)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            tooltip: 'Delete'.localized(languageProvider),
                          ),
                        ],
                      ),
                    )),
              ],

              if (groceryProvider.customCategories.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'You haven\'t added any custom categories yet. Tap the + button to add a new category.'
                        .localized(languageProvider),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // About Section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'About'.localized(languageProvider),
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text('Version'.localized(languageProvider)),
                subtitle: Text(
                    '${_packageInfo.version} (${_packageInfo.buildNumber})'),
              ),
              ListTile(
                title: Text('Feedback & Support'.localized(languageProvider)),
                subtitle: Text('Report issues or suggest features'
                    .localized(languageProvider)),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open feedback mechanism
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Coming soon!'.localized(languageProvider)),
                    ),
                  );
                },
              ),
              AboutListTile(
                icon: const Icon(Icons.info_outline),
                applicationName: 'Les Courses de Papoum et Mamoune',
                applicationVersion: _packageInfo.version,
                applicationLegalese: '© 2025 Marco Schapira',
                aboutBoxChildren: [
                  const SizedBox(height: 16),
                  Text(
                    languageProvider.currentLanguage == AppLanguage.french
                        ? 'Les Courses app pour simplifier votre expérience de shopping. Organisez vos articles, enregistrez vos favoris et n\'oubliez jamais ce que vous avez besoin au magasin.'
                        : 'Les Courses app to simplify your shopping experience. Organize your items, save favourites, and never forget what you need at the store.',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// -------------------- WIDGETS --------------------

// Grocery Item Tile Widget// Grocery Item Tile Widget
// Grocery Item Tile Widget
class GroceryItemTile extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onTap;
  final VoidCallback onStarToggle;
  final VoidCallback onDelete;

  const GroceryItemTile({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onStarToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groceryProvider = Provider.of<GroceryProvider>(context);

    return Dismissible(
      key: Key(item.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // Category indicator with icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: groceryProvider
                        .getCategoryColor(item.category)
                        .withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      groceryProvider.getCategoryIcon(item.category),
                      color: groceryProvider.getCategoryColor(item.category),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Item name
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          item.isStarred ? FontWeight.bold : FontWeight.normal,
                      decoration:
                          item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted
                          ? theme.colorScheme.onSurface.withOpacity(0.5)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                // Category label - Now displaying the translated category name
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: groceryProvider
                        .getCategoryColor(item.category)
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    groceryProvider.getDisplayCategory(item.category),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Star button
                IconButton(
                  icon: Icon(
                    item.isStarred ? Icons.star : Icons.star_border,
                    color: item.isStarred ? Colors.amber : Colors.grey,
                  ),
                  onPressed: onStarToggle,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
