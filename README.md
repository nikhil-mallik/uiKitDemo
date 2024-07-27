# UIKit Demo Project for Learning Purposes

## Overview
This project is a UIKit demo application designed to provide learners with a practical understanding of various UIKit components and architectural patterns. The application covers essential concepts such as user authentication, data fetching, UI updates, and navigation within an iOS app. The app is built using the Model-View-ViewModel (MVVM) architecture to clearly separate concerns and facilitate efficient data binding and user interaction.

## Key Features

1. **User Authentication**
   - **Login**: Users can log in using their credentials. The app includes error handling for invalid login attempts.
   - **Registration**: New users can register by providing their details. The registration process includes validation and error handling.

2. **Data Display**
   - **Browse Data**: Users can browse a list of items (e.g., products). Each item is displayed with its image, title, category, price, and rating.
   - **Item Details**: Users can view detailed information about an item, including a larger image, description, and like/unlike functionality.

3. **User Profile**
   - **Profile Management**: Users can view and manage their profile information, including their name and authentication token.

4. **Logout**
   - **Logout Functionality**: Users can log out to clear their session and redirect them to the login screen.

5. **Country Selection**
   - **Country Dropdown**: Allows users to select a country from a dropdown list.
   - **State Dropdown**: Displays states based on the selected country.
   - **City Dropdown**: Shows cities based on the selected state.
   - **Search Functionality**: Integrates `UISearchBar` into the table views for country, state, and city selection, enabling users to filter items based on their names.

6. **Image Management**
   - **Add Images**: Users can add images to a scrollable view, which can be displayed either in a list or grid layout.
   - **Full-Screen View**: Users can view images in full-screen mode with gestures like swipe, double-tap, and pinch to zoom.

7. **Counter Functionality**
   - **Increment and Decrement:** Users can increment or decrement a counter value using buttons.
   - **Data Binding:** The counter value is dynamically updated in the UI using KVO.Navigation

8. **Local Notifications**
   - **Scheduled Notifications:** Users can schedule local notifications to be triggered at a specified time.
   - **Expiry Notifications:** The app will push local notifications one day before an item expires and on the day of expiry.

9. **CRUD with Core Data**
   - **Food Demo CRUD:** Users can perform CRUD operations (Create, Read, Update, Delete) on food items, with core data integration. This includes notifications for item expiry.

10. **Map Integration**

   - **Google Maps and Apple Maps:** Users can view and interact with locations on both Google Maps and Apple Maps.

11. **Biometric Authentication**
   - **Face ID/Touch ID:** Provides an additional layer of security through biometric authentication.

## Technical Details

- **Architecture**: Model-View-ViewModel (MVVM)
  - **Model**: Represents the data and business logic (e.g., `LoginModel`, `LoginResponseModel`, `RegisterModel`, `UserListModel`, `ProductListModel`).
  - **ViewModel**: Manages the data for the view and handles business logic (e.g., `LoginViewModel`, `RegisterViewModel`, `UserListViewModel`, `ProductListViewModel`, `CollectionViewModel`).
  - **View**: The user interface components (e.g., `LoginViewController`, `RegisterViewController`, `ProductListViewController` etc).

- **Networking**
  - **API Manager**: A singleton class that handles API requests and responses using URLSession. It includes methods for making GET and POST requests and handles common headers and error responses.
  - **Endpoints**: Defined in the `APIEndPoint` enum, which conforms to the `EndPointType` protocol. This includes paths, base URLs, methods, and request bodies for various API calls (e.g., login, register, fetch items, fetch users).

- **UI Components**
  - **Custom Views**: Includes styled text fields and buttons, managed by the `Utility` class for consistent UI styling.
  - **Collection View**: Displays a grid of items with custom sizing and layout.
  - **Table View**: Used for displaying user lists.
  - **Dropdowns**: Utilizes UITableViews embedded in dropdown views (`countryTableViewOutlet`, `stateTableViewOutlet`, `cityTableViewOutlet`) to display selectable items.
  - **Labels and Buttons**: Updates UI elements (`selectedCountryNameLbl`, `selectedStateNameLbl`, `selectedCityNameLbl`, `allSelectedFieldLbl`) based on user selection.
  - **Search Bar**: Adds a `UISearchBar` to the table view headers for filtering country, state, and city names.
  - **Scroll Views**: Manages the layout and display of images in scroll views (`UserImageScrollViewController`).
  - **Image Gestures**: Provides full-screen image viewing with swipe, double-tap, and pinch-to-zoom gestures (`FullScreenImageViewControllers`).
  - **Collection View Cell xib**: Custom cell designs for `CollectionViewCell` to display product images and other data.
  - **Table View Cell xib**: Custom cell designs for `TableViewCell` to display detailed information in a structured format.
  - **Custom Text Field**: CustomUITextField class prevents users from pasting text into certain text fields.
  - **Loader Views**: LoaderViewHelper class provides methods to show and hide loading indicators on views and buttons.

