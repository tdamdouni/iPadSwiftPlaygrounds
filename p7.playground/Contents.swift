
//: # Lighthouse Labs
//: https://github.com/lighthouse-labs/iOS-PartTime-Swift-Playgrounds-W1D2/blob/master/W1D2-ControlFlow.playground/Contents.swift
//: ## Intro to Swift
//: ### Control Flow
//:

//: Say we have a varaible we're going to use to keep track of how many bicycles we own:

var bicycleCount = 100

//: Now we want to print out a description of the number of bicycles we have:

print("There are \(bicycleCount) bicycles")

//: If our count is 1, this becomes an awkward sentence.

bicycleCount = 1

print("There are \(bicycleCount) bicycles")

//: We'd much rather see:

print("There is \(bicycleCount) bicycle")

//: So we need to print out different strings depending on the value of `bicycleCount`.
//: For this we use conditional logic. Specifically `if`, `else` and sometimes `else if`. Here's an example:

var someThing = 1
var otherThing = 2

if someThing == otherThing {
    print("This bit of code should never run")
} else {
    print("This bit of code should run")
}

//: There are a few things going on here. Let's look at them!
//:
//: 1. Curly-braces. We use the `{` and `}` symbols to start and end sections of code.
//: 2. `if` and `else`. The section of code following the `if` will be run if the data in `someThing` is equal to the data in `otherThing`. The section of code following the `else` will be run if they are not equal.
//: 3. Double equals. In Swift the single equals is the "assignment operator" used to change the data in a variable, we use the double-equals `==` to compare two pieces of data.



//: ### Challenge 1
//:
//: Now see if you can make an `if`/`else` statement that prints out a grammatically correct description of how many bicycles we have. I.e. "There is 1 bicycle" or "There are 100 bicycles".

bicycleCount = 1




//: ### Challenge 2
//:
//: Now try to add an `else if` clause so it prints out "There are zero bicycles" if the `bicycleCount` is 0. `else if` goes between the `if` and the `else` blocks.

bicycleCount = 0





//: ### Bonus Challenge
//: Make an if/else block that prints "I think so!" if `inputString` ends in "?", if the string ends in any other character then print "You don't say!"
//: If you can't figure out how to tell if a string ends in ?, try googling something like "swift string ends with character".

var inputString = "Do you like bicycles?"







//: THE END
