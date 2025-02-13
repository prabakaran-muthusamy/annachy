**Annachy App - Summary**

**Overview**

Annachy is an e-commerce app built with programmatic constraints to display a list of products in both grid and list views. It includes features like search, filtering, and pull-to-refresh. The app follows the MVVM architecture and leverages Combine for reactive programming, ensuring a clean and maintainable code structure.

**Features Implemented**

* Title Display: The app name, Annachy, is shown in a large title format for better user interaction.
* View Toggle Button: Users can switch between grid and list views using an option button in the navigation bar.
* Product Listing: Displays products in a collection view with both grid and list layout options.
* Search Functionality: Allows users to dynamically search for products.
* Grid & List View Toggle: Enables seamless switching between different layouts.
* Pull to Refresh: Allows users to refresh product data from the API.
* Product Details: Displays product name, category, price, rating, and image.
* Loading Indicator: Uses a third-party library to show a loader while fetching data.

**Technologies & Tools Used**

* Swift & UIKit: Core frameworks for iOS development.
* MVVM Architecture: Ensures separation of concerns and better testability.
* Combine Framework: Handles reactive data binding and API calls.
* Programmatic UI Constraints: Layouts are built using Auto Layout without Storyboards.
* Kingfisher: Efficiently loads and caches product images.
* API Integration: Fetches product data from the FakeStore API.
* SVProgressHUD: Displays a loading indicator while fetching products.
* Github: Used for version control and project management.
