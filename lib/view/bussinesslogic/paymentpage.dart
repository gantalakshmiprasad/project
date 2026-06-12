import 'package:firstproject/paymentgateway/cashfreepgctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Paymentpage extends StatelessWidget {
  const Paymentpage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CashfreeController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B1517),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F262A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () => Get.offAllNamed('/homepage'),
        ),
        title: const Text(
          'Pricing Plans',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isloading.value) {
          return Center(child: Lottie.asset('assets/animations/loading.json'));
        }

        if (controller.subscriptionstatus.value) {
          String rawDate = controller.plandetails["next_schedule_date"] ?? '';
          String formattedDate = "N/A";

          if (rawDate.isNotEmpty) {
            try {
              DateTime parsedDate = DateTime.parse(rawDate);
              formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = rawDate.split('T')[0];
            }
          }

          final planInfo = controller.plandetails['plan_details'] ?? {};

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0B1517),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: 460,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F262A),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF2DD4BF),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(
                          0x262DD4BF,
                        ), // BUG FIX: Added functional alpha opacities so glow vectors translate cleanly
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x1A2DD4BF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF2DD4BF)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: Color(0xFF2DD4BF),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "ACTIVE PREMIUM PASS",
                              style: TextStyle(
                                color: Color(
                                  0xFF2DD4BF,
                                ), // BUG FIX: Swapped out nested matching layer tones
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        (planInfo["plan_name"] ?? 'UNKNOWN PLAN')
                            .toString()
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          Text(
                            (planInfo['plan_recurring_amount'] ?? '0')
                                .toString(),
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          const Text(
                            '/-',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Next Bill Date',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () {
                          final subId =
                              controller.plandetails['subscription_id'] ??
                              controller.subscriptionid;
                          _showCancelBottomSheet(context, controller, subId);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Color(0xFFFB7185),
                          size: 18,
                        ),
                        label: const Text(
                          'Cancel active subscription',
                          style: TextStyle(
                            color: Color(0xFFFB7185),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF0B1517),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 850;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Choose Your Workspace Plan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Unlock exclusive administrative modules instantly",
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildPricingCard(
                          title: 'Monthly Subscription',
                          price: '499',
                          isMobile: isMobile,
                          isPopular: false,
                          onPressed: () => controller.initiatePayment('499'),
                        ),
                        _buildPricingCard(
                          title: 'Yearly Subscription',
                          price: '5500',
                          isMobile: isMobile,
                          isPopular: true,
                          onPressed: () => controller.initiatePayment('5500'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required bool isMobile,
    required bool isPopular,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: isMobile ? double.infinity : 360,
      decoration: BoxDecoration(
        color: const Color(0xFF0F262A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular ? const Color(0xFFF59E0B) : const Color(0xFF1E4D55),
          width: isPopular ? 2 : 1.2,
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isPopular)
            Positioned(
              top: -46,
              right: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "BEST VALUE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),
              _buildFeatureRow('Food courts management module'),
              _buildFeatureRow('Restaurants direct order system'),
              _buildFeatureRow('Bakery shop operations portfolio'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₹$price',
                        style: TextStyle(
                          fontSize: 28,
                          color: isPopular
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF2DD4BF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        '/-',
                        style: TextStyle(
                          color: Colors.white30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF2DD4BF),
                    foregroundColor: isPopular
                        ? Colors.black
                        : const Color(0xFF0B1517),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onPressed,
                  child: const Text(
                    'Subscribe Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF2DD4BF),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelBottomSheet(
    BuildContext context,
    CashfreeController controller,
    String subId,
  ) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F262A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Cancel Subscription?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to stop auto-renewals?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Keep",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB7185),
                    ),
                    onPressed: () {
                      Get.back();
                      controller.cancelsubscription(subId);
                    },
                    child: const Text(
                      "Yes, Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
