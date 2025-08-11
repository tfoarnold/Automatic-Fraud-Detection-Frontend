import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool isAuthenticated = false;
  bool isLoading = false; // Ajout de l'état de chargement
  String token = '';
  String error = '';
  Map<String, dynamic>? userData;
  


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
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Inscription réussie: $data');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError('Erreur inscription: ${errorData.toString()}');
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      return false;
    } finally {
      _setLoading(false);
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
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['access']; // JWT access token
        userData = data['user'];
        isAuthenticated = true;
        
        await setToken();
        _setLoading(false);
        notifyListeners();
        
        // Navigation vers HomeScreen - vérifier que le context est toujours valide
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/HomeScreen');
        }
        // print('Token reçu: $token');
        return true;
      } else {
        _setLoading(false);
        final errorData = jsonDecode(response.body);
        _setError('Identifiants incorrects');
        
        // Vérifier que le context est toujours valide avant d'afficher le dialog
        if (context.mounted) {
          _showErrorDialog(context, 'Identifiants incorrects');
        }
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Erreur de connexion: $e');
      
      // Vérifier que le context est toujours valide avant d'afficher le dialog
      if (context.mounted) {
        _showErrorDialog(context, 'Erreur de connexion: $e');
      }
      return false;
    }
  }
  
  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    
    try {
      // Nettoyage des données locales
      await removeToken();
      isAuthenticated = false;
      userData = null;
      token = '';
      clearError();
      
      notifyListeners();
      
      // Navigation complète vers l'écran de connexion
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/LoginScreen');
      }
    } catch (e) {
      _setError('Erreur lors de la déconnexion: $e');
      throw e; // Re-lancer l'erreur pour que le dialog puisse la gérer
    } finally {
      _setLoading(false);
    }
  }
  
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
  
  // Vérifier si le token est encore valide
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
  String get userEmail => userData?['email'] ?? '';
  String get userPhone => userData?['phone'] ?? '';
}