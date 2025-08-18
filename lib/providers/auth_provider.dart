import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool isAuthenticated = false;
  bool isLoading = false;
  String token = '';
  String error = '';
  Map<String, dynamic>? userData;

  // ------------------------
  //  MÉTHODES INTERNES
  // ------------------------
  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _setError(String errorMessage) {
    error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    error = '';
    notifyListeners();
  }

  // ------------------------
  //  AUTHENTIFICATION
  // ------------------------
  Future<void> setToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
    if (userData != null) {
      await pref.setString('user_data', jsonEncode(userData!));
    }
  }

  Future<void> removeToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.remove('user_data');
    token = '';
    userData = null;
    isAuthenticated = false;
  }

  Future<void> getToken() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token') ?? '';
    final userDataString = pref.getString('user_data');
    if (userDataString != null) {
      try {
        userData = jsonDecode(userDataString);
      } catch (e) {
        print('Erreur parsing user data: $e');
      }
    }
    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
  }

  // ------------------------
  //  UTILISATEURS
  // ------------------------
  Future<int?> getUserIdByPhone(String phone) async {
    final uri = Uri.parse('$baseUrl/users/?phone=$phone');
    try {
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]['id']; // ID trouvé
        }
      }
      return null;
    } catch (e) {
      _setError('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  Future<double?> _getUserBalance(int userId) async {
    final uri = Uri.parse('$baseUrl/users/$userId/');
    try {
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['balance'] ?? 0).toDouble();
      }
      return null;
    } catch (e) {
      _setError('Erreur lors de la récupération du solde: $e');
      return null;
    }
  }

  // ------------------------
  //  TRANSACTIONS
  // ------------------------
  Future<bool> createTransaction({
    required String type,
    required int step,
    required double amount,
    required String destinationPhone,
  }) async {
    _setLoading(true);
    clearError();

    try {
      // 1. Récupérer l'ID du destinataire via son téléphone
      final destinationId = await getUserIdByPhone(destinationPhone);
      if (destinationId == null) {
        _setError('Destinataire introuvable');
        _setLoading(false);
        return false;
      }

      // 2. Création de la transaction
      final uri = Uri.parse('$baseUrl/transactions/');
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'type': type,
          'step': step,
          'amount': amount,
          'destination_id': destinationId,
        }),
      );

      if (response.statusCode == 201) {
        _setLoading(false);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError('Erreur création transaction: ${errorData.toString()}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur connexion: $e');
      _setLoading(false);
      return false;
    }
  }

  // ------------------------
  //  INSCRIPTION / CONNEXION
  // ------------------------
  Future<bool> register(String name, String phone, String password) async {
    _setLoading(true);
    clearError();

    try {
      String uri = '$baseUrl/register/';
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'password': password,
        }),
      );

      _setLoading(false);

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError('Erreur inscription: ${errorData.toString()}');
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login(String phone, String password, BuildContext context) async {
    _setLoading(true);
    clearError();

    try {
      String uri = '$baseUrl/login/';
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['access'];
        userData = data['user'];
        isAuthenticated = true;

        await setToken();
        notifyListeners();

        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/HomeScreen');
        }
        return true;
      } else {
        _setError('Identifiants incorrects');
        if (context.mounted) {
          _showErrorDialog(context, 'Identifiants incorrects');
        }
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Erreur de connexion: $e');
      }
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);

    try {
      await removeToken();
      isAuthenticated = false;
      userData = null;
      token = '';
      clearError();

      notifyListeners();

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/LoginScreen');
      }
    } catch (e) {
      _setError('Erreur lors de la déconnexion: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------
  //  OUTILS
  // ------------------------
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> isTokenValid() async {
    if (token.isEmpty) return false;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Getters utiles
  String get userName => userData?['name'] ?? 'Utilisateur';
  String get userBalance => userData?['solde'] ?? '0';
  String get userEmail => userData?['email'] ?? '';
  String get userPhone => userData?['phone'] ?? '';
}
