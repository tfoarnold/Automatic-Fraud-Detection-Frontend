import 'dart:convert';

class LocalTransaction {
  final int? id;
  final String? reference;
  final String? type;
  final int? step;
  final String? dateEnregistrement;
  final int? originId;
  final int? destinationId;
  final String? amount;
  final String? oldbalanceOrg;
  final String? newbalanceOrig;
  final String? oldbalanceDest;
  final String? newbalanceDest;
  final String? resultPredicted; // FRAUD, LEGIT, SUSPICIOUS, PENDING
  final double? confidenceScore;
  final bool? isVerified;
  final String? fraudFlagReason;
  final String? description;
  DateTime? transactionDate;

  LocalTransaction({
    this.id,
    this.reference,
    this.type,
    this.step,
    this.dateEnregistrement,
    this.originId,
    this.destinationId,
    this.amount,
    this.oldbalanceOrg,
    this.newbalanceOrig,
    this.oldbalanceDest,
    this.newbalanceDest,
    this.resultPredicted,
    this.confidenceScore,
    this.isVerified,
    this.fraudFlagReason,
    this.description,
    this.transactionDate,
  });

  factory LocalTransaction.fromJson(Map<String, dynamic> json) {
    return LocalTransaction(
      id: json['id'],
      reference: json['reference'],
      type: json['type'],
      step: json['step'],
      dateEnregistrement: json['date_enregistrement'],
      // CORRECTION: Extraire l'ID depuis l'objet origin/destination
      originId: _extractId(json['origin_id'] ?? json['origin']),
      destinationId: _extractId(json['destination_id'] ?? json['destination']),
      amount: json['amount']?.toString(),
      oldbalanceOrg: json['oldbalanceOrg']?.toString(),
      newbalanceOrig: json['newbalanceOrig']?.toString(),
      oldbalanceDest: json['oldbalanceDest']?.toString(),
      newbalanceDest: json['newbalanceDest']?.toString(),
      resultPredicted: json['result_predicted'],
      confidenceScore: json['confidence_score']?.toDouble(),
      isVerified: json['is_verified'],
      fraudFlagReason: json['fraud_flag_reason'],
      description: json['description'],
      transactionDate: json['date_enregistrement'] != null 
          ? DateTime.parse(json['date_enregistrement'])
          : null,
    );
  }

  // Méthode helper pour extraire l'ID
  static int? _extractId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is Map<String, dynamic>) {
      return value['id'] as int?;
    }
    return null;
  }

  // Propriétés utiles pour la détection de fraude
  bool get isFraudulent {
    return resultPredicted == 'FRAUD';
  }

  bool get isSuspicious {
    return resultPredicted == 'SUSPICIOUS';
  }

  bool get isLegitimate {
    return resultPredicted == 'LEGIT';
  }

  bool get isPending {
    return resultPredicted == 'PENDING';
  }

  String get statusDisplay {
    switch (resultPredicted) {
      case 'FRAUD':
        return 'Frauduleuse';
      case 'SUSPICIOUS':
        return 'Suspecte';
      case 'LEGIT':
        return 'Légitime';
      case 'PENDING':
        return 'En attente';
      default:
        return 'Inconnue';
    }
  }

  String get typeDisplay {
    switch (type) {
      case 'CASH_IN':
        return 'Dépôt';
      case 'CASH_OUT':
        return 'Retrait';
      case 'TRANSFER':
        return 'Transfert';
      case 'PAYMENT':
        return 'Paiement';
      case 'DEBIT':
        return 'Prélèvement';
      default:
        return type ?? 'Transaction';
    }
  }

  static Map<String, dynamic>? toMap(LocalTransaction transaction) => {
        'id': transaction.id,
        'reference': transaction.reference,
        'type': transaction.type,
        'step': transaction.step,
        'date_enregistrement': transaction.dateEnregistrement,
        'origin_id': transaction.originId,
        'destination_id': transaction.destinationId,
        'amount': transaction.amount,
        'oldbalanceOrg': transaction.oldbalanceOrg,
        'newbalanceOrig': transaction.newbalanceOrig,
        'oldbalanceDest': transaction.oldbalanceDest,
        'newbalanceDest': transaction.newbalanceDest,
        'result_predicted': transaction.resultPredicted,
        'confidence_score': transaction.confidenceScore,
        'is_verified': transaction.isVerified,
        'fraud_flag_reason': transaction.fraudFlagReason,
        'description': transaction.description,
      };

  static String encode(List<LocalTransaction> transactions) => json.encode(
        transactions
            .map<Map<String, dynamic>?>(
                (transaction) => LocalTransaction.toMap(transaction))
            .toList(),
      );

  static List<LocalTransaction> decode(String transaction) =>
      (json.decode(transaction) as List<dynamic>)
          .map<LocalTransaction>((item) => LocalTransaction.fromJson(item))
          .toList();
}