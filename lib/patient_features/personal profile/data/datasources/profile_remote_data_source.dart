import 'dart:convert';
import 'dart:developer';
import 'package:health_care_app/core/api/api_client.dart';

import '../../../../core/api/endpoints.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;
  final String authToken; //! will be fetched from shared pref later

  ProfileRemoteDataSource(this.apiClient, this.authToken);

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getPatientById,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        log(name: 'RESPONSE BODY', "the response body: $response");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  // Future<void> updateUserData(Map<String, dynamic> data) async {
  //   try {
  //     final response = await apiClient.put(
  //       Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiClient}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // Add your authorization header here if needed
  //         // 'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(data),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to update user data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to update user data: $e');
  //   }
  // }

//   Future<void> deleteAccount() async {
//     try {
//       final response = await apiClient.delete(
//         Uri.parse('${ApiConstants.baseUrl}${ApiConstants.deleteAccount}'),
//         headers: {
//           'Content-Type': 'application/json',
//           // Add your authorization header here if needed
//           // 'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete account: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to delete account: $e');
//     }
//   }
}
