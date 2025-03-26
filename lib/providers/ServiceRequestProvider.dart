import 'package:firetrack360/graphql/queries/service_request_mutation.dart';
import 'package:firetrack360/models/service_request.dart';
import 'package:firetrack360/models/technician.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/service_request_query.dart';

// Basic providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final statusFilterProvider = StateProvider<String?>((ref) => null);
final technicianFilterProvider = StateProvider<String?>((ref) => null);
final clientFilterProvider = StateProvider<String?>((ref) => null);

// Main ServiceRequest NotifierProvider
final serviceRequestNotifierProvider = StateNotifierProvider<
    ServiceRequestNotifier, AsyncValue<List<ServiceRequest>>>((ref) {
  return ServiceRequestNotifier();
});

// Filtered ServiceRequests Provider
final filteredServiceRequestsProvider =
    Provider<AsyncValue<List<ServiceRequest>>>((ref) {
  final requestsAsyncValue = ref.watch(serviceRequestNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final statusFilter = ref.watch(statusFilterProvider);
  final technicianFilter = ref.watch(technicianFilterProvider);
  final clientFilter = ref.watch(clientFilterProvider);

  return requestsAsyncValue.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (requests) {
      var filtered = requests;

      // Apply search query filter
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((request) {
          return request.title.toLowerCase().contains(searchQuery) ||
              request.description.toLowerCase().contains(searchQuery) ||
              request.status.toLowerCase().contains(searchQuery);
        }).toList();
      }

      // Apply status filter
      if (statusFilter != null) {
        filtered = filtered
            .where((request) => request.status == statusFilter)
            .toList();
      }

      // Apply technician filter
      if (technicianFilter != null) {
        filtered = filtered
            .where((request) => request.technician.email == technicianFilter)
            .toList();
      }

      // Apply client filter
      if (clientFilter != null) {
        filtered = filtered
            .where((request) => request.client?.email == clientFilter)
            .toList();
      }

      return AsyncValue.data(filtered);
    },
  );
});

// ServiceRequest Notifier Class
class ServiceRequestNotifier
    extends StateNotifier<AsyncValue<List<ServiceRequest>>> {
  final GraphQLClient _client;

  ServiceRequestNotifier()
      : _client = GraphQLConfiguration.initializeClient().value,
        super(const AsyncValue.loading()) {
    loadServiceRequests();
  }

  Future<void> loadServiceRequests() async {
    state = const AsyncValue.loading();
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(getAllServiceRequestsQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        try {
          // Log the raw data for debugging
          print('Raw GraphQL response: ${result.data}');

          final requests =
              result.data!['getAllServiceRequests'] as List<dynamic>;
          final List<ServiceRequest> parsedRequests = [];

          for (var requestData in requests) {
            if (requestData == null) continue;

            try {
              final requestMap = Map<String, dynamic>.from(requestData as Map);
              // Log individual request data
              print('Processing request: $requestMap');

              // Don't validate, just try to parse
              final request = ServiceRequest.fromJson(requestMap);
              parsedRequests.add(request);
            } catch (e, stack) {
              // Log parsing errors but continue processing other requests
              print('Error parsing request: $e\n$stack');
              continue;
            }
          }

          state = AsyncValue.data(parsedRequests);
        } catch (e, stack) {
          state = AsyncValue.error(e, stack);
        }
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void _validateServiceRequestData(Map<String, dynamic> request) {
    final requiredFields = [
      'id',
      'title',
      'description',
      'requestDate',
      'status',
      'technician',
      'client',
    ];

    for (final field in requiredFields) {
      if (!request.containsKey(field) || request[field] == null) {
        throw FormatException('Missing required service request field: $field');
      }
    }

    final technicianMap = request['technician'] as Map<String, dynamic>;
    final clientMap = request['client'] as Map<String, dynamic>;

    // Validate contact fields
    for (final contact in [technicianMap, clientMap]) {
      final requiredContactFields = ['email', 'phone'];
      for (final field in requiredContactFields) {
        if (!contact.containsKey(field) || contact[field] == null) {
          throw FormatException('Missing required contact field: $field');
        }
      }
    }

    // Only validate invoice if it exists
    if (request.containsKey('invoice') && request['invoice'] != null) {
      final invoiceMap = request['invoice'] as Map<String, dynamic>;
      final requiredInvoiceFields = ['status', 'totalAmount'];
      for (final field in requiredInvoiceFields) {
        if (!invoiceMap.containsKey(field) || invoiceMap[field] == null) {
          throw FormatException('Missing required invoice field: $field');
        }
      }
    }
  }

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

  // Helper method to get a single request by ID
  ServiceRequest? getServiceRequestById(String id) {
    return state.whenOrNull(
      data: (requests) => requests.firstWhere(
        (request) => request.id == id,
        orElse: () => ServiceRequest(
          id: '',
          title: '',
          description: '',
          requestDate: DateTime.now(),
          status: '',
          technician: Technician(
            email: '',
            phone: '',
            firstName: '',
            lastName: '',
            role: '',
          ),
          client: Technician(
            email: '',
            phone: '',
            firstName: '',
            lastName: '',
            role: '',
          ),
        ),
      ),
    );
  }

  Future<void> refreshServiceRequests() async {
    await loadServiceRequests();
  }

  // Add this to your ServiceRequestNotifier class
  Future<void> createServiceRequest({
    required String title,
    required String description,
    required String clientId,
    required String technicianId,
  }) async {
    try {
      state = const AsyncValue.loading();

      final result = await _client.mutate(
        MutationOptions(
          document: gql(createServiceRequestMutation),
          variables: {
            'input': {
              'title': title,
              'description': description,
              'clientId': clientId,
              'technicianId': technicianId,
            },
          },
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        // Refresh the list after successful creation
        await loadServiceRequests();
      } else {
        throw Exception('No data returned from mutation');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Additional provider for getting a single service request by ID
final serviceRequestByIdProvider =
    Provider.family<AsyncValue<ServiceRequest?>, String>(
  (ref, id) {
    final requestsAsyncValue = ref.watch(serviceRequestNotifierProvider);

    return requestsAsyncValue.when(
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
      data: (requests) {
        try {
          final request = requests.firstWhere((request) => request.id == id);
          return AsyncValue.data(request);
        } catch (e) {
          return const AsyncValue.data(null);
        }
      },
    );
  },
);

// Technician Provider
final technicianProvider = Provider<AsyncValue<Technician>>((ref) {
  return const AsyncValue.loading();
});

// Client Provider
final clientProvider = Provider<AsyncValue<Technician>>((ref) {
  return const AsyncValue.loading();
});
