import 'package:flutter/material.dart';

class SettingsDialogs {
  // ---------------- EDIT PROFILE ----------------
  static void showEditProfileDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final nameController = TextEditingController(text: "Student");
    final emailController = TextEditingController(text: "email@university.edu");

    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  setState(() => isLoading = true);
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );

                                  if (!context.mounted) return;

                                  setState(() => isLoading = false);
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Profile updated"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Save Changes"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- CHANGE PASSWORD ----------------
  static void showChangePasswordDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final current = TextEditingController();
    final newPass = TextEditingController();
    final confirm = TextEditingController();

    final formKey = GlobalKey<FormState>();

    bool isLoading = false;
    bool obscure1 = true;
    bool obscure2 = true;
    bool obscure3 = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: current,
                        obscureText: obscure1,
                        decoration: InputDecoration(
                          labelText: "Current Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => obscure1 = !obscure1),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: newPass,
                        obscureText: obscure2,
                        decoration: const InputDecoration(
                          labelText: "New Password",
                        ),
                        validator: (v) =>
                            v != null && v.length < 6 ? "Too short" : null,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: confirm,
                        obscureText: obscure3,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                        ),
                        validator: (v) =>
                            v != newPass.text ? "Not matching" : null,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  setState(() => isLoading = true);
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );

                                  if (!context.mounted) return;

                                  setState(() => isLoading = false);
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Password changed"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Save Password"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
