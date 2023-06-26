# NUS Orbital 2023: HawkerBro

Orbital (Independent Software Development Project) is NUS School of Computing self-directed, independent work course. This programme gives students the opportunity to pick up software development skills on their own. Our team members consist of Ho Chung Tat Rangi and Syed Iman bin Syed Amir Shah. 

## Introducing HawkerBro
An innovative app that seamlessly connects hawker stall owners with both locals and tourists, offering a delightful experience to explore and indulge in Singapore's rich and diverse hawker food culture.

**Project poster**: [Link](https://drive.google.com/file/d/14vHV0Vl82uYMaQ9ET9EB3rWIsIQssWos/view?usp=share_link)

**Project video**: [Link](https://drive.google.com/file/d/1X0ejjz98kEvR3nC1feLYiT9gXDLodrCd/view?usp=share_link) 

*For technical proof of concept and user testing instructions, please scroll all the way to the bottom.*

## Motivation 

Rising food prices. Hawkers are unable to keep up with rental prices. Hawkers are unable to find people to take over their stalls. Weakening hawker culture. These are the news and everyday realities that plague Singapore’s unique hawker culture. 

The rising cost of living has made it increasingly difficult for small business owners, particularly hawkers, to maintain their livelihoods and keep their businesses afloat. This has led to a decline in the number of hawker stalls and a loss of traditional local cuisine, which are integral part of Singapore's cultural identity.

By creating an app that connects hawkers with customers, we hope to contribute to the preservation of Singapore's hawker culture and support local entrepreneurs. We believe that this app has the potential to not only increase accessibility to affordable and diverse food options but also to stimulate economic growth in our community. 

For hawkers, we hope to be able to empower small business owners and increase inflow and traffic to their stalls. For consumers, we hope to preserve our local culture, by reducing the information asymmetry and ease of accessibility of finding bang-for-the-buck hawker food options around Singapore.


## Aim 

To create a community on mobile that seamlessly connects hawkers with potential customers, enabling them to easily discover and purchase high-quality and affordable meals. 


## Vision

We envision HawkerBro to be the Yelp for hawker stalls and hawker lovers. In other words, we want it to be a go-to app for hawker-related matters. By providing a user-friendly interface and a reliable platform for hawker owners to reach new customers, our app will help to promote local entrepreneurship and preservation of culture while improving accessibility to diverse food options for all consumers.

HawkerBro will be available first as an IOS application and potentially on Android as well. As a mobile application, it is a convenient tool to use on the go for consumers who are out and about, and looking for a good yet affordable meal. It is easily and intuitively accessible on smartphones, providing a better overall user experience. As a hawker, a mobile app is also better optimised for use given their working environment. Ultimately, we hope that HawkerBro appeals to our users as a hawker food-searching app that is convenient and user-friendly. 


## User Stories

### Business

As a hawker stall owner who is not tech-savvy, I want to be able to set up a stall profile easily to allow more consumers to know about my store. 
As a hawker stall owner, I want to notify my customers about any updates.
As a hawker stall owner, I want to have a pool of customers from different races. However, I may only know one language. I want to be able to consolidate more feedback.


### Consumer

As a consumer,  I want to be able to find good, affordable food near me
As a consumer, I want to be able to set up a profile for my favourite hawker stalls to share the joy of food with others.
As a consumer, I want to be able to have a centralised platform for me to browse through the different hawker stalls for places that I may be unfamiliar with or looking for new options.
As a consumer, I want to be able to review my food to let other consumers know about the particular food/stall I am eating.

## Features 

### Main features of HawkerBro

[Proposed] - features for Minimum Viable Product (MVP) by Splashdown

[Current Progress] - elaboration on current progress of specific feature


### Login/Sign-up page

**[Proposed]**

Our app offers a visually appealing login/signup page to warmly welcome users. We understand the importance of creating a positive first impression, and our goal is to provide a seamless and secure authentication experience.

**[Current Progress]**

Primarily, HawkerBro uses the main sign-in method of Email and Password. By utilising the Firebase SDK Authentication, users would be able to create a new account and login to an existing account. For the Signup Page, there is a password and confirm password textfield. If the passwords do not match, an error would pop up.

**[Implementation Challenges]**
During Milestone 1, our primary focus was on implementing phone authentication. However, we encountered various challenges in generating OTP messages and faced difficulties with deployment as our app could not obtain a valid Google Play Integrity token since it was not obtained through Google Play Store. As a result, we decided to switch to email authentication, which proved to be a more straightforward solution. This decision was also influenced by considering our target user audience, including tourists, who may incur additional charges for receiving SMS messages internationally. Although we had initially included a feature for generating international phone numbers, we determined that email authentication would be a more practical and user-friendly approach.


### Explore page

**[Proposed]**

The app incorporates a highly convenient and user-friendly "Explore" page that leverages the geographical location of the user. This functionality enables the app to display hawker stalls that are in close proximity to the user, making it effortless for them to discover nearby dining options.

Within the Explore page, users are empowered with a range of customizable filters that enhance their experience and facilitate informed decision-making. These filters include options such as ratings, distance, price range, and more. By allowing users to apply specific criteria, they can refine their search results to align with their preferences and requirements. This feature streamlines the process of finding the perfect hawker stall, ensuring that users have access to a variety of food options tailored to their specific needs.

By combining location-based suggestions with customizable filters, the app offers a seamless and efficient way for users to explore and select from the diverse range of hawker stalls available. Whether users are seeking highly rated stalls, cost-effective options, or ones within a certain distance, the Explore page provides a comprehensive solution that simplifies the decision-making process.

Furthermore, the app's Explore page serves as a hub for all the app's main features, consolidating key functionalities into a single, intuitive interface. This design approach ensures that users can easily navigate through the app, access relevant information about each hawker stall, view ratings and reviews, and make well-informed dining choices—all in one centralised location.

**[Current Progress]**
As of Milestone 2, we have a mockup front end of the Explore page. It consists of buttons that allow users to access their account page, swap to different tabs such as Notifications and Favourites and toggle between two nearby hawker centres to display the stalls that are located there (We have yet to implement location services to identify and show hawker centres near the user’s location as it is costly to make use of Google geocoding API without first optimising our search queries. As such, this feature may only be available after the end of this project as we have to fine tune all our queries before paying to use the API. For now, we may think of slightly different features with similar interfaces that are free to use instead.) Clicking on the stalls displayed will navigate the users to the respective hawker stall screens.

On our explore page, we have also implemented a functioning search button. This navigates the users to a search page where they will be able to search for hawker stalls. This function is implemented with search history as well as suggestions for stalls that match user input in the search bar.


### Ratings and Review 

**[Proposed]**

The app provides a powerful platform for users to share their ratings and reviews of hawker stalls, promoting transparency and encouraging valuable feedback. One unique feature is the built-in auto-translation functionality, specifically designed to bridge language barriers between users and hawker stall owners. This feature ensures that hawker stall owners, who may only be fluent in dialects or a specific language, can understand and benefit from the reviews and comments shared on the app.

By offering this auto-translation feature, the app facilitates effective communication and opens up opportunities for constructive criticism and improvement. It empowers hawker stall owners to gain insights into their dishes' performance, even if their stall may not be performing as well as they would like. This constructive feedback enables them to identify areas for enhancement and make necessary adjustments to their offerings.

The app not only allows users to post ratings and reviews but also fosters a strong sense of community by providing a dedicated section for hawker stall owners to engage and respond to their consumers. 

This two-way communication feature enables hawker stall owners to directly interact with their customers, fostering a deeper connection and understanding between them. The app fosters a sense of community among its users, creating an environment where people can come together to appreciate local cuisine, support their favourite hawker stalls, and discover new culinary gems. Users can engage in discussions, share their experiences, and contribute to the overall improvement of the hawker food scene.

By combining the features of ratings, reviews, and auto-translation, the app serves as a valuable tool for both users and hawker stall owners alike. It promotes a culture of feedback, encourages growth, and helps maintain the high quality and authenticity of hawker food, ultimately benefiting the entire community of food enthusiasts and hawker stall owners.

**[Current Progress]**
The hawker stall screen now displays a ratings and reviews section at the bottom. Each entry will comprise of a review that will truncate to a maximum of 2 lines, with the ability to expand upon clicking the “show more” button, as well as the number of stars given together with the review by the user. For now, the names are only placeholders as we have yet implemented the backend link between the user account and the reviews section.

We have also successfully built a page for consumers to leave their ratings, in terms of the number of stars, and their reviews for the stall. This page can be navigated from the hawker stall screen by clicking the “Leave a Review” button at the bottom of the screen. Users will then be able to choose the number of stars they want to rate and type in the reviews that they want to post. Clicking the “Post Review” button will post the review and navigate the user back to the hawker stall screen. As of now, we have yet to implement the ability to post and display pictures and will be done after this milestone.


### Vendor Listing

**[Proposed]**

The app facilitates hawker stall owners in creating comprehensive profiles where they can list their menu items, prices, opening hours, and location, while also recognizing that some hawkers may not be tech-savvy. Additionally, consumers have the opportunity to create profiles for their favourite hawker stalls, empowering them to promote hidden gems and underrated food stalls they discover, thereby showcasing their support and appreciation through the app.

**[Current Progress]**
The hawker stall screen is almost done, with minor fine tuning left to do. It displays the stall name, images, information and reviews about the stall, fetched from our database. The average rating is also calculated from all the ratings given for the particular store and displayed in this page. We have also implemented a basic editing screen for the hawker stall that allows users to edit the certain information about the stall. As of now, we have yet to implement the changing of stall images, postal code and unit number. We have also yet to implement restrictive functions to allow only certain individuals (e.g the creator or the owner of the stall profile) to edit so that the information cannot be edited by anyone unless they have access to it.

To list a stall such that it appears in our database and can be found through our search page, users will be able to create a hawker stall at their own account screen. This will navigate them to a screen where they can input details and images to add a stall into our database. There are also validation checks for some of the fields. For example, if a user keys in a unit number that already exists in the same postal code in our database, their submission will be rejected as the stall has already been recorded. This helps to prevent duplicates. 

The hawker stall screen is also equipped with a refresh function. Users can swipe down from the top to refresh the page and get the most updated information. Additionally, as a user successfully posts a review or edits the stall information, the hawker stall screen will automatically refresh as they are navigated out of these pages so that they will be able to see the updates immediately reflected.


### Real-time updates
**[Proposed]**

The app offers real-time updates on hawker operations, allowing hawker stall owners to input important information that they want consumers to know. This addresses a common issue faced by consumers, as they often encounter a lack of online information about hawker stalls. By providing a platform for hawker stall owners to communicate real-time updates, such as running out of food or deciding not to open for a day, the app ensures that consumers are conveniently notified, saving them from making a wasted trip and enhancing their overall experience.

**[Current Progress]**
N.A. for milestone 1


## Proposed Features

### Hawker Profiles
- Details
- Tags
- Review/Ratings (by food reviewers)
- Food reviewers are able to create profiles of hawker stalls that have not been created
- Notifications and sharing functions (including real-time updates by stall owners)

### Food Reviewer Profiles
- Details
- Tags
- Review/Ratings (List of review/ratings published by the food reviewers)

### Register/Log-in
- Verification through email and password
- Creation of user account

### Review/Ratings (in conjunction with point 1c and 2c)
- Food Reviewers able to leave reviews/ratings on the food that they have tried at the hawker stall
- Appear on both hawker and food reviewer profile
- Thumbs-up and Thumbs-down function
- Google Translate between the different languages
- Sorting
- Filtering

### Explore Page
- Searching
- Sorting
- Filtering 
- Link to Google Maps 


## Technical Proof-of-Concept

**Milestone 1 TPOC video:** [Link](https://drive.google.com/drive/folders/1k5BdOcm1UjkrzOHTlKox6w5yBBzsghEl)

For Milestone 1, we mainly created the following: 
- Welcome page
- Registration page
- OTP page
- Profile creation page
- A simple home screen that only displays the account details for now

For Milestone 2, we mainly created the following: 
- Welcome page
- Registration page
- OTP page
- Profile creation page
- A simple home screen that only displays the account details for now


![Authentication Flow](https://github.com/imanamirshah/hawkerbro/assets/110608505/cef7b2ef-e863-4065-9880-1f5c11b26b31)

![Entity Relationship Diagram](https://github.com/imanamirshah/hawkerbro/assets/110608505/48015cad-b943-4116-8ea1-1ed61dd211a0)

![UML Diagram](https://github.com/imanamirshah/hawkerbro/assets/110608505/516fed78-3cdd-4643-8eb8-b704a2e03aec)



## User Instructions for Testing

### Android 
- Clone the github repository at https://github.com/imanamirshah/hawkerbro
- Open Terminal in project directory
- Run ‘flutter pub get’
- Open device emulator in Android studio
- Run ‘flutter run’

**OR**

- Download the android apk located at build/app/outputs/flutter-apk/app-release.apk
- Install and run it on an android device

### IOS 
- Clone the github repository at https://github.com/imanamirshah/hawkerbro
- Open Terminal in project directory
- Run ‘flutter pub get’
- Navigate into the ios directory
- Run ‘pod install’
- Open xcode simulator
- Run ‘flutter run’
