import 'package:flutter/material.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/admin/leads.dart' deferred as leads;

// future

Future<void> get lazyLead => leads.loadLibrary();

class ApplicationAdminRouter {
  static var appAdminRouter = {
    AdminERoute.admin_leads.name: (context) => FutureBuilder(
        future: lazyLead,
        builder: (snapshot, context) {
          return leads.Leads();
        })
  };
}
