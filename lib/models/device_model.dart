// Device model for intelligent warehouse system

enum DeviceType { camera, microphone, speaker, sensor, other }

enum DeviceStatus { online, offline, alarm, maintenance }

class Device {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final String location;
  final String ipAddress;
  final DateTime lastActive;
  final Map<String, dynamic>? properties;
  final String? alarmMessage;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.location,
    required this.ipAddress,
    required this.lastActive,
    this.properties,
    this.alarmMessage,
  });

  // Factory method to create a Device from a map
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      type: _parseDeviceType(map['type']),
      status: _parseDeviceStatus(map['status']),
      location: map['location'],
      ipAddress: map['ipAddress'],
      lastActive: DateTime.parse(map['lastActive']),
      properties: map['properties'],
      alarmMessage: map['alarmMessage'],
    );
  }

  // Helper method to parse DeviceType from string
  static DeviceType _parseDeviceType(String type) {
    switch (type.toLowerCase()) {
      case 'camera':
        return DeviceType.camera;
      case 'microphone':
        return DeviceType.microphone;
      case 'speaker':
        return DeviceType.speaker;
      case 'sensor':
        return DeviceType.sensor;
      default:
        return DeviceType.other;
    }
  }

  // Helper method to parse DeviceStatus from string
  static DeviceStatus _parseDeviceStatus(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return DeviceStatus.online;
      case 'offline':
        return DeviceStatus.offline;
      case 'alarm':
        return DeviceStatus.alarm;
      case 'maintenance':
        return DeviceStatus.maintenance;
      default:
        return DeviceStatus.offline;
    }
  }

  // Convert Device to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'location': location,
      'ipAddress': ipAddress,
      'lastActive': lastActive.toIso8601String(),
      'properties': properties,
      'alarmMessage': alarmMessage,
    };
  }

  // Get device type icon
  String getTypeIcon() {
    switch (type) {
      case DeviceType.camera:
        return '📷';
      case DeviceType.microphone:
        return '🎤';
      case DeviceType.speaker:
        return '🔊';
      case DeviceType.sensor:
        return '📡';
      default:
        return '📱';
    }
  }

  // Get device status color
  String getStatusColor() {
    switch (status) {
      case DeviceStatus.online:
        return '#2ECC71'; // Green
      case DeviceStatus.offline:
        return '#E74C3C'; // Red
      case DeviceStatus.alarm:
        return '#F39C12'; // Orange
      case DeviceStatus.maintenance:
        return '#3498DB'; // Blue
      default:
        return '#95A5A6'; // Gray
    }
  }

  // Get device status text
  String getStatusText() {
    switch (status) {
      case DeviceStatus.online:
        return '在线';
      case DeviceStatus.offline:
        return '离线';
      case DeviceStatus.alarm:
        return '告警';
      case DeviceStatus.maintenance:
        return '维护中';
      default:
        return '未知';
    }
  }

  // Get device type text
  String getTypeText() {
    switch (type) {
      case DeviceType.camera:
        return '摄像头';
      case DeviceType.microphone:
        return '麦克风';
      case DeviceType.speaker:
        return '扬声器';
      case DeviceType.sensor:
        return '传感器';
      default:
        return '其他设备';
    }
  }
}
