import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription_plan.dart';
import 'local_storage_provider.dart';

class SubscriptionNotifier extends StateNotifier<UserSubscription> {
  final Ref _ref;

  SubscriptionNotifier(this._ref) : super(const UserSubscription()) {
    _loadSubscription();
  }

  void _loadSubscription() {
    final storage = _ref.read(localStorageProvider);
    state = storage.getSubscription();
  }

  // Subscribe to a plan (Monthly / Yearly)
  Future<bool> purchaseSubscription(SubscriptionPlan plan) async {
    final storage = _ref.read(localStorageProvider);

    // Calculate expiry date: 1 month or 1 year from now
    final now = DateTime.now();
    final expiry = plan.tier == SubscriptionTier.proMonthly
        ? now.add(const Duration(days: 30))
        : now.add(const Duration(days: 365));

    final updated = UserSubscription(
      tier: plan.tier,
      expiresAt: expiry,
      isAutoRenewing: true,
      isTrialActive: plan.trialDays > 0,
    );

    await storage.saveSubscription(updated);
    state = updated;
    return true;
  }

  // Restore Purchases
  Future<bool> restorePurchases() async {
    final storage = _ref.read(localStorageProvider);
    final saved = storage.getSubscription();
    state = saved;
    return saved.isPro;
  }

  // Cancel / Reset subscription (for testing or profile management)
  Future<void> cancelSubscription() async {
    final storage = _ref.read(localStorageProvider);
    final reset = const UserSubscription(tier: SubscriptionTier.free);
    await storage.saveSubscription(reset);
    state = reset;
  }

  // Check if a feature is unlocked for current user
  bool canAccessFeature({required bool isPremiumOnly}) {
    if (!isPremiumOnly) return true;
    return state.isPro;
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, UserSubscription>((ref) {
  return SubscriptionNotifier(ref);
});

final subscriptionPlansProvider = Provider<List<SubscriptionPlan>>((ref) {
  return SubscriptionPlan.defaultPlans();
});
