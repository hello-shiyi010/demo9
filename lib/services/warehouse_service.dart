import 'dart:collection';
import '../models/device_model.dart';
import '../models/inventory_model.dart';
import '../models/warehouse_model.dart';
import 'camera_service.dart';
import 'audio_service.dart';

// Warehouse service for intelligent warehouse management
class WarehouseService {
  static final WarehouseService _instance = WarehouseService._internal();
  factory WarehouseService() => _instance;
  WarehouseService._internal();

  // Services dependencies
  final CameraService _cameraService = CameraService();
  final AudioService _audioService = AudioService();

  // Data storage (in-memory, can be replaced with database or API later)
  final Map<String, Device> _devices = {};
  final Map<String, InventoryItem> _inventoryItems = {};
  final Map<String, WarehouseZone> _warehouseZones = {};
  final Map<String, WarehouseLocation> _warehouseLocations = {};

  // Getters
  UnmodifiableMapView<String, Device> get devices =>
      UnmodifiableMapView(_devices);
  UnmodifiableMapView<String, InventoryItem> get inventoryItems =>
      UnmodifiableMapView(_inventoryItems);
  UnmodifiableMapView<String, WarehouseZone> get warehouseZones =>
      UnmodifiableMapView(_warehouseZones);
  UnmodifiableMapView<String, WarehouseLocation> get warehouseLocations =>
      UnmodifiableMapView(_warehouseLocations);

  // Initialize the warehouse service
  Future<void> initialize() async {
    // Initialize device services
    await Future.wait([
      _cameraService.initialize(),
      _audioService.initialize(),
    ]);

    // Initialize with sample data
    _initializeSampleData();
  }

