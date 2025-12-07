// Inventory model for intelligent warehouse system

enum InventoryStatus { inStock, lowStock, outOfStock, pending }

enum InventoryCategory {
  electronics,
  clothing,
  food,
  medicine,
  rawMaterial,
  finishedProduct,
  other,
}

class InventoryItem {
  final String id;
  final String name;
  final String barcode;
  final InventoryCategory category;
  final InventoryStatus status;
  final int currentStock;
  final int minimumStock;
  final double unitPrice;
  final String location;
  final String supplier;
  final DateTime lastUpdated;
  final DateTime? expirationDate;
  final Map<String, dynamic>? properties;
  final String? description;

  InventoryItem({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.status,
    required this.currentStock,
    required this.minimumStock,
    required this.unitPrice,
    required this.location,
    required this.supplier,
    required this.lastUpdated,
    this.expirationDate,
    this.properties,
    this.description,
  });

  // Factory method to create an InventoryItem from a map
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      category: _parseCategory(map['category']),
      status: _parseStatus(map['status']),
      currentStock: map['currentStock'],
      minimumStock: map['minimumStock'],
      unitPrice: map['unitPrice'],
      location: map['location'],
      supplier: map['supplier'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate'])
          : null,
      properties: map['properties'],
      description: map['description'],
    );
  }

  // Helper method to parse InventoryCategory from string
  static InventoryCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return InventoryCategory.electronics;
      case 'clothing':
        return InventoryCategory.clothing;
      case 'food':
        return InventoryCategory.food;
      case 'medicine':
        return InventoryCategory.medicine;
      case 'rawMaterial':
      case 'raw_material':
        return InventoryCategory.rawMaterial;
      case 'finishedProduct':
      case 'finished_product':
        return InventoryCategory.finishedProduct;
      default:
        return InventoryCategory.other;
    }
  }

  // Helper method to parse InventoryStatus from string
  static InventoryStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'inStock':
      case 'in_stock':
        return InventoryStatus.inStock;
      case 'lowStock':
      case 'low_stock':
        return InventoryStatus.lowStock;
      case 'outOfStock':
      case 'out_of_stock':
        return InventoryStatus.outOfStock;
      case 'pending':
        return InventoryStatus.pending;
      default:
        return InventoryStatus.inStock;
    }
  }

  // Convert InventoryItem to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
      'unitPrice': unitPrice,
      'location': location,
      'supplier': supplier,
      'lastUpdated': lastUpdated.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'properties': properties,
      'description': description,
    };
  }

  // Get inventory status color
  String getStatusColor() {
    switch (status) {
      case InventoryStatus.inStock:
        return '#2ECC71'; // Green
      case InventoryStatus.lowStock:
        return '#F39C12'; // Orange
      case InventoryStatus.outOfStock:
        return '#E74C3C'; // Red
      case InventoryStatus.pending:
        return '#3498DB'; // Blue
      default:
        return '#95A5A6'; // Gray
    }
  }

  // Get inventory status text
  String getStatusText() {
    switch (status) {
      case InventoryStatus.inStock:
        return '库存充足';
      case InventoryStatus.lowStock:
        return '库存不足';
      case InventoryStatus.outOfStock:
        return '缺货';
      case InventoryStatus.pending:
        return '待处理';
      default:
        return '未知';
    }
  }

  // Get inventory category text
  String getCategoryText() {
    switch (category) {
      case InventoryCategory.electronics:
        return '电子产品';
      case InventoryCategory.clothing:
        return '服装';
      case InventoryCategory.food:
        return '食品';
      case InventoryCategory.medicine:
        return '药品';
      case InventoryCategory.rawMaterial:
        return '原材料';
      case InventoryCategory.finishedProduct:
        return '成品';
      default:
        return '其他';
    }
  }

  // Get total value of current stock
  double getTotalValue() {
    return currentStock * unitPrice;
  }

  // Check if stock is low
  bool isLowStock() {
    return currentStock <= minimumStock;
  }

  // Check if stock is out of stock
  bool isOutOfStock() {
    return currentStock <= 0;
  }
}
