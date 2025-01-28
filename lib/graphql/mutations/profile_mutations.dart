const String updateProfileMutation = r'''
  mutation UpdateProfile($id: ID!, $profileInput: ProfileInput!) {
    updateProfile(id: $id, profileInput: $profileInput) {
      message
      status
    }
  }
''';