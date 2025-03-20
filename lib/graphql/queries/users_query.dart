const String getAllUsersQuery = '''
    query GetAllProfiles {
      getAllProfiles {
        id
        firstName
        lastName
        address
        city
        state
        zipCode
        profilePictureUrl
        bio
        dateOfBirth
        isActive
        createdAt
        updatedAt
        user {
          email
          phone
          role
          verified
        }
      }
    }
  ''';