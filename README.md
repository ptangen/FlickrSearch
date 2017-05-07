## Aetna Digital iOS Code Test
## Requirements

Develop an iOS application that allows a user to search Flickr. Create a user
interface that presents a user with a search bar and executes searches on
keyboard input. The user should be able to enter text into the search bar and see
a list of images whose tags match the search term. The search term can be a
single word or comma separated words.

When the user starts/changes text in the search bar, present the user with a
UITableView, UICollectionView or UIScrollView containing a list of images (show
the actual images). Fetch this list of images using the Flickr web service:
https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&nojsoncallback=1&tags=<SearchTerm>

You’re highly encouraged to create models for the data.

### Acceptance Criteria
- Make the call to the web service in a way that does not block the UI.
- The user interface must remain responsive to touch during the call and while the images are downloaded asynchronously into the list.
- Results will be displayed in a list that shows one row/cell per record with each row containing at least image, title, width and height.
- When a user clicks on an image, show a detail view containing metadata
about the image (the image URL, title, or whatever is available).

### Bonus Work (with no particular priority)
- Add some test coverage with unit tests and/or UI tests.
- Improve the user experience by polishing the app with any small features you feel have been missed in the list above. Make note of the changes you make for the post exercise conversation.
- Add a feature that allows the user to click a button to fill in the input field with their current location (e.g. “Denver, CO”).
- Add a feature allowing the user to email an image and associated metadata from the detail screen. The image should be an attachment to the email.
- Add a saved search feature that lets users quickly search for items they have previously searched for.

 ### Notes
- Don’t worry about data entry validation on the search. Implement what’s easiest for you.
- Use best practices when designing your layout
- This Flickr API doesn’t handle single quotes in the JSON response well for our purposes. You may need to replace “\’” (backslash single quote) with just “‘“ (single quote).
- You may use third party libraries if you’d like, Cocoapods or carthage is acceptable. You won’t be penalized if you use them and don’t feel like you must use them. Here are some libraries we’ve seen success with:
    - SDWebImage
    - AlamoFire (AFNetworking)
    - JSONModel
- Remember, if you run into any problems at all please ask for help! The point of this exercise isn’t to spin your wheels - we’d like to have a solid body of work to talk about when the exercise is over.
