import 'package:flutter/material.dart';
import 'package:iptv_player/common/constants/language_constants.dart';

class LicenseAgreementDialog extends StatefulWidget {
  final VoidCallback? onAccepted;

  const LicenseAgreementDialog({super.key, this.onAccepted});

  @override
  State<LicenseAgreementDialog> createState() => _LicenseAgreementDialogState();
}

class _LicenseAgreementDialogState extends State<LicenseAgreementDialog> {
  bool _isAccepted = true; // Default to checked as per requirements

  Future<void> _acceptLicense() async {
    if (_isAccepted) {
      await setLicenseAccepted();
      if (mounted) {
        Navigator.of(context).pop();
        widget.onAccepted?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3A5F), // Dark blue
            Color(0xFF0D1F3C), // Darker blue
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'License Agreement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'IPTV Smart Player\n\n'
                    'This application is designed to support M3U and JSON playlist formats. '
                    'It allows users to watch IPTV content through URLs provided by the users themselves.\n\n'
                    'Important Notice:\n\n'
                    '• This application does not provide, host, or distribute any IPTV content or streams.\n'
                    '• Users are solely responsible for the legality of the content they access through this application.\n'
                    '• We do not endorse or promote any copyright infringement or unauthorized access to content.\n'
                    '• Users must ensure they have the proper permissions and subscriptions for any content they access.\n\n'
                    'Copyright and Permissions:\n\n'
                    '• All content accessed through this application is the property of its respective copyright holders.\n'
                    '• This application does not claim any ownership over the content accessed through it.\n'
                    '• Users are responsible for obtaining all necessary licenses and permissions for the content they access.\n\n'
                    'No Affiliation:\n\n'
                    '• This application is not affiliated with, endorsed by, or connected to any IPTV service providers or content distributors.\n'
                    '• All trademarks and service marks are the property of their respective owners.\n\n'
                    'User Responsibility:\n\n'
                    '• By using this application, you acknowledge that you are solely responsible for:\n'
                    '  - Providing your own IPTV playlist URLs\n'
                    '  - Ensuring you have legal rights to access the content\n'
                    '  - Complying with all applicable laws and regulations in your jurisdiction\n'
                    '  - Any consequences resulting from your use of this application\n\n'
                    'This application is a media player tool only. It requires users to supply their own content sources.\n\n'
                    'By accepting this agreement, you confirm that you understand and agree to these terms.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Checkbox with text
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'I confirm licence agreement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isAccepted,
                      onChanged: (value) {
                        setState(() {
                          _isAccepted = value;
                        });
                      },
                      activeThumbColor: Color(0xFF00D9F5), // Cyan color
                      activeTrackColor: Color(0xFF00D9F5).withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Accept button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAccepted ? _acceptLicense : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAccepted
                        ? Color(0xFF00D9F5)
                        : Colors.grey.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
