class ChangeAuthStatusRequest {
  ChangeAuthStatusRequest({
    required this.user,
    required this.authCutId,
    required this.status,
    required this.reason,
  });

  final String user;
  final int authCutId;
  final int status;
  final String reason;
}
