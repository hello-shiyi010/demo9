import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              // 跳转到添加设备页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 设备统计
            _buildDeviceStats(context),
            const SizedBox(height: 20),

            // 设备列表
            _buildDeviceList(context),
          ],
        ),
      ),
    );
  }

  // 设备统计
  Widget _buildDeviceStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '设备统计',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 统计数据
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  title: '在线设备',
                  count: 42,
                  color: AppTheme.successColor,
                ),
                _buildStatItem(
                  context,
                  title: '离线设备',
                  count: 2,
                  color: AppTheme.errorColor,
                ),
                _buildStatItem(
                  context,
                  title: '总设备数',
                  count: 44,
                  color: AppTheme.primaryColor,
                ),
                _buildStatItem(
                  context,
                  title: '告警设备',
                  count: 1,
                  color: AppTheme.warningColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 统计项
  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required int count,
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
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 设备列表
  Widget _buildDeviceList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '设备列表',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // 设备分类标签
        _buildDeviceTabs(context),
        const SizedBox(height: 16),

        // 设备卡片列表
        Column(
          children: [
            _buildDeviceCard(
              context,
              icon: Icons.camera_alt_outlined,
              name: '摄像头 1',
              type: '监控摄像头',
              status: '在线',
              location: 'A区-货架1-顶层',
              lastActive: '2分钟前',
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              icon: Icons.camera_alt_outlined,
              name: '摄像头 2',
              type: '监控摄像头',
              status: '在线',
              location: 'A区-货架2-中层',
              lastActive: '5分钟前',
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              icon: Icons.mic_outlined,
              name: '麦克风 1',
              type: '拾音器',
              status: '在线',
              location: 'B区-通道口',
              lastActive: '1分钟前',
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              icon: Icons.speaker_outlined,
              name: '扬声器 1',
              type: '广播喇叭',
              status: '在线',
              location: 'C区-主通道',
              lastActive: '10分钟前',
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              icon: Icons.devices_other_outlined,
              name: '传感器 7',
              type: '温湿度传感器',
              status: '告警',
              location: 'D区-冷藏库',
              lastActive: '30秒前',
              color: AppTheme.warningColor,
              warning: '温度异常: 8°C',
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              icon: Icons.devices_other_outlined,
              name: '传感器 8',
              type: '烟雾传感器',
              status: '离线',
              location: 'E区-仓库角落',
              lastActive: '2小时前',
              color: AppTheme.errorColor,
            ),
          ],
        ),
      ],
    );
  }

  // 设备分类标签
  Widget _buildDeviceTabs(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabItem(context, title: '全部', isActive: true),
          _buildTabItem(context, title: '摄像头', isActive: false),
          _buildTabItem(context, title: '麦克风', isActive: false),
          _buildTabItem(context, title: '扬声器', isActive: false),
          _buildTabItem(context, title: '传感器', isActive: false),
          _buildTabItem(context, title: '告警设备', isActive: false),
        ],
      ),
    );
  }

  // 标签项
  Widget _buildTabItem(
    BuildContext context, {
    required String title,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: AppTheme.borderColor),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  // 设备卡片
  Widget _buildDeviceCard(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String type,
    required String status,
    required String location,
    required String lastActive,
    required Color color,
    String? warning,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
            ),
            const SizedBox(height: 16),

            // 设备信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            lastActive,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_outlined),
                  onPressed: () {
                    // 跳转到设备详情页面
                  },
                ),
              ],
            ),

            // 告警信息
            if (warning != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 20,
                        color: AppTheme.warningColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          warning,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
