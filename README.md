# CryptoMarket

<p align="left">
[![Language Swift 3](https://img.shields.io/badge/Language-Swift 3-orange.svg)](https://swift.org) 
<br/>
<p>

## What to expect

![Image of the main TableView](/ReadmeRessources/IMG_0036.PNG)
![Image of the Detail View](/ReadmeRessources/IMG_0037.PNG)

## How to build

First fetch the Dependencies with [Carthage](https://github.com/Carthage/Carthage):

    carthage update
    
Then build the Project with XCode.

## Architectural  Notes

The  architectural pattern of the App is based on the [MVC-RS](https://www.youtube.com/watch?v=SU6h0-THvbA) (Model, View, Controller, Router, Store) pattern. Instead of using nib/Storyboard initialized Viewcontrollers i tried to solely build the app programmatically and type safe. The Router Protocols are based on the Talk of [Nielas van Hoorn](https://www.youtube.com/watch?v=KDl7Czw63mM) from the SwiftConf 2016.

Every  ViewController/Segue will be controlled by a Router Object which will handle the interaction between Models/Stores/ViewController and therefore the Viewcontroller can stay lean and simple.
