import 'package:coach_student/core/extension.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/view/coach/paypal_connect/controller/paypal_connect_provider.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/custom_app_bar_student.dart';

class PayPalConnectScreen extends ConsumerStatefulWidget {
  const PayPalConnectScreen({super.key});

  @override
  _PayPalConnectScreenConsumerState createState() =>
      _PayPalConnectScreenConsumerState();
}

class _PayPalConnectScreenConsumerState
    extends ConsumerState<PayPalConnectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch existing payment info when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paypalConnectProvider).fetchPaymentInfo(context).then((_) {
        final paymentInfo = ref.read(paypalConnectProvider).paymentInfo;
        if (paymentInfo != null) {
          _nameController.text = paymentInfo['name'] ?? '';
          _phoneController.text = paymentInfo['phone'] ?? '';
          _paypalEmailController.text = paymentInfo['paypalEmail'] ?? '';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Connect PayPal",
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if(value.length < 10){
                    return 'Phone number must have 10 number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _paypalEmailController,
                decoration: const InputDecoration(
                  labelText: "PayPal email",
                  border: OutlineInputBorder(),
                ),
                validator: (input) => input!.isValidEmail()
                    ? null
                    : "Please enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              if (ref.watch(paypalConnectProvider).isLoading)
                Utils.progressIndicator
              else
                CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(paypalConnectProvider)
                          .paypalConnectPost(context, info: {
                        "name": _nameController.text,
                        "phone": _phoneController.text,
                        "paypalEmail": _paypalEmailController.text,
                      });
                    }
                  },
                  text: ref.watch(paypalConnectProvider).paymentInfo != null
                      ? 'Update PayPal'
                      : 'Connect PayPal',
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _paypalEmailController.dispose();
    super.dispose();
  }
}
