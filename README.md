# Art Drop

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Make art history education and collection more accessible than ever before

### App Evaluation
- **Category:** Art / Shopping
- **Mobile:** Mobile only
- **Story:** Discover your new favorite artworks throughout history and uncover their stories.  Collect art from artists and galleries all around the world and sell pieces from your own collection.
- **Market:** Art collectors, enthusiast, artists, and art sellers
- **Habit:** Users can endlessly learn about artworks and keep up to date with art piecesthey may want to buy
- **Scope:** Users can explore artworks and artists for educational, collecting, or selling purposes. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can log in/log out of your app as a user
* User can sign up with a new user profile
* User can scroll through a home feed of artwork 
* User can like/save artworks to a personal collection 
* User can view a detailed page about each artwork
    * Page will contain text/video about the artwork
    * Page will contain a map view of where the artwork currently is
* User can "buy" an artwork
* User can search for artworks 
* User can upload their own artwork for sale 
* User has a profile page dislaying the artworks they are selling and their personal collection

**Optional Nice-to-have Stories**

* User can follow/unfollow other profiles, including artists and museums
* User can filter by artist, museum, and other tags when searching 
* User can share artworks 
* User can see a "highlight of the day", "trending", or "artworks around you" on the search/explore page 
* User can see guided audio tours on museum profile pages
* AR curation: User can use AR to place a piece of art onto a wall in their home

### 2. Screen Archetypes

* Login Screen
   * User can log in/log out of your app as a user
* Registration Screen
   * User can sign up with a new user profile
* Stream Screen
   * User can scroll through a home feed of artwork 
   * User can like/save artworks to a personal collection 
   * User can "buy" an artwork
   * User can view a detailed page about each artwork
       * Page will contain text/video about the artwork
       * Page will contain a map view of where the artwork currently is
* Creation
    * User can upload their own artwork for sale 
* Search
    * User can search for artworks 
* Profile
    * User has a profile page dislaying the artworks they are selling and their personal collection

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Feed
* Explore/Search Page
* Upload Artwork to Sell
* Profile

**Flow Navigation** (Screen to Screen)

* Login ->
    * Sign up 
* Home Feed -> 
   * Artwork Detail Screen -> image, description, media, map view, buy, Profile that posted
* Explore/Search ->
   * Artwork Detail Screen
   * Profile Screens
* Upload Artwork to Sell -> upload images, 
* Profile -> 
    * Artworks They are Selling Screen
    * Personal Collection Screen

## Wireframes
![thumbnail_IMG_0221](https://user-images.githubusercontent.com/54779649/124806702-d8d1d380-df11-11eb-9e8c-53ea4d90c1a8.jpeg)
![thumbnail_IMG_0220](https://user-images.githubusercontent.com/54779649/124806713-db342d80-df11-11eb-9117-241d64cf5ee7.jpeg)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models

#### Post
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | image         | File     | image that user posts |
   | title         | String   | title of the art piece |
   | description   | String   | title of the art piece |
   | commentsCount | Number   | number of comments that has been posted to an image |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | location      | String   | location where artwork currently is |
   | medium        | String   | date when post is created (default field) |
   | year          | DateTime | year the author created this artpiece |
   | size          | String   | dimensions of the artwork |   
   | price         | Number   | price of the artwork (optional) |   
   
#### Profile
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | authorName    | String   | name of artist, buyer, or institution |
   | username      | String   | username |
   | password      | String   | password of the account|
   | profilePhoto  | Number   | profile photo |
   | nationality   | Number   | nationality |
   | birthYear     | DateTime | year artist was born|
   | bio           | String   | artist's bio |
   | works         | NSArray  | array of posts the author has listed |
   | updatedAt     | DateTime | date when post is last updated (default field) |


### Networking
  - Home Feed Screen
      - (Read/GET) Query all posts 
         ```swift
         let query = PFQuery(className:"Post")
         query.whereKey("author", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
  - Explore Screen
      - (Read/GET) Query all matching posts based on user's input in search
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Read/GET) Query all posts that user has posted
      - (Update/PUT) Update user bio
      - (Update/PUT) Update user profile image

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

   - Artsy API: https://developers.artsy.net/v2
   - The MET API: https://metmuseum.github.io
