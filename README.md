# NUS Orbital 2023: HawkerBro

Orbital (Independent Software Development Project) is NUS School of Computing self-directed, independent work course. This programme gives students the opportunity to pick up software development skills on their own. Our team members consist of Ho Chung Tat Rangi and Syed Iman bin Syed Amir Shah. 

## Introducing HawkerBro
An innovative app that seamlessly connects hawker stall owners with both locals and tourists, offering a delightful experience to explore and indulge in Singapore's rich and diverse hawker food culture.

**Project poster**: Link

**Project video**: Link 

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

We have implemented a robust OTP (One-Time Password) function as our two-factor authentication (2FA) mechanism. We made use of Firebase as our backend and database due to the ease of implementation and management of user credentials.

To prevent automated bot attacks and maintain the integrity of our user base, we are exploring the implementation of Captcha. This added security measure verifies that the users interacting with our login/signup page are genuine individuals, further mitigating the risk of fraudulent activities.

Currently the phone authentication only accepts dummy numbers as we have yet to set up actual SMS OTP. These dummy numbers have their own OTPs where users can key in to create their own profiles with these dummy numbers. Our next step is to include the SMS service for OTP authentication to allow users to create their profile using their respective mobile numbers.


### Explore page

**[Proposed]**

The app incorporates a highly convenient and user-friendly "Explore" page that leverages the geographical location of the user. This functionality enables the app to display hawker stalls that are in close proximity to the user, making it effortless for them to discover nearby dining options.

Within the Explore page, users are empowered with a range of customizable filters that enhance their experience and facilitate informed decision-making. These filters include options such as ratings, distance, price range, and more. By allowing users to apply specific criteria, they can refine their search results to align with their preferences and requirements. This feature streamlines the process of finding the perfect hawker stall, ensuring that users have access to a variety of food options tailored to their specific needs.

By combining location-based suggestions with customizable filters, the app offers a seamless and efficient way for users to explore and select from the diverse range of hawker stalls available. Whether users are seeking highly rated stalls, cost-effective options, or ones within a certain distance, the Explore page provides a comprehensive solution that simplifies the decision-making process.

Furthermore, the app's Explore page serves as a hub for all the app's main features, consolidating key functionalities into a single, intuitive interface. This design approach ensures that users can easily navigate through the app, access relevant information about each hawker stall, view ratings and reviews, and make well-informed dining choices—all in one centralised location.

**[Current Progress]**
Currently, the Explore page only displays the account details as well as a logout button that will bring users back to the welcome screen. 


### Ratings and Review 

**[Proposed]**

The app provides a powerful platform for users to share their ratings and reviews of hawker stalls, promoting transparency and encouraging valuable feedback. One unique feature is the built-in auto-translation functionality, specifically designed to bridge language barriers between users and hawker stall owners. This feature ensures that hawker stall owners, who may only be fluent in dialects or a specific language, can understand and benefit from the reviews and comments shared on the app.

By offering this auto-translation feature, the app facilitates effective communication and opens up opportunities for constructive criticism and improvement. It empowers hawker stall owners to gain insights into their dishes' performance, even if their stall may not be performing as well as they would like. This constructive feedback enables them to identify areas for enhancement and make necessary adjustments to their offerings.

The app not only allows users to post ratings and reviews but also fosters a strong sense of community by providing a dedicated section for hawker stall owners to engage and respond to their consumers. 

This two-way communication feature enables hawker stall owners to directly interact with their customers, fostering a deeper connection and understanding between them. The app fosters a sense of community among its users, creating an environment where people can come together to appreciate local cuisine, support their favourite hawker stalls, and discover new culinary gems. Users can engage in discussions, share their experiences, and contribute to the overall improvement of the hawker food scene.

By combining the features of ratings, reviews, and auto-translation, the app serves as a valuable tool for both users and hawker stall owners alike. It promotes a culture of feedback, encourages growth, and helps maintain the high quality and authenticity of hawker food, ultimately benefiting the entire community of food enthusiasts and hawker stall owners.

**[Current Progress]**
N.A. for milestone 1


### Vendor Listing

**[Proposed]**
​​
The app facilitates hawker stall owners in creating comprehensive profiles where they can list their menu items, prices, opening hours, and location, while also recognizing that some hawkers may not be tech-savvy. Additionally, consumers have the opportunity to create profiles for their favourite hawker stalls, empowering them to promote hidden gems and underrated food stalls they discover, thereby showcasing their support and appreciation through the app.

**[Current Progress]**
N.A. for milestone 1


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
- Verification through phone number
- OTP

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

For Milestone 1, we mainly created the following: 
- Welcome page
- Registration page
- OTP page
- Profile creation page
- A simple home screen that only displays the account details for now

For now, dummy numbers and OTPs are registered into Firebase that one can use to test the login. The next step is to set up the actual OTP service to be sent to actual phone numbers. After keying in the phone numbers, users will be brought into an OTP page that prompts users for an OTP (dummy OTPs are linked to dummy numbers). Keying in the right OTP will log users into the home page. For new phone numbers, the users will be brought to a profile creation screen whereas existing phone numbers will bring users straight to the home page. On the home page, there is a logout button that will bring users to the welcome page.

The following are the dummy numbers and OTPs that can be used for our login as of this stage:

Phone Numbers         OTPs (6 digit PIN)

+65 11111111             111111

+65 22222222             222222

+65 33333333             333333

+65 44444444             444444

+65 55555555             555555

+65 66666666             666666

+65 77777777             777777

+65 88888888             888888

+65 99999999             999999


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
