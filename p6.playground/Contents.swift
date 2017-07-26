//: # Lighthouse Labs
//: https://github.com/lighthouse-labs/iOS-PartTime-Swift-Playgrounds-W1D1/blob/master/W1D1-VariablesAndTypes.playground/Contents.swift
//: ## Intro to Swift
//: ### W1D1 - Variables and Types
//:
//:

//: ## Variables
//: Variables allow us to store data that we can use at a later time
//: In swift, you create variables like this:

var greeting = "Hello, world!"

//: There are three important parts to creating a variable: 1) writing `var` to show you are creating a new variable, 2) naming the variable,
//: and 3) the data stored inside the variable
//: In the example above, the name of the variable is `greeting` and the value is a string "Hello, world!"

var count = 0

//: *Note:* In this case, the name of this variable is `count`, and the value is the number `0`


//: We can change the data stored in a variable.
//: To do this we use the *assignment operator* `=`.
//: For example, the following code changes the data stored in the `count` variable to the number 10.

count = 10

//: *Note:* To create a new variable we write `var` before the name, when we change the data inside an existing variable we do not.


//: ### Challenge 1
//:
//: Now it's your turn. Change `greeting` to be a different string by using the assignment operator.



//: *Note:* unlike math, where `x = 10` and `10 = x` are interchangeable, in programming the variable goes on the left of the `=` symbol, and the new value goes on the right.


//: ### Challenge 2
//:
//: We want to add 1 to whatever the value of `count` is now. We could manually look at the value in `count`, see that it is 10 and put 11 into `count` using the assignment operator. This works, but we can do it in a better way. We can set count to be whatever count is, plus 1. See if you can figure out the syntax for this.


//: *Note:* If you're ever unsure of the contents of a variable in a playground, write the variable on a line by itself and you will see its value printed to the right of it. Or you can use the `print` function like so: `print(variableName)`.


//: ## Types
//:
//: Types are very important in Swift. When you create a variable, that variable has a "type". What this means is the variable can only hold one type of data. If the variable is of type `String`, that means you can't put a number in it.
//:
//: Hold down the Option key and click on the variables `greeting` and `count` to see a popup window with information about the variable. If we click on `greeting`, we can see it's a `String`. What type is `count`?

greeting
count

//: Let's go over some basic types:
//:
//: String - a collection of characters inside "quotation marks"
//:
//: Bool - either true or false
//:
//: Int - a whole number. ex) 5
//:
//: Double - a number with more precision. ex) 5.55  

//: ### Challenge 3
//: What type are the variables `tipAmount`, and `isOpen`?

var tipAmount = 6.01
// tipAmount's type is:


var isOpen = true
// isOpen's type is:


//: ## Type Inference
//:
//: Swift infers (guesses) the type of a variable based on the initial value. This is mostly useful, but sometimes we want to change the inferred type.
//: For example, if we want to make a variable that has decimal precision. Integers (Int) are only whole numbers (1,2,3, etc.) while Doubles can represent fractional numbers (2.14, 5.99, etc.).
//:
//: To create a Double, all we need to do is specify the type when we create the variable.

var height: Double = 10

//: Since all our variables have types, even if we haven't specifically set them, we can't store any value in them... only values of the right type.
//: Test this out. Try setting the value of `count` to be `height`:



//: It didn't work, right? They are both numbers, but `count` is an Int, and `height` is a `Double`. There are ways to convert the `Double` 10 into the `Int` 10, but we won't go into that just now.


//: ## Bonus Challenge
//:
//: It may not be obvious, but the types we are using, `String`, `Int`, and `Double` all have methods, or bits of code, you can ask them to run. `Float` and `Int` have a pretty minimal set of things they can do, but `String` has a lot!
//:
//: Write out the name of a variable, e.g. `greeting`, and then a period. This will show the autocomplete menu. From this list you can pick `uppercaseString` and `lowercaseString` to change the case of the characters in our greeting.
//:
//: Print out the uppercase and lowercase versions of the string below:

var schoolName = "Lightouse Labs"



//: THE END
