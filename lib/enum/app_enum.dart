enum PartnerStatus { active, inactive }

String partnerStatusToString(PartnerStatus status) {
  return status.toString().split('.').last;
}

PartnerStatus stringToPartnerStatus(String status) {
  return PartnerStatus.values.firstWhere(
    (e) => e.toString().split('.').last == status,
    orElse: () => PartnerStatus.inactive,
  );
}

enum OrderStatus { pending, shipped, delivered, canceled }
