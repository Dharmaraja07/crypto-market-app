import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/api_constants.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/network/api_client.dart';

class SettingsPage extends StatefulWidget {
  final ApiClient apiClient;

  const SettingsPage({super.key, required this.apiClient});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _urlController;
  bool _isTesting = false;
  bool? _isConnected;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.apiClient.currentBaseUrl);
    _checkConnection();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Connecting to backend...';
    });

    try {
      final res = await widget.apiClient.get(ApiConstants.marketOverview);
      if (mounted) {
        setState(() {
          _isTesting = false;
          _isConnected = res != null;
          _statusMessage = 'Backend connected successfully (HTTP 200 OK)';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTesting = false;
          _isConnected = false;
          _statusMessage = 'Connection failed: ${e.toString().replaceAll('ServerException: ', '')}';
        });
      }
    }
  }

  void _saveUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      widget.apiClient.updateBaseUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backend URL updated'),
          backgroundColor: AppColors.surface,
        ),
      );
      _checkConnection();
    }
  }

  void _applyUrl(String url) {
    _urlController.text = url;
    _saveUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Backend Connection Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.dns_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Spring Boot Backend Server',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Base REST API URL:',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _urlController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save_rounded, color: AppColors.primary),
                      onPressed: _saveUrl,
                      tooltip: 'Save URL',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.cloud_done_rounded, size: 16, color: AppColors.gain),
                      label: const Text('Render Cloud (Live)'),
                      tooltip: 'Production Render Cloud API',
                      onPressed: () => _applyUrl(ApiConstants.liveCloudUrl),
                      backgroundColor: AppColors.surface,
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gain),
                    ),
                    ActionChip(
                      label: const Text('USB (localhost:8080)'),
                      tooltip: 'Requires adb reverse tcp:8080 tcp:8080',
                      onPressed: () => _applyUrl('http://localhost:8080/api/v1'),
                      backgroundColor: AppColors.surface,
                      labelStyle: const TextStyle(fontSize: 11, color: AppColors.primary),
                    ),
                    ActionChip(
                      label: const Text('Wi-Fi (10.80.130.211)'),
                      tooltip: 'Computer Local Wi-Fi IP',
                      onPressed: () => _applyUrl('http://10.80.130.211:8080/api/v1'),
                      backgroundColor: AppColors.surface,
                      labelStyle: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                    ActionChip(
                      label: const Text('Emulator (10.0.2.2)'),
                      tooltip: 'Standard Android Emulator',
                      onPressed: () => _applyUrl('http://10.0.2.2:8080/api/v1'),
                      backgroundColor: AppColors.surface,
                      labelStyle: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Connection status card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      if (_isTesting)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        )
                      else
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isConnected == true
                                ? AppColors.gain
                                : (_isConnected == false ? AppColors.loss : AppColors.textMuted),
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _statusMessage ?? 'Checking connection...',
                          style: TextStyle(
                            color: _isConnected == true
                                ? AppColors.gain
                                : (_isConnected == false ? AppColors.loss : AppColors.textSecondary),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _isTesting ? null : _checkConnection,
                        child: const Text('Test', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Architecture',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _infoTile('Frontend', 'Flutter 3.35 + BLoC + Dio + Clean Architecture'),
                const Divider(color: AppColors.divider, height: 16),
                _infoTile('Backend', 'Java 17 + Spring Boot 3.3.4 + Spring Data JPA'),
                const Divider(color: AppColors.divider, height: 16),
                _infoTile('Caching', 'Caffeine Cache Layer (120s TTL)'),
                const Divider(color: AppColors.divider, height: 16),
                _infoTile('Data Provider', 'CoinGecko API v3 with Mock Fallback'),
                const Divider(color: AppColors.divider, height: 16),
                _infoTile('Database', 'PostgreSQL 16 & H2 In-Memory'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
