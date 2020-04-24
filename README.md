# AssignmentOpenBank

## Design principles

<p align="center">
    <img src="https://www.objc.io/images/issue-13/2014-06-07-viper-intro-0a53d9f8.jpg" alt="VIPER" height="200px">
</p>

This project was created following VIPER architecture which is based on Clean Architecture principles.
In addition to the VIPER components View, Interactor, Presenter, Entity and Routing I added the Builder and the Worker.
<p align="center">
    <img src="https://www.objc.io/images/issue-13/2014-06-07-viper-wireframe-76305b6d.png" alt="VIPER" height="280px">
</p>

The project is divided in scenes, each scene have the View, Presenter, Router, ViewModels and Builder. The builder is in charge of instantiate all the components needed for each scene and add Interactors if bussiness layer is needed.

Each interactor is a Use Case and are called from the Presenter. Interactor have one or more workers, every worker is an atomic action and can be used in different Interactors to compose a new Use Case. 

Domain models are used on bussines layer and converted to view models to use on the presentation layer, the presenter is on charge of this conversion and deciding the behaviour of the view layer.

I chose this architecture because is scalable and easy to test. I added testing in some of the scenes to show at least one test type(Interactor and Presenter).

## Challenges during development



*Note: Carthage used to manage dependencies (run carthage bootstrap --platform ios command on the project folder)*
