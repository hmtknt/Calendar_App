class EventScheduleModel {
  final String eventId;
  final String userId;
  final String eventHolderId;
  final String userName;
  final String eventTitle;
  final String photoUrl;
  final String phone;
  final String eventDescription;
  final String eventDate;
  final String eventTime;

  EventScheduleModel({
    required this.eventId,
    required this.userId,
    required this.eventHolderId,
    required this.userName,
    required this.eventTitle,
    required this.photoUrl,
    required this.eventDate,
    required this.eventTime,
    required this.phone,
    required this.eventDescription,
  });
}
