import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionsProvider with ChangeNotifier {
  List<LocalTransaction> transactions = [];
  bool isLoading = false;
  String error = '';

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

  // Méthode améliorée avec gestion d'erreurs et token expiré
  Future<bool> getTransactions(String token) async {
    _setLoading(true);
    clearError();
    
    try {
      // print('Token envoyé: Bearer $token');
      http.Response response = await http.get(
        Uri.parse('$baseUrl/transactions/'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      
      if (response.statusCode == 200) {
        transactions = LocalTransaction.decode(response.body.toString());
        _setLoading(false);
        print('Transactions: $transactions');
        return true;
      } else if (response.statusCode == 401) {
        // Token expiré ou invalide
        final errorData = jsonDecode(response.body);
        _setError('Session expirée. Veuillez vous reconnecter.');
        _setLoading(false);
        return false;
      } else {
        _setError('Erreur lors du chargement des transactions (${response.statusCode})');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      _setLoading(false);
      return false;
    }
  }

  Future addTransaction(int categoryId, String amount, String description,
      String transDate, String token, BuildContext context) async {
    _setLoading(true);
    clearError();
    
    try {
      String uri = '$baseUrl/transactions';
      final respons = await http.post(Uri.parse(uri),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token'
          },
          body: jsonEncode({
            'category_id': categoryId,
            'amount': int.parse(amount),
            'description': description,
            'transaction_date': transDate,
          }));
          
      if (respons.statusCode == 201) {
        Navigator.of(context).pop();
        // Recharger les transactions après ajout
        await getTransactions(token);
      } else {
        _setError('Erreur lors de l\'ajout de la transaction');
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
    }
    
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> editTransaction(int id, String amount, String description,
      int categoryId, String transactionDate, String token) async {
    _setLoading(true);
    clearError();
    
    try {
      String uri = '$baseUrl/transactions/$id';
      final response = await http.put(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'description': description,
          'category_id': categoryId,
          'amount': amount,
          'transaction_date': transactionDate,
        }),
      );
      
      if (response.statusCode == 200) {
        // Recharger les transactions après modification
        await getTransactions(token);
        _setLoading(false);
        return true;
      } else {
        _setError('Erreur lors de la modification');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteTransaction(int id, String token) async {
    _setLoading(true);
    clearError();
    
    try {
      String uri = '$baseUrl/transactions/$id';
      final response = await http.delete(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Recharger les transactions après suppression
        await getTransactions(token);
        _setLoading(false);
        return true;
      } else {
        _setError('Erreur lors de la suppression');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      _setLoading(false);
      return false;
    }
  }

  // Getter utile pour avoir un accès facile aux transactions
  List<LocalTransaction> get allTransactions => transactions;
}