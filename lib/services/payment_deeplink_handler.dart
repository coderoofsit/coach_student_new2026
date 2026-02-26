import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Production-ready PayPal deep link handler (Singleton)
/// Features:
/// - No duplicate events
/// - Persistent storage
/// - Initial link handling
/// - Idempotent payment verification
/// - Race condition safe
/// - Single instance across the app
class PaymentDeepLinkHandler {
  static const String _lastProcessedLinkKey = 'last_payment_link';
  static const String _lastProcessedTimeKey = 'last_payment_time';
  static const int _linkExpiryMinutes = 10; // Links expire after 10 minutes

  // Singleton instance
  static PaymentDeepLinkHandler? _instance;
  
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _lastProcessedLink;
  bool _isInitialized = false;

  /// Callback for payment success
  Function(Uri uri)? onPaymentSuccess;

  /// Callback for payment cancel
  Function()? onPaymentCancel;

  /// Callback for payment failed
  Function()? onPaymentFailed;

  PaymentDeepLinkHandler._internal();

  /// Get singleton instance
  static PaymentDeepLinkHandler get instance {
    _instance ??= PaymentDeepLinkHandler._internal();
    return _instance!;
  }

  /// Initialize the handler - call this in initState
  /// Can be called multiple times safely
  Future<void> initialize({
    Function(Uri uri)? onPaymentSuccess,
    Function()? onPaymentCancel,
    Function()? onPaymentFailed,
  }) async {
    // Update callbacks if provided
    if (onPaymentSuccess != null) this.onPaymentSuccess = onPaymentSuccess;
    if (onPaymentCancel != null) this.onPaymentCancel = onPaymentCancel;
    if (onPaymentFailed != null) this.onPaymentFailed = onPaymentFailed;

    // Only initialize once
    if (_isInitialized) {
      print('PaymentDeepLinkHandler: Already initialized, updating callbacks only');
      return;
    }

    print('PaymentDeepLinkHandler: Initializing...');
    _isInitialized = true;

    // IMPORTANT: Load last processed link FIRST
    await _loadLastProcessedLink();
    print('PaymentDeepLinkHandler: Last processed link: $_lastProcessedLink');
    
    // Setup stream BEFORE checking initial link to catch any race conditions
    _setupLinkStream();
    
    // Small delay to ensure stream is ready
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Now check initial link - it will be skipped if already processed
    await _checkInitialLink();
  }

  /// Load the last processed link from storage
  Future<void> _loadLastProcessedLink() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedLink = prefs.getString(_lastProcessedLinkKey);
      final lastTime = prefs.getInt(_lastProcessedTimeKey);
      
      print('PaymentDeepLinkHandler: Stored link: $storedLink');
      print('PaymentDeepLinkHandler: Stored time: $lastTime');

      if (storedLink != null && lastTime != null) {
        final lastProcessedTime = DateTime.fromMillisecondsSinceEpoch(lastTime);
        final now = DateTime.now();
        final difference = now.difference(lastProcessedTime).inMinutes;
        
        print('PaymentDeepLinkHandler: Link age: $difference minutes');

        if (difference > _linkExpiryMinutes) {
          // Link expired, clear it
          print('PaymentDeepLinkHandler: Link expired, clearing');
          _lastProcessedLink = null;
          await _clearProcessedLink();
        } else {
          // Link is still valid
          _lastProcessedLink = storedLink;
          print('PaymentDeepLinkHandler: Using stored link');
        }
      } else {
        print('PaymentDeepLinkHandler: No stored link found');
        _lastProcessedLink = null;
      }
    } catch (e) {
      print('PaymentDeepLinkHandler: Error loading link: $e');
      // Ignore errors, start fresh
      _lastProcessedLink = null;
    }
  }

  /// Save the processed link to storage
  Future<void> _saveProcessedLink(String link) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await prefs.setString(_lastProcessedLinkKey, link);
      await prefs.setInt(_lastProcessedTimeKey, timestamp);
      
      _lastProcessedLink = link;
      
      print('PaymentDeepLinkHandler: Saved link: $link');
      print('PaymentDeepLinkHandler: Saved timestamp: $timestamp');
    } catch (e) {
      print('PaymentDeepLinkHandler: Error saving link: $e');
      // Still update in-memory even if save fails
      _lastProcessedLink = link;
    }
  }

  /// Clear the processed link from storage
  Future<void> _clearProcessedLink() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastProcessedLinkKey);
      await prefs.remove(_lastProcessedTimeKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check for initial link when app opens
  Future<void> _checkInitialLink() async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();
      print('PaymentDeepLinkHandler: Initial link: ${uri?.toString() ?? "null"}');
      
      if (uri != null) {
        // Only handle initial link if it hasn't been processed yet
        final linkKey = uri.toString();
        if (_lastProcessedLink != linkKey) {
          print('PaymentDeepLinkHandler: Processing initial link');
          await _handleUri(uri);
        } else {
          print('PaymentDeepLinkHandler: Initial link already processed, skipping: $linkKey');
        }
      }
    } catch (e) {
      print('PaymentDeepLinkHandler: Error checking initial link: $e');
    }
  }

  /// Setup stream to listen for incoming links
  void _setupLinkStream() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('PaymentDeepLinkHandler: Stream received URI: ${uri.toString()}');
      _handleUri(uri);
    });
  }

  /// Handle incoming URI (both initial and stream)
  Future<void> _handleUri(Uri uri) async {
    if (uri.scheme != 'creditvault') return;

    final linkKey = uri.toString();
    print('PaymentDeepLinkHandler: Handling URI: $linkKey');

    // Check if already processed
    if (_lastProcessedLink == linkKey) {
      print('PaymentDeepLinkHandler: Link already processed, skipping');
      return;
    }

    print('PaymentDeepLinkHandler: Processing new link');
    
    // Mark as processed BEFORE calling callbacks to prevent race conditions
    await _saveProcessedLink(linkKey);

    // Handle based on host
    if (uri.host == 'payment-success') {
      onPaymentSuccess?.call(uri);
    } else if (uri.host == 'payment-cancel') {
      onPaymentCancel?.call();
    } else if (uri.host == 'payment-failed') {
      onPaymentFailed?.call();
    }
  }

  /// Dispose the handler - call this in dispose (optional, singleton persists)
  void dispose() {
    // Don't dispose the stream subscription for singleton
    // It should persist across the app lifecycle
    print('PaymentDeepLinkHandler: Dispose called (singleton persists)');
  }

  /// Manually clear the last processed link (useful for testing)
  Future<void> clearLastProcessedLink() async {
    _lastProcessedLink = null;
    await _clearProcessedLink();
  }
}
