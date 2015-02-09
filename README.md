## Rotten Tomatoes

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 7 hrs

### Features

#### Required

- [X] User can view a list of movies. Poster images load asynchronously.
	* Low quality thumbnail images are loaded first, asynchronously.  After the low quality ones have completed, we start fetching he higher quality ones because the thumbnails still appear a little bit blurry in the table view cells.
- [X] User can view movie details by tapping on a cell.
	* Standard navigation controller interactions on select.
- [X] User sees loading state while waiting for the API.
	* I wanted to use something completely free from any ui popups or anything that felt too jarring, so I added the progress bar at the top in the navigation bar.
- [X] User sees error message when there is a network error: [Internet Unavailable](https://i.imgur.com/aYMOSZB.png)
	* Network disconnected view appears if the requests fail due to an internet error, or if AFNetworkReachabilityManager detects a change in status.
- [X] User can pull to refresh the movie list.
	* Standard UIRefreshControl hooked up to the table view.

#### Optional

- [X] Add a tab bar for Box Office and DVD.
	* Since the movies and dvd tabs were so similar, I'm just changing the global data input from movies to dvds, and back and forth.
- [X] Add a search bar.
	* Setup a search bar for the tableview that is specific to either the movies or the dvds tab.
- [X] All images fade in.
	* Fades the low quality images in, but when the higher quality ones load immediately pops it in.
- [X] For the larger poster, load the low-res first and switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
	* To have a unified color tint throughout the app, I wanted to make the cell selection color the same as the global tint.
- [X] Customize the navigation and tab bar.
	* Again, unifying the overall theme of the app the navigation and tab bar the colors of everything are the same as the global tint.
- [X] Polish entire application
	* There was a lot of work put in to make all of the small things much more polished.  From the color of the cursor in the searh bar, and the color of the UIRefreshControl, I really wanted to make sure there was a proper use of color throughout the app.  Additionally things like adding a dark background behind the tableview, changing the launchscreen to dark, and property handle all of the complicated interactions between the search bar, scrolling, and clicking the tab bar for expected behaviors.

### Walkthrough
![Video Walkthrough](https://i.imgur.com/UEykswf.gif)

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [M13ProgressSuite](https://github.com/Marxon13/M13ProgressSuite)
* [Essence Icos](http://iconsandcoffee.com/essence/)
