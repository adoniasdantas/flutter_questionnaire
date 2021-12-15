![Alt](assets/images/screenshot.png?raw=true "Screenshot")
![Alt](assets/images/email_recommendation.png?raw=true "Screenshot")

# flutter_chatbot_interview

A Flutter project to practice how to use Firebase Firestore


## Getting Started

This project is a Flutter application. It consists of a list of questions.
It loads the questions from Firestore and display them in a specific order after the user answers them.
It also loads suggestions for email answers. When the user types '@' the suggestions will show up.

To run the project you'll need to follow some instructions: 
1. Setup a Firestore Database on your Firebase console. 
2. Create a collection called 'questionnaire' on Firestore. Each questionnaire consists of Id and a collection of questions
3. Create another collection inside the questionnaire called questions. Each question has the fields:
    * text: String
    * number: int (the number to order the questions)
    * multi_select: bool (required if suggestions is not empty)
    * suggestions: Array<String> (optional)

4. Create a collection of recommendations for emails. Each recommendation has only one field
    * email: String

5. Create a collection called answers. Each answer has the following fields:
    * answer: Array<String> (for multi select answers)
    * question: String (id of the question)
    * questionnaire: String (id of the questtionaire)
    * session: int

6. Set your questionnaire Id on chat_controller.dart


Questionnaire database

![Foreground](assets/images/questionnaire.png?raw=true "Screenshot")

Questions
![Foreground](assets/images/questions.png?raw=true "Screenshot")

Recommendations
![Foreground](assets/images/recommendations.png?raw=true "Screenshot")

Answers
![Foreground](assets/images/answers.png?raw=true "Screenshot")

After configuring your project. Run it using:
```
flutter run
```


