// Warehouse location and zone model for intelligent warehouse system

enum WarehouseZoneType {
  storage,
  office,
  loading,
  parking,
  other,
}

class WarehouseZone {
  final String id;
  final String name;
  final WarehouseZoneType type;
  final String description;
  final List<String> locationIds;
  final int totalArea;
  final bool isRestricted;

  WarehouseZone({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.locationIds,
    required this.totalArea,
    required this.isRestricted,
  });

  // Factory method to create a WarehouseZone from a map
  factory WarehouseZone.fromMap(Map<String, dynamic> map) {
    return WarehouseZone(
      id: map['id'],
      name: map['name'],
      type: _parseZoneType(map['type']),
      description: map['description'],
      locationIds: List<String>.from(map['locationIds']),
      totalArea: map['totalArea'],
      isRestricted: map['isRestricted'],
    );
  }

  // Helper method to parse WarehouseZoneType from string
  static WarehouseZoneType _parseZoneType(String type) {
    switch (type.toLowerCase()) {
      case 'storage':
        return WarehouseZoneType.storage;
      case 'office':
        return WarehouseZoneType.office;
      case 'loading':
        return WarehouseZoneType.loading;
      case 'parking':
        return WarehouseZoneType.parking;
      default:
        return WarehouseZoneType.other;
    }
  }

  // Convert WarehouseZone to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'description': description,
      'locationIds': locationIds,
      'totalArea': totalArea,
      'isRestricted': isRestricted,
    };
  }

  // Get zone type text
  String getTypeText() {
    switch (type) {
      case WarehouseZoneType.storage:
        return '存储区';
      case WarehouseZoneType.office:
        return '办公区';
      case WarehouseZoneType.loading:
        return '装卸区';
      case WarehouseZoneType.parking:
        return '停车区';
      default:
        return '其他区域';
    }
  }
}

class WarehouseLocation {
  final String id;
  final String name;
  final String zoneId;
  final String coordinates;
  final String rackNumber;
  final String shelfNumber;
  final String levelNumber;
  final bool isOccupied;
  final String? deviceId;
  final String? inventoryItemId;

  WarehouseLocation({
    required this.id,
    required this.name,
    required this.zoneId,
    required this.coordinates,
    required this.rackNumber,
    required this.shelfNumber,
    required this.levelNumber,
    required this.isOccupied,
    this.deviceId,
    this.inventoryItemId,
  });

  // Factory method to create a WarehouseLocation from a map
  factory WarehouseLocation.fromMap(Map<String, dynamic> map) {
    return WarehouseLocation(
      id: map['id'],
      name: map['name'],
      zoneId: map['zoneId'],
      coordinates: map['coordinates'],
      rackNumber: map['rackNumber'],
      shelfNumber: map['shelfNumber'],
      levelNumber: map['levelNumber'],
      isOccupied: map['isOccupied'],
      deviceId: map['deviceId'],
      inventoryItemId: map['inventoryItemId'],
    );
  }

  // Convert WarehouseLocation to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'zoneId': zoneId,
      'coordinates': coordinates,
      'rackNumber': rackNumber,
      'shelfNumber': shelfNumber,
      'levelNumber': levelNumber,
      'isOccupied': isOccupied,
      'deviceId': deviceId,
      'inventoryItemId': inventoryItemId,
    };
  }

  // Get full location path
  String getFullLocationPath() {
    return '$rackNumber-$shelfNumber-$levelNumber';
  }

  // Get location type
  String getLocationType() {
    if (deviceId != null) {
      return '设备位置';
    } else if (inventoryItemId != null) {
      return '库存位置';
    } else {
      return '空位置';
    }
  }
}
