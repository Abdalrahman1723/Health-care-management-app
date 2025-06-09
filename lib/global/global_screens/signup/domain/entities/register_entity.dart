class RegisterEntity {
  final String actorId;
  final String role;
  final String token;
  final int validFor;

  RegisterEntity({
    required this.actorId,
    required this.role,
    required this.token,
    required this.validFor,
  });
}
