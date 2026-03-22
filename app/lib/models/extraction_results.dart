class RiskItem {
  final String clause;
  final String severity;
  final String reason;

  RiskItem({required this.clause, required this.severity, required this.reason});

  factory RiskItem.fromJson(Map<String, dynamic> json) {
    return RiskItem(
      clause: json['clause'],
      severity: json['severity'],
      reason: json['reason'],
    );
  }
}

class ExtractionResult {
  final String entityName;
  final String docType;
  final List<RiskItem> risks;

  ExtractionResult({required this.entityName, required this.docType, required this.risks});

  factory ExtractionResult.fromJson(Map<String, dynamic> json) {
    var list = json['risks'] as List;
    return ExtractionResult(
      entityName: json['entity_name'],
      docType: json['document_type'],
      risks: list.map((i) => RiskItem.fromJson(i)).toList(),
    );
  }
}