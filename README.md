# Fetch: Tinder for Dogs

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview	
### Description
Users create a profile for their dog in order to match with like-minded dogs for play dates and meet ups. Matches are based on swipes of other profiles.


### App Evaluation
[Evaluation of your app across the following attributes]

- **Category:** Social Networking 
- **Mobile:** This app would be primarily developed for mobile use.
- **Story:** Analyzes users' swipes and connects them to other users who have also swiped in favor of them (user’s dog). The user can then decide to message this person to schedule a playdate or build a connection with them based on their dog's profile.
- **Market:** Any individual 18+ with a dog will be able to sign up for this app since it will be at the user’s discretion to decide who they want to contact and meet.
- **Habit:** This app could be used whenever a play date is needed for a hyper pup or just simply to connect with other users to swap stories or to get advice about their dogs.
- **Scope:** This app will connect users with others to have opportunities for play dates for their dogs. This can potentially expand on a wider range of connecting individuals to local dog meet ups, local groomers, day care or boarding services.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can create a new account
  * [x] Location (approximate)
  * [ ] Dog’s playing preferences & temperament (hardcoded list of preferences)
  * [x] Dog’s name
  * [x] Dog’s breed
* [x] User can login and logout
* [x] User can see their own profile
* [ ] User can see other users
  * [ ] User can swipe right or left
* [ ] User can chat with other users upon mutual matching (swiping left on each other)


**Optional Nice-to-have Stories**

* [ ] Users can see other users based on a location range
* [ ] Hardcoded questions to rank which profiles to show first

### 2. Screen Archetypes

* [ ] View Fetch Profiles (Dogs)
   * [ ] Show the user’s dog pictures and name
   * [ ] Click on an information icon to expand the profile and see all details

* Chat
   * [x] List of chats
   * [x] Upon tapping into a chat, show message history and can chat with the other user

* Log in
   * [x] Email, password

* Profile
   * [ ] Edit profile (name, 6 dog pictures, select one of the 6 as the first picture, description, fields (playing preferences etc.)
   * [ ] Location - ?


### 3. Navigation
**Tab Navigation** (Tab to Screen)

* [x] View Fetch Profiles (the swiping screen—a.k.a “Home”)
* [x] Chats
* [x] Profile

**Flow Navigation** (Screen to Screen)

* [x] Login Screen
 * => Home (after successful login)
 * => OR go to Registration Screen

* [x] Registration Screen
 * => [x] Home (after successful signup)
 * => [x] OR return to Login Screen

* [ ] View Fetch Profiles (Homepage: the swiping screen)
=> Successful Match Screen: If it’s a match, show this screen to encourage chatting, or allow going back to Home (View Fetch Profiles)


* [x] Chats (Homepage: The list of chats with matches)
 * => Individual chat & chat history (from List of Chats screen OR from Successful Match Screen)
 * => View Profile of Other User by tapping on their profile picture

* [x] Profile (Homepage: Your profile information)
 * => [x] Edit Profile
 * => [ ] Logout (go to login page after AlertController confirmation)


## Wireframes
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>
![Image](https://github.com/chelseajoe/Fetch/blob/main/Fetch_Lofi_Sketches.png)


### [BONUS] Interactive Prototype - ???

## Schema
### Models
1. User (Dog)
```
struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    // Custom Properties for Fetch
    // -- Dog traits --
    var name: String?
    var breed: String?
    var age: Int?
    var bio: String?
    var preferences: [String]?
    var images: [ParseFile]?
    
    // User metadata
    var location: ParseGeoPoint?
    var recentlyActive: Bool?
    
    // Cross-user data
    // Strings represent usernames
    var dislikedUsers: [String]?
    var likedUsers: [String]?
    var matchedUsers: [String]?
}
```



2. ChatRoom + ChatMessage
```
struct ChatRoom: ParseObject {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Chat room properties
    var messages: [ChatMessage]?
    var users: [String]?
    var lastUpdated: Date?
}

struct ChatMessage: ParseObject {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Chat message properties
    var user: String?
    var message: String?
}
```

### Networking
- [Add list of network requests by screen ]
- [POST] Login, [GET] Logout, [POST] Register
- [GET] Get all profiles, [POST] Record swipe left/right
- [GET] Get list of chats, [GET] Message History, [POST] Send message, [DELETE] Delete chat
- [GET] Get Individual Profile, [PUT] Update Profile

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

### Updates:
- Chelsea Joe - Created branch for profile, and added text from Parse backend 
- Chelsea Joe - Updated editing photos functionality to upload images
- Melissa Saechao - Finished Login & Signup features
- Anh Vu - Finished Chat features
- Anh Vu - Merged all current branches into main
