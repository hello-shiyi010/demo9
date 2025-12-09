import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../services/warehouse_service.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final warehouseService = Provider.of<WarehouseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('智能仓储管理系统'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎区域
            const Text(
              '欢迎回来，管理员',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '实时监控仓储状态',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // 设备状态卡片
            _buildDeviceStatusCard(context, warehouseService),
            const SizedBox(height: 20),

            // 库存统计卡片
            _buildInventoryStatsCard(context, warehouseService),
            const SizedBox(height: 20),

            // 最近活动卡片
            _buildRecentActivitiesCard(context, warehouseService),
          ],
        ),
      ),
    );
  }

  // 设备状态卡片
  Widget _buildDeviceStatusCard(
    BuildContext context,
    WarehouseService warehouseService,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '设备状态',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '查看全部',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 设备状态网格
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDeviceItem(
                  context,
                  icon: Icons.camera_alt_outlined,
                  title: '摄像头',
                  count: warehouseService.getDeviceCountByType(
                    DeviceType.camera,
                  ),
                  status:
                      '${warehouseService.getDeviceCountByStatus(DeviceStatus.online)} 在线',
                  color: AppTheme.successColor,
                ),
                _buildDeviceItem(
                  context,
                  icon: Icons.mic_outlined,
                  title: '麦克风',
                  count: warehouseService.getDeviceCountByType(
                    DeviceType.microphone,
                  ),
                  status:
                      '${warehouseService.getDeviceCountByStatus(DeviceStatus.online)} 在线',
                  color: AppTheme.successColor,
                ),
                _buildDeviceItem(
                  context,
                  icon: Icons.speaker_outlined,
                  title: '扬声器',
                  count: warehouseService.getDeviceCountByType(
                    DeviceType.speaker,
                  ),
                  status:
                      '${warehouseService.getDeviceCountByStatus(DeviceStatus.online)} 在线',
                  color: AppTheme.successColor,
                ),
                _buildDeviceItem(
                  context,
                  icon: Icons.devices_other_outlined,
                  title: '传感器',
                  count: warehouseService.getDeviceCountByType(
                    DeviceType.sensor,
                  ),
                  status:
                      '${warehouseService.getDeviceCountByStatus(DeviceStatus.online)} 在线',
                  color: AppTheme.warningColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 设备项
  Widget _buildDeviceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int count,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppTheme.primaryColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count 台',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 库存统计卡片
  Widget _buildInventoryStatsCard(
    BuildContext context,
    WarehouseService warehouseService,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '库存统计',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 库存数据
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInventoryItem(
                  context,
                  title: '总库存',
                  value: warehouseService.totalInventoryCount.toString(),
                  change: '+2.5%',
                  color: AppTheme.successColor,
                ),
                Container(width: 1, height: 80, color: AppTheme.borderColor),
                _buildInventoryItem(
                  context,
                  title: '今日入库',
                  value: warehouseService.todayInventoryIn.toString(),
                  change: '+15.2%',
                  color: AppTheme.successColor,
                ),
                Container(width: 1, height: 80, color: AppTheme.borderColor),
                _buildInventoryItem(
                  context,
                  title: '今日出库',
                  value: warehouseService.todayInventoryOut.toString(),
                  change: '-3.1%',
                  color: AppTheme.errorColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 库存项
  Widget _buildInventoryItem(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                change.startsWith('+')
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 最近活动卡片
  Widget _buildRecentActivitiesCard(
    BuildContext context,
    WarehouseService warehouseService,
  ) {
    // Generate recent activities from device and inventory data
    final activities = [
      // Activity 1: Camera detected anomaly
      {
        'icon': Icons.camera_alt_outlined,
        'title': '摄像头 1 检测到异常',
        'time': '10:30 AM',
        'status': '已处理',
        'color': AppTheme.successColor,
      },
      // Activity 2: Microphone recording completed
      {
        'icon': Icons.mic_outlined,
        'title': '麦克风 3 录音完成',
        'time': '09:45 AM',
        'status': '已上传',
        'color': AppTheme.successColor,
      },
      // Activity 3: Sensor low battery warning
      {
        'icon': Icons.devices_other_outlined,
        'title': '传感器 7 低电量警告',
        'time': '08:20 AM',
        'status': '待处理',
        'color': AppTheme.warningColor,
      },
      // Activity 4: Inventory item low stock
      {
        'icon': Icons.inventory_outlined,
        'title': 'T恤衫库存不足',
        'time': '07:15 AM',
        'status': '已通知',
        'color': AppTheme.warningColor,
      },
      // Activity 5: Device online
      {
        'icon': Icons.check_circle_outlined,
        'title': '扬声器 1 上线',
        'time': '06:45 AM',
        'status': '正常',
        'color': AppTheme.successColor,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '最近活动',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 活动列表
            Column(
              children: activities.map((activity) {
                return Column(
                  children: [
                    _buildActivityItem(
                      context,
                      icon: activity['icon'] as IconData,
                      title: activity['title'] as String,
                      time: activity['time'] as String,
                      status: activity['status'] as String,
                      color: activity['color'] as Color,
                    ),
                    const Divider(height: 24),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 活动项
  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String time,
    required String status,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
