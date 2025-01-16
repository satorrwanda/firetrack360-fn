const String getProfileQuery = r'''
  query GetProfileByUserId($userId: ID!) {
    getProfileByUserId(userId: $userId) {
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
        id
        email
        phone
        role
        verified
      }
    }
  }
''';