- **Data Binding**
  - **Event Handling**: The ViewModels use closures to handle events such as loading, data loaded, errors, and navigation. This allows for reactive updates to the UI based on the state of the data.
  - **Combine Framework**: Uses Combine publishers and subscribers (`@Published`, `sink`) in the ViewModel to update UI components reactively.

## Improvements

1. **Search Functionality**
   - Integrated UISearchBar to filter the data displayed in the table views for countries, states, and cities
   - Implemented functions to filter data based on the search text and show filtered results in the table view.
   - Added functionality to clear the search bar and display original data when the search bar is empty.
   - Made the search bar the table header for each table view.

2. **Code Performance and Readability**:
   - Reduced the number of API calls by optimizing data fetching strategies.
   - Broke down long functions into smaller, more manageable ones for better readability and maintainability.
   - Added comments and MARK directives to organize code sections and improve readability.

3. **User Experience**:
   - Added a custom loader to show during data loading, enhancing user experience.
   - Displayed error messages when data fetching fails, providing feedback to users.
   - Implemented a global custom loader class for UIView and UIButton to standardize the loading experience across the app.

## Screens

1. **Login Screen**: Users can enter their email and password to log in.
2. **Registration Screen**: Enables new users to sign up with their details.
3. **Dashboard**: A welcome screen showing the user’s name and options to navigate to item or user lists.
4. **Item List Screen**: Displays a list of items with images and basic details.
5. **Item Detail Screen**: Shows detailed information about a selected item, including description and rating.
6. **User List Screen**: Displays a list of users, for administrative purposes.
7. **Button Collection Screen**: Displays a dynamic number of buttons in a Collection View based on user input.
8. **Button Scroll Screen**: Displays a dynamic number of buttons in a Scroll View based on user input.
9. **Country Selection Screen**: Allows users to choose a country, state, and city from dropdown menus, with search functionality integrated.
10. **User Image Scroll Screen**: Allows users to add and view images in a scrollable view, with options for list or grid layout.
11. **Full-Screen Image View**: Enables full-screen viewing of images with swipe, double-tap, and pinch-to-zoom gestures.
12. **Profile Section Screen:** Shows the list of user details that have been added.
13. **Profile Detail Screen:** Shows the details of the selected user and includes swipe functionality for deleting the user.
14. **Profile Add Details Screen:** Shows the form where users can enter data and save it locally.
15. **Profile Edit Details Screen:** Shows the form where users can edit data and save it.
16. **Sticky Header Screen:** Shows the list of product data categorized by category name, with a sticky header and scrollable functionality. The first cell uses the `TableViewCell` class.
17. **Swipe Image TableViewCell:** Shows all product images with swipe gestures.
18. **Image TableViewCell:** Shows all product images in a vertical scroll within a `CollectionViewCell`.
19. **Add Task Screen:** In the Screen, the user can add the details of the task and this screen is used for editing the existing data also.
20. **Task List Screen:** In the Screen, the user can see the list of tasks and this 
screen is used for the navigating to edit screen and deleting the existing data. This screen has the trailing tableView swipe functionality also. 
21. **LabelCountAViewController:** Show the increment and decrement of the count from the total three screens.
22. **Local Notification Screen:** Users can schedule local notifications and view a list of scheduled notifications.
23. **Food Demo CRUD Screen:** Allows users to perform CRUD operations on food items with core data integration, including local notifications for item expiry.
24. **Google Map Screen:** Displays a map with Google Maps integration.
25. **Apple Map Screen:** Displays a map with Apple Maps integration.
26. **Biometric Authentication Screen:** Enables biometric authentication (Face ID/Touch ID) for enhanced security.

## Navigation

- **Storyboard-Based**: The app defines UI and screen navigation using storyboards. Each view controller is instantiated from the storyboard using a shared instance method.

## Error Handling

- **DataError Enum**: Defines various error types that can occur during network operations, such as invalid response, invalid URL, network errors, and decoding errors.

## Extensions

- **UIViewController Extensions**: Provides methods for creating shared instances of view controllers from the storyboard.
- **UICollectionView and UITableView Extensions**: Implements delegate and data source methods for managing collection and table views.
- **UITableView Extensions**: Implements delegate and data source methods for managing table views within dropdown menus.
- **UISearchBarDelegate**: Handles search functionality, including filtering data, clearing the search bar, and displaying original data when the search bar is empty.
- **UserImageScrollViewController**: Manages adding, displaying, and interacting with images in a scrollable view.
- **FullScreenImageViewControllers**: Handles full-screen image viewing with gesture support for navigation and zooming.

This UIKit demo project aims to deliver a comprehensive learning tool for understanding the essential concepts and best practices in iOS development. Through hands-on implementation, learners will gain valuable experience in building and managing a UIKit-based application.
