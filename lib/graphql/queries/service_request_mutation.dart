const String createServiceRequestMutation = '''
  mutation CreateServiceRequest(\$input: ServiceRequestInput!) {
    createServiceRequest(input: \$input) {
      id
      title
      description
      requestDate
      scheduledDate
      completionDate
      status
      client {
        id
        email
        phone
        role
        verified
      }
      invoice {
        id
        totalAmount
        issuedAt
        dueDate
        status
        serviceRequest {
          description
        }
      }
    }
  }
''';
