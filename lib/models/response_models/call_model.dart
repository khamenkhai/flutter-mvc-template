class CallModel {
  final String roomId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final String callType;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;

  CallModel({
    required this.roomId,
    required this.callerId,
    required this.callerName,
    required this.receiverName,
    required this.receiverId,
    required this.callType,
    required this.status,
    required this.startedAt,
    this.endedAt,
  });

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      "callerId": callerId,
      "receiverId": receiverId,
      "callType": callType,
      "callerName": callerName,
      "receiverName": receiverName,
      "startedAt": startedAt.millisecondsSinceEpoch,
      "endedAt": endedAt?.millisecondsSinceEpoch,
      "status": status,
    };
  }

  // Create model from Firestore document
  factory CallModel.fromMap(String id, Map<String, dynamic> data) {
    int startedAt = int.parse(data["startedAt"].toString());
    // int endedAt = int.parse(data["endedAt"].toString());
    return CallModel(
      roomId: id,
      callerId: data["callerId"],
      receiverId: data["receiverId"],
      callType: data["callType"],
      callerName: data["callerName"],
      receiverName: data["receiverName"],
      status: data["status"],
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedAt),
      endedAt: data["endedAt"] != null
          ? DateTime.fromMillisecondsSinceEpoch(data["endedAt"])
          : null,
    );
  }
}
