enum AuthType {
  pincodeOnly,
  pincodeWithFaceID,
  pincodeWithTouchID;

  static AuthType fromString(String value) {
    return AuthType.values.firstWhere(
      (type) => type.toString() == value,
      orElse: () => AuthType.pincodeOnly,
    );
  }
}
