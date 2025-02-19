const String getAllServiceRequestsQuery = r'''
    query GetAllServiceRequests {
      getAllServiceRequests {
        id
        title
        description
        requestDate
        scheduledDate
        completionDate
        status
        technician {
          email
          phone
        }
        client {
          email
          phone
        }
        invoice {
          status
          totalAmount
        }
      }
    }
  ''';
  