  // Initialize sample data
  void _initializeSampleData() {
    // Add sample warehouse zones
    _warehouseZones.addAll({
      'zone_001': WarehouseZone(
        id: 'zone_001',
        name: 'A区',
        type: WarehouseZoneType.storage,
        description: '主要存储电子产品',
        locationIds: ['loc_001', 'loc_002', 'loc_003'],
        totalArea: 500,
        isRestricted: false,
      ),
      'zone_002': WarehouseZone(
        id: 'zone_002',
        name: 'B区',
        type: WarehouseZoneType.storage,
        description: '主要存储服装和日用品',
        locationIds: ['loc_004', 'loc_005', 'loc_006'],
        totalArea: 400,
        isRestricted: false,
      ),
      'zone_003': WarehouseZone(
        id: 'zone_003',
        name: 'C区',
        type: WarehouseZoneType.storage,
        description: '主要存储食品和饮料',
        locationIds: ['loc_007', 'loc_008', 'loc_009'],
        totalArea: 300,
        isRestricted: false,
      ),
      'zone_004': WarehouseZone(
        id: 'zone_004',
        name: 'D区',
        type: WarehouseZoneType.storage,
        description: '主要存储药品和保健品',
        locationIds: ['loc_010', 'loc_011', 'loc_012'],
        totalArea: 200,
        isRestricted: true,
      ),
      'zone_005': WarehouseZone(
        id: 'zone_005',
        name: 'E区',
        type: WarehouseZoneType.storage,
        description: '主要存储其他物品',
        locationIds: ['loc_013', 'loc_014', 'loc_015'],
        totalArea: 350,
        isRestricted: false,
      ),
    });

    // Add sample warehouse locations
    _warehouseLocations.addAll({
      'loc_001': WarehouseLocation(
        id: 'loc_001',
        name: 'A区-货架1-顶层',
        zoneId: 'zone_001',
        coordinates: '10,20',
        rackNumber: 'A001',
        shelfNumber: 'S01',
        levelNumber: 'L01',
        isOccupied: true,
        deviceId: 'device_001',
        inventoryItemId: 'inventory_001',
      ),
      'loc_002': WarehouseLocation(
        id: 'loc_002',
        name: 'A区-货架1-中层',
        zoneId: 'zone_001',
        coordinates: '10,15',
        rackNumber: 'A001',
        shelfNumber: 'S01',
        levelNumber: 'L02',
        isOccupied: true,
        deviceId: 'device_002',
        inventoryItemId: 'inventory_002',
      ),
      'loc_003': WarehouseLocation(
        id: 'loc_003',
        name: 'A区-货架1-底层',
        zoneId: 'zone_001',
        coordinates: '10,10',
        rackNumber: 'A001',
        shelfNumber: 'S01',
        levelNumber: 'L03',
        isOccupied: false,
      ),
      'loc_004': WarehouseLocation(
        id: 'loc_004',
        name: 'B区-货架2-顶层',
        zoneId: 'zone_002',
        coordinates: '20,20',
        rackNumber: 'B002',
        shelfNumber: 'S02',
        levelNumber: 'L01',
        isOccupied: false,
      ),
      'loc_005': WarehouseLocation(
        id: 'loc_005',
        name: 'B区-货架2-中层',
        zoneId: 'zone_002',
        coordinates: '20,15',
        rackNumber: 'B002',
        shelfNumber: 'S02',
        levelNumber: 'L02',
        isOccupied: false,
      ),
      'loc_006': WarehouseLocation(
        id: 'loc_006',
        name: 'B区-货架2-底层',
        zoneId: 'zone_002',
        coordinates: '20,10',
        rackNumber: 'B002',
        shelfNumber: 'S02',
        levelNumber: 'L03',
        isOccupied: true,
        inventoryItemId: 'inventory_003',
      ),
      'loc_007': WarehouseLocation(
        id: 'loc_007',
        name: 'C区-货架3-顶层',
        zoneId: 'zone_003',
        coordinates: '30,20',
        rackNumber: 'C003',
        shelfNumber: 'S03',
        levelNumber: 'L01',
        isOccupied: true,
        inventoryItemId: 'inventory_004',
      ),
      'loc_008': WarehouseLocation(
        id: 'loc_008',
        name: 'C区-货架3-中层',
        zoneId: 'zone_003',
        coordinates: '30,15',
        rackNumber: 'C003',
        shelfNumber: 'S03',
        levelNumber: 'L02',
        isOccupied: false,
      ),
      'loc_009': WarehouseLocation(
        id: 'loc_009',
        name: 'C区-货架3-底层',
        zoneId: 'zone_003',
        coordinates: '30,10',
        rackNumber: 'C003',
        shelfNumber: 'S03',
        levelNumber: 'L03',
        isOccupied: false,
      ),
      'loc_010': WarehouseLocation(
        id: 'loc_010',
        name: 'D区-货架4-顶层',
        zoneId: 'zone_004',
        coordinates: '40,20',
        rackNumber: 'D004',
        shelfNumber: 'S04',
        levelNumber: 'L01',
        isOccupied: false,
      ),
      'loc_011': WarehouseLocation(
        id: 'loc_011',
        name: 'D区-货架4-中层',
        zoneId: 'zone_004',
        coordinates: '40,15',
        rackNumber: 'D004',
        shelfNumber: 'S04',
        levelNumber: 'L02',
        isOccupied: true,
        inventoryItemId: 'inventory_005',
      ),
      'loc_012': WarehouseLocation(
        id: 'loc_012',
        name: 'D区-货架4-底层',
        zoneId: 'zone_004',
        coordinates: '40,10',
        rackNumber: 'D004',
        shelfNumber: 'S04',
        levelNumber: 'L03',
        isOccupied: false,
      ),
      'loc_013': WarehouseLocation(
        id: 'loc_013',
        name: 'E区-仓库角落',
        zoneId: 'zone_005',
        coordinates: '50,10',
        rackNumber: 'E005',
        shelfNumber: 'S05',
        levelNumber: 'L01',
        isOccupied: true,
        deviceId: 'device_006',
      ),
      'loc_014': WarehouseLocation(
        id: 'loc_014',
        name: 'E区-通道口',
        zoneId: 'zone_005',
        coordinates: '50,15',
        rackNumber: 'E005',
        shelfNumber: 'S05',
        levelNumber: 'L02',
        isOccupied: true,
        deviceId: 'device_003',
      ),
      'loc_015': WarehouseLocation(
        id: 'loc_015',
        name: 'E区-主通道',
        zoneId: 'zone_005',
        coordinates: '50,20',
        rackNumber: 'E005',
        shelfNumber: 'S05',
        levelNumber: 'L03',
        isOccupied: true,
        deviceId: 'device_004',
      ),
    });

    // Add sample devices
    _devices.addAll({
      'device_001': Device(
        id: 'device_001',
        name: '摄像头 1',
        type: DeviceType.camera,
        status: DeviceStatus.online,
        location: 'A区-货架1-顶层',
        ipAddress: '192.168.1.101',
        lastActive: DateTime.now(),
        properties: {'resolution': '1920x1080', 'fps': 30},
      ),
      'device_002': Device(
        id: 'device_002',
        name: '摄像头 2',
        type: DeviceType.camera,
        status: DeviceStatus.online,
        location: 'A区-货架1-中层',
        ipAddress: '192.168.1.102',
        lastActive: DateTime.now(),
        properties: {'resolution': '1920x1080', 'fps': 30},
      ),
      'device_003': Device(
        id: 'device_003',
        name: '麦克风 1',
        type: DeviceType.microphone,
        status: DeviceStatus.online,
        location: 'B区-通道口',
        ipAddress: '192.168.1.201',
        lastActive: DateTime.now(),
      ),
      'device_004': Device(
        id: 'device_004',
        name: '扬声器 1',
        type: DeviceType.speaker,
        status: DeviceStatus.online,
        location: 'C区-主通道',
        ipAddress: '192.168.1.301',
        lastActive: DateTime.now(),
      ),
      'device_005': Device(
        id: 'device_005',
        name: '传感器 7',
        type: DeviceType.sensor,
        status: DeviceStatus.alarm,
        location: 'D区-冷藏库',
        ipAddress: '192.168.1.407',
        lastActive: DateTime.now(),
        properties: {'temperature': 8.5, 'humidity': 65},
        alarmMessage: '温度异常: 8.5°C',
      ),
      'device_006': Device(
        id: 'device_006',
        name: '传感器 8',
        type: DeviceType.sensor,
        status: DeviceStatus.offline,
        location: 'E区-仓库角落',
        ipAddress: '192.168.1.408',
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    });

    // Add sample inventory items
    _inventoryItems.addAll({
      'inventory_001': InventoryItem(
        id: 'inventory_001',
        name: '智能手机',
        barcode: '123456789012',
        category: InventoryCategory.electronics,
        status: InventoryStatus.inStock,
        currentStock: 150,
        minimumStock: 50,
        unitPrice: 2999.99,
        location: 'A区-货架1-顶层',
        supplier: '供应商 A',
        lastUpdated: DateTime.now(),
        properties: {'brand': 'Example', 'model': 'X1 Pro', 'storage': '128GB'},
        description: '最新款智能手机，支持5G网络',
      ),
      'inventory_002': InventoryItem(
        id: 'inventory_002',
        name: '笔记本电脑',
        barcode: '987654321098',
        category: InventoryCategory.electronics,
        status: InventoryStatus.inStock,
        currentStock: 75,
        minimumStock: 20,
        unitPrice: 5999.99,
        location: 'A区-货架1-中层',
        supplier: '供应商 B',
        lastUpdated: DateTime.now(),
        properties: {
          'brand': 'Example',
          'model': 'Laptop Pro',
          'cpu': 'Intel i7',
        },
        description: '高性能笔记本电脑，适合办公和游戏',
      ),
      'inventory_003': InventoryItem(
        id: 'inventory_003',
        name: 'T恤衫',
        barcode: '456789012345',
        category: InventoryCategory.clothing,
        status: InventoryStatus.lowStock,
        currentStock: 15,
        minimumStock: 30,
        unitPrice: 99.99,
        location: 'B区-货架2-底层',
        supplier: '供应商 C',
        lastUpdated: DateTime.now(),
        properties: {'size': 'M', 'color': 'Red', 'material': 'Cotton'},
        description: '纯棉T恤衫，舒适透气',
      ),
      'inventory_004': InventoryItem(
        id: 'inventory_004',
        name: '矿泉水',
        barcode: '789012345678',
        category: InventoryCategory.food,
        status: InventoryStatus.inStock,
        currentStock: 500,
        minimumStock: 100,
        unitPrice: 2.0,
        location: 'C区-货架3-顶层',
        supplier: '供应商 D',
        lastUpdated: DateTime.now(),
        expirationDate: DateTime.now().add(const Duration(days: 365)),
        properties: {'volume': '500ml', 'brand': 'Pure Water'},
        description: '饮用矿泉水，天然矿物质',
      ),
      'inventory_005': InventoryItem(
        id: 'inventory_005',
        name: '医用口罩',
        barcode: '234567890123',
        category: InventoryCategory.medicine,
        status: InventoryStatus.outOfStock,
        currentStock: 0,
        minimumStock: 200,
        unitPrice: 0.5,
        location: 'D区-货架4-中层',
        supplier: '供应商 E',
        lastUpdated: DateTime.now(),
        properties: {'type': 'Surgical', 'protection': '3-ply'},
        description: '一次性医用口罩，三层防护',
      ),
    });
  }

  // Device management methods

  // Add a new device
  void addDevice(Device device) {
    _devices[device.id] = device;
  }

  // Update an existing device
  void updateDevice(Device device) {
    if (_devices.containsKey(device.id)) {
      _devices[device.id] = device;
    }
  }

  // Remove a device by ID
  void removeDevice(String deviceId) {
    _devices.remove(deviceId);
  }

  // Get a device by ID
  Device? getDevice(String deviceId) {
    return _devices[deviceId];
  }

  // Get devices by type
  List<Device> getDevicesByType(DeviceType type) {
    return _devices.values.where((device) => device.type == type).toList();
  }

  // Get devices by status
  List<Device> getDevicesByStatus(DeviceStatus status) {
    return _devices.values.where((device) => device.status == status).toList();
  }

  // Inventory management methods

  // Add a new inventory item
  void addInventoryItem(InventoryItem item) {
    _inventoryItems[item.id] = item;
  }

  // Update an existing inventory item
  void updateInventoryItem(InventoryItem item) {
    if (_inventoryItems.containsKey(item.id)) {
      _inventoryItems[item.id] = item;
    }
  }

  // Remove an inventory item by ID
  void removeInventoryItem(String itemId) {
    _inventoryItems.remove(itemId);
  }

  // Get an inventory item by ID
  InventoryItem? getInventoryItem(String itemId) {
    return _inventoryItems[itemId];
  }

  // Get inventory items by category
  List<InventoryItem> getInventoryItemsByCategory(InventoryCategory category) {
    return _inventoryItems.values
        .where((item) => item.category == category)
        .toList();
  }

  // Get inventory items by status
  List<InventoryItem> getInventoryItemsByStatus(InventoryStatus status) {
    return _inventoryItems.values
        .where((item) => item.status == status)
        .toList();
  }

  // Get low stock inventory items
  List<InventoryItem> getLowStockItems() {
    return _inventoryItems.values.where((item) => item.isLowStock()).toList();
  }

  // Get out of stock inventory items
  List<InventoryItem> getOutOfStockItems() {
    return _inventoryItems.values.where((item) => item.isOutOfStock()).toList();
  }

  // Device control integration methods

  // Get camera service instance
  CameraService get cameraService => _cameraService;

  // Get audio service instance
  AudioService get audioService => _audioService;

  // Get device count by type
  int getDeviceCountByType(DeviceType type) {
    return _devices.values.where((device) => device.type == type).length;
  }

  // Get device count by status
  int getDeviceCountByStatus(DeviceStatus status) {
    return _devices.values.where((device) => device.status == status).length;
  }

  // Get total device count
  int get totalDeviceCount => _devices.length;

  // Get total inventory count
  int get totalInventoryCount {
    return _inventoryItems.values.fold(
      0,
      (sum, item) => sum + item.currentStock,
    );
  }

  // Get total inventory value
  double get totalInventoryValue {
    return _inventoryItems.values.fold(
      0.0,
      (sum, item) => sum + item.getTotalValue(),
    );
  }

  // Get today's inventory in (mock data)
  int get todayInventoryIn => 342;

  // Get today's inventory out (mock data)
  int get todayInventoryOut => 287;
}
