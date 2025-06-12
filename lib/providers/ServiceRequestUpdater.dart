// lib/providers/ServiceRequestUpdater.dart
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/service_request_mutation.dart';
import 'package:firetrack360/models/service_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final serviceRequestUpdaterProvider =
    AsyncNotifierProvider<ServiceRequestUpdater, ServiceRequest?>(
        ServiceRequestUpdater.new);

class ServiceRequestUpdater extends AsyncNotifier<ServiceRequest?> {
  late final GraphQLClient _client;

  @override
  Future<ServiceRequest?> build() async {
    _client = GraphQLConfiguration.initializeClient().value;
    state = const AsyncData(null);
    return null;
  }

  // Helper for error handling
  String _handleGraphQLError(OperationException? exception) {
    if (exception == null) return 'Unknown error occurred';

    if (exception.linkException != null) {
      final linkException = exception.linkException!;
      if (linkException is NetworkException) {
        return 'Network error occurred. Please check your connection.';
      } else if (linkException is ServerException) {
        return 'Server error occurred. Please try again later.';
      }
      return 'Connection error occurred: ${linkException.toString()}';
    }

    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((e) => e.message).join(', ');
    }

    return 'An error occurred while processing your request';
  }

  /// Completes a service request.
  /// Returns the completed ServiceRequest object on success.
  Future<ServiceRequest> completeService(String requestId) async {
    state = const AsyncLoading(); // Set loading state

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(completeServiceMutation),
          variables: {
            'requestId': requestId,
          },
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null && result.data!['completeService'] != null) {
        final completedRequestData = result.data!['completeService'];
        final completedServiceRequest = ServiceRequest.fromJson(
            Map<String, dynamic>.from(completedRequestData));

        state = AsyncData(
            completedServiceRequest); // Set success state with the updated request
        return completedServiceRequest; // Return the updated request
      } else {
        throw Exception('Failed to complete service: No data returned.');
      }
    } catch (e, stack) {
      state = AsyncError(e, stack); // Set error state
      rethrow; // Re-throw to be handled by the UI
    }
  }

  // If you also want to include update status in this independent provider:
  Future<ServiceRequest> updateServiceRequestStatus(
      String requestId, String newStatus) async {
    state = const AsyncLoading();
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(completeServiceMutation),
          variables: {
            'id': requestId,
            'status': newStatus,
          },
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null &&
          result.data!['updateServiceRequestStatus'] != null) {
        final updatedRequestData = result.data!['updateServiceRequestStatus'];
        final updatedServiceRequest = ServiceRequest.fromJson(
            Map<String, dynamic>.from(updatedRequestData));

        state = AsyncData(updatedServiceRequest);
        return updatedServiceRequest;
      } else {
        throw Exception(
            'Failed to update service request status: No data returned.');
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
