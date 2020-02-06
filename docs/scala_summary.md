# Scala summary

Scala is a blend of object-oriented and functional programming concepts in a statically typed language. Everything is an object, including numbers or functions. Function types are classes that can be inherited by subclasses. It runs on the JVM.

OOP is orthogonal from logic programming, functional or imperative programming.

* Run on the standard Java platform and interoperates seamlessly with all Java libraries
* It is also a scripting language with its own interpreter
* Support an "associative map" construct in the syntax of the language
* Scala allows users to grow and adapt the language in the directions they need by defining easy-to-use libraries that feel like native language support.
* Support enhanced parallel processing using actors: Actors are concurrency abstractions that can be implemented on top of threads. They communicate by sending messages to each other. An actor can perform two basic operations, message send and receive. The send operation, denoted by an exclamation point (!), sends a message to an actor. A send is asynchronous.
* Scala is an object-oriented language in pure form: every value is an object and every operation is a method call.
* It supports composing objects with the concept of Trait. Traits are like interfaces in Java, but they can also have method implementations and even fields. Objects are constructed by mixing composition, which takes the members of a class and adds the members of a number of traits to them.
* Traits are more "pluggable" than classes
* Functions that are first-class values provide a convenient means for abstracting over operations and creating new control structures
* The second main idea of functional programming is that the operations of a program should map input values to output values rather than change data in place
* Methods should not have any side effects. They should communicate with their environment only by taking arguments and returning results

## why scala ?

* Scala is compatible with java API
* Concise: quicker to write, easier to read, and most importantly, less error prone
* High level: scala lets developers raise the level of abstraction in the interfaces they design and use
* Scala's functional programming style also offers high-level reasoning principles for programming.
* Statically typed: very advanced static type system. Starting from a system of nested class types much like Java's, it allows you to parameterize types with generics, to combine types using intersections, and to hide details of types using abstract types. Verbosity is avoided through type inference and flexibility is gained through pattern matching and several new ways to write and compose types
* Static type systems can prove the absence of certain run-time errors
* A static type system provides a safety net that lets you make changes to a codebase with a high degree of confidence, by identifying change name, adding new parameters to functions...

Scala has some innovations: abstract types provide a more object-oriented alternative to generic types, its traits allow for flexible component assembly, and its extractors provide a representation-independent way to do pattern matching.

Scala has an interactive shell or REPL: Read-Eval-Print-Loop. Started by using > scala or using the scala build tool, sbt, using >sbt console.

To read more about scala API: [www.scala-lang.org/api](www.scala-lang.org/api)

## language constructs

### Variables

Scala has two kinds of variables, vals and vars. A val is similar to a final variable in Java. Once initialized, a val can never be reassigned. A var, by contrast, is similar to a non-final variable in Java.
Scala uses the type inference capability to figure out the types not specified at variable declaration:

```scala
val msg = "Hi"
var x = 4
```

See some first exercise in this code: [LeaningScala1.sc](https://github.com/jbcodeforce/spark-studies/tree/master/src/SparkStreaming/LeaningScala/src/LeaningScala1.sc)

Primitive types are with uppercase because Scala is fully object oriented

Object is for a class that is a single instance. there is no static concept in Scala. it is covered by the object concept

### Expression evaluation

non-primitive expression is evaluated:

* take leftmost operator
* evaluate its operands left before right
* apply the operator to the operands

### Operators are methods

1 + 2 really means the same thing as (1).+(2). The + symbol is an operator—an infix operator to be specific. Operator notation is not limited to methods like + that look like operators in other languages. You can use any method in operator notation.

Scala also has two other operator notations: prefix and postfix. In prefix notation, you put the method name before the object on which you are invoking the method. prefix and postfix operators are unary: they take just one operand.
The only identifiers that can be used as prefix operators are +, -, !, and ~

The logical-and and logical-or operations are short-circuited as in Java: expressions built from these operators are only evaluated as far as needed to determine the result

The operator precedence looks like:

```scala
(all other special characters)
* / %
+ -
:
=!
<>
&
^
|
(all letters)
(all assignment operators)
```

### Function

Function declaration has the following form

```scala
def functionName ([list of parameters]) : [return type]
def constOne(x: Int, y: => Int = 1
// y is passed by name

def format now
```

A function can support using Type parameter, written in []  See polymorphism

```scala
def singleton[T](elemen: T) : T

or
 def encode[T](l : List[T]): List[(T,Int)]
```

Function evaluation for a function f(a1,...,an) is done by evaluating the expressions a1,...,an of the parameters resulting in the values v1,..,vn, then by replacing the application with the body of the function f in which the actual parameters are v1,..,vn

function evaluation is done by *substitution model*: all evaluation done is by reducing an expression to a value.

* evaluate all function arguments from left to right
* replace function application by function right-hand side
* replace the formal parameters of the function by the actual arguments
* two evaluation models: call by value, and call by name

See the code example in: [LeaningScala3.sc](https://github.com/jbcodeforce/spark-studies/tree/master/src/SparkStreaming/LeaningScala/src/LeaningScala3.sc)

A name is evaluate by replacing its right end definition.

Functions are objects. It is possible to pass functions as arguments, to store them in variables, and to return them from other functions.

```scala
 // function that uses a function as argument
    // type () => Unit is for function taking no argument and return nothing
     def oncePerSecond(callback: () => Unit) {
          // call it
          callback()
     }
// factorial example
def factorial(n : Int): Int =
   if (n == 0) 1 else n * factorial (n-1)

// greatest common denominator using the Euclid algorithm
def gcd(a: Int, b: Int) : Int = 
   if (b == 0) a else gcd(b,a % b)

// sum of integers between a and b with function as argument
  // f is a function as A=>B is a type of a function that takes an argument
  // of type A and returns a result of type B
  def sum(f : Int => Int, a: Int, b: Int) : Int =
    if (a > b) 0
    else f(a) + sum(f,a+ 1,b)

 def sumInts(a : Int,b: Int) = sum(id,a,b)
 def id(x: Int): Int = x
```

The sum function is a linear recursion.
Tail recursion: if a function calls itself as its last action, the functions stack frame can be used. It is iterative. (gcd above is a tail recursive function)

Anonymous function:

```scala
// Declared like:  (x1 : T1,.... , xn :Tn) => E

(x:Int) => x*x*x
// using anonymous function to compute the sum of the cubes using the sum function defined above
def sumCubes(a : Int,b: Int) = sum(x => x *x *x,a,b)

// another simplification by using function as return result
// sum return a function that takes to int as argument and return a int
def sum(f: Int => Int): (Int, Int) => Int = {
         def sumF(a:Int, b:Int) : Int =
           if (a > b)  0
           else f(a) + sumF(a+1 ,b)
         sumF
    }

def sumCubes = sum(x => x*x*x)
println(sumCubes(1,10))
```

When doing functional programming, you try to avoid side effect, by using vars. When your function need to modify its parameters, use the Unit result type. Function values are treated as objects in Scala.

### Class

The class declaration includes the parameters of the constructor:

```scala
class Tweet(val user: String, val text: String, val retweets: Int) { ...
```

parameters are always pass by-value, they become fields of the class

```scala
val a = new Tweet("gizmodo"," some text", 20)
a.user
```

Classes in Scala cannot have static members. So there is the concept of singleton object: the definition looks like a class definition, except instead of the keyword `class` you use the keyword `object`. When a singleton object shares the same name with a class, it is called that class's companion object. They cannot take parameters. A singleton object that does not share the same name with a companion class is called a standalone object.

It is possible to define precondition of the primary constructor of a class. For example for the Rational class we can enforce that the denominator is never 0 using require expression

```scala
class Rational(n: Int, d: Int) {
    require(d != 0)
    override def toString = n +"/"+ d
  }
```

Class can use type parameter to support polymorphism

```scala
trait List[T] {
  def isEmpty : Boolean
  def head : T
  def tail : List[T]
}

class Cons[T]( val head : T, tail: List[T]) extends List[T] {
  def isEmpty = false
}

class Nil[T] extends List[T] {
 def isEmpty = true
 def head :Nothing =  throw new NoSuchElementException("Nil head")
 def tail :Nothing = throw new NoSuchElementException("Nil tail")
}
```

Immutable objects offer several advantages over mutable objects:

* easier to reason about than mutable ones, because they do not have complex state spaces that change over time
* pass immutable objects around quite freely, whereas you may need to make defensive copies of mutable objects before passing them to other code
* there is no way for two threads concurrently accessing an immutable to corrupt its state once it has been properly constructed, because no thread can change the state of an immutable!
* immutable objects make safe hashtable keys
* main disadvantage of immutable objects is that they sometimes require that a large object graph be copied where otherwise an update could be done in place.

`scala.Any` is the root of all classes in scala. `scala.AnyVal` is base type of all primitive types. `scala.AnyRef` the base type of reference types, it is an alias to java.lang.Object.

`scala.Nothing` is at bottom of type hierarchy. There is no value of type Nothing. it is used to signal abnormal termination or as an element type of an empty collection. `Set[Nothing]`

As the function throw and exception, the return type of the function is set to Nothing.

```scala
scala> def error(msg : String) = throw new Error(msg)
error: (msg: String)Nothing
```

`scala.Null`, is subclass of all the classes in AnyRef, and it is the type of null value. Null is incompatible with subtypes of `AnyVal`.

```scala
scala> val x = null
x: Null = null
```

One important characteristic of method parameters in Scala is that they are vals, not vars

### Unit

Methods with a result type of Unit, are executed for their side effect.  A side effect is generally defined as mutating state somewhere external to the method or performing an I/O action.

### Trait

Declared like an abstract class. They contains fields and concrete methods. A class can inherit one unique class but can have many traits.
Trait do not have parameters as part of the constructor.

### Pattern matching

When using a pure OO implementation, adding a new method to a class you may add this method in multiple classes and subclasses.  Scala offers the pattern matching capability to support simple function extension.

`case` classes are like `class` but the case keyword let them participate in pattern matching. Implicitly scala compiler will add object for case class with a factory method apply.
Pattern matching is a generalization of switch of Java.

The syntax looks like:  `expr match { case pattern => expr ... case pn => en}`
 
* in case of not matching there is a MatchError exception.
* If a pattern matches the whole right hand side is used.
* patterns are constructed from constructors, variables, wildcard patterns, constants
* case and pattern matching is also helpful for tree-like recursive data
* variable start by lowercase, where constant starts by Uppercase


### Flow control

See the code example in: [LeaningScala2.sc](https://github.com/jbcodeforce/spark-studies/tree/master/src/SparkStreaming/LeaningScala/src/LeaningScala2.sc)

Almost all of Scala's control structures result in some value. This is the approach taken by functional languages, in which programs are viewed as computing a value, thus the components of a program should also compute values.

```scala
val filename =
      if (!args.isEmpty) args(0)
      else "default.txt"
// while and do while: are loops not expression

  var line = ""
    do {
      line = readLine()
      println("Read: "+ line)
    } while (line != "")

```

The `while` and `do-while` constructs are called "loops," not expressions, because they don't result in an interesting value. The type of the result is Unit.

`For` is simply used to iterate through a sequence of integers. But has more advanced expressions to iterate over multiple collections of different kinds, to filter out elements based on arbitrary conditions, and to produce new collections. The notation " <- "  is called a generator,

```scala
for (s) yield e
```

`s` is a sequence of generators and filters, `e` is an expression whose value is returned by an iteration
generator of the form p <- c   :  c is a collection and p is a pattern
filter is a boolean expression
if there are several generators in sequence the last ones vary faster than the first

```scala
// list the file in the current directory
val filesHere = (new java.io.File(".")).listFiles
  
for (file <- filesHere)
  println(file)

for (i <- 1 to 4)  // could be 1 until 4
  println("Iteration "+ i)

// For supports filter to build subset
for (file <- filesHere if file.getName.endsWith(".scala"))

// filter can be combined, and separated by ;
for (
      file <- filesHere
      if file.isFile;
      if file.getName.endsWith(".scala")
    )

// If you add multiple <- clauses, you will get nested "loops."
// for like a SQL query
for (b <- books; a <- b.authors if a startsWith "Bird") yield b.title
```

`For` is closely related to higher order functions. For example the following three functions can be written with `for`:

```scala
def mapFunction[T,U] (xs : List[T], f: T => U) : List[U] =
   for (x <- xs) yield f(x)

def flatMap [T,U] (xs : List[T], f: T => Iterable[U]) : List[U] =
   for (x <- xs; y<- f(x)) yield y

def filter2[T] (xs : List[T], f: T => Boolean) : List[T] =
   for (x <- xs; if f(x)) yield x

val l=List( 2, 3, 4, 5)                    > l  : List[Int] = List(2, 3, 4, 5)
// to avoid missing parameter type, we need to add [Int]
val r=filter2[Int](l,(x => x% 2 == 0))    > r  : List[Int] = List(2, 4)
```

Expressing for with HOF

```scala
for (b <- books; a <- b.authors if a startsWith "Bird") yield b.title   is the same as
  books flatMap (b => for (a <- b.authors if a startsWith "Bird") yield b.title)   or
  books flatMap (b => for (a <- b.authors withFilter (a=> a startsWith "Bird")) yield b.title)   or
  books flatMap (b => b.authors withFilter (a=> a startsWith "Bird") map (y => y.title)
```

### Data Structure

See the code example in: [LeaningScala4.sc](https://github.com/jbcodeforce/spark-studies/tree/master/src/SparkStreaming/LeaningScala/src/LeaningScala4.sc)

#### List

Lists are immutable, and recursive and linear: access to the first element is much faster than accessing to the middle of end of the list.
Lists are constructed from empty list Nil and the cons operation `:: `

```scala
val empty = List()
val fruit = List("apple","banana","pear")
val matrix = List(List(1,0,0),List(0,1,0),List(0,0,1))
// equivalent to 
val fruit = "apple" :: ("banana" :: ("pear" :: Nil))
val fruit = "apple" :: "banana" :: "pear" :: Nil
// concat
val fruits = fruit ++ List("strawberry")
```

in scala there is a convention the operators ending with : associate to the right operand. They could be seen as method calls of the right hand operand
Three list operations are important, head, tail, isEmpty

```scala
xs.length
xs.last
xs.init         // build a new list from xs without the last one
xs take n    // return a new list of the n first elements of xs
xs drop n    //the rest of the collection after position n
xs(n)         // element at n position
xs splitAt n   // return a pair of two sub lists from list xs one up to index n and one from position n

val alist = "aba".toList
alist groupBy(c => c)
```

Partitions a collection into a map of collections according to a discriminator function (here is Identity)

```scala
Map[Char,List[Char]] = Map(b -> List(b), a -> List(a, a))
val m = Map("kirk" -> "Enterprise","joe" -> "Voyager")
println(m["kirk"])
```

It is possible to decompose a list with pattern matching:

#### Nil constant

p :: ps is a pattern that matches a list with a head and a tail
List(a,b,c,) to match a complete list

Here are examples of list using recursion and pattern matching

```scala
 def last[T] (xs : List[T]) : T = xs match {
   case List() => throw new Error("Last of empty list is not possible" )
   case List(x) => x
   case y :: ys => last(ys)
   }                                              //> last: [T](xs: List[T])T
 

def init[T] (xs : List[T]) : List[T] = xs match {
   case List() => throw new Error("init of empty list is not possible" )
   case List(x) => List()
   case y :: ys => y :: init(ys)
  }

def concat[T](l1: List[T],l2 : List[T]) : List[T] =
  l1 match {
    case List() => l2
    case y :: ys => y :: concat(ys,l2)
  }
```

[See the scala.collection.immutable.List documentation](http://www.scala-lang.org/api/2.11.1/index.html#scala.collection.immutable.List)

#### Other collections

Vector has a more evenly balanced structure using 32 word array. when it is more than 32 elements a next level is added as array of pointer so covering 2** 10 elements. 
The access is in log 32(n)
it supports the same operations as on List as List and Vector are Seq, the class of all sequences which itself is a Iterable. Exception is on concatenation. 

```scala
 val nums= Vector( 1, 2, 3, 44)         > nums  : scala.collection.immutable.Vector[Int] = Vector(1, 2, 3, 44)
 val n2 = 10 +: nums                  > n2  : scala.collection.immutable.Vector[Int] = Vector(10, 1, 2, 3, 44)
 val n3 = nums :+ 15
```

#### Arrays and String are Seq too

```scala
  val a = Array( 1, 2, 3, 44)                > a  : Array[Int] = Array(1, 2, 3, 44)
  a map (x => x* 2)                         res0: Array[Int] = Array(2, 4, 6, 88)
  val s = "Hello World"                   > s  : String = Hello World
  s filter (c => c.isUpper)/               > res1: String = HW
```

range represents a sequence of evenly spaced integers.
Some operations on Seq

```scala
val s = "Hello World"  
s exists ( c => c == 'e') true if there is an element in s the p(x) holds

xs forall p   true if p(x) holds for all elements x of xs

xs zip ys     build a sequence of pairs drawn from corresponding elements of sequence xs and ys
val z=s zip nums      //> z  : scala.collection.immutable.IndexedSeq[(Char, Int)] = Vector((H,1), (e,2), (l,3), (l,44))
  z.unzip               > res3: (scala.collection.immutable.IndexedSeq[Char], scala.collection.immutable.IndexedSeq[Int]) = (Vector(H, e, l, l),Vector(1, 2, 3, 44))
// other example using a range
val q = List( 2, 0, 3)  //> q  : List[Int] = List(2, 0, 3)
(2 to 0 by -1) zip q /> res0: scala.collection.immutable.IndexedSeq[(Int, Int)] = Vector((2,2), (1,0), (0,3))

xs.unzip        Splits a sequence of pairs into two sequences consisting of the first and second halves of all pairs 
xs.flatMap f    applies collection-valued function f to all elements of x and concatenates the results

// for example build a list of all combinations of number x for 1..M and y 1..N
(1 to 5) flatMap ( x => ( 1 to 6) map (y => (x,y)))
> Vector((1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (2,1), (2,2), (2,3), (2,4), (2,5), (2,6),

Example of scalar product function: sum xi * yi

def scalarProduct(xs : Vector[Double], ys : Vector[Double]): Double =
   (xs zip ys).map(xy => xy._1 * xy._2).sum     

scalarProduct(Vector(2,3,4),Vector(3,5,8)) 

// compute if n is prime: if only divisors of n is 1 and n
def isPrime(n : Int) : Boolean =
   (2 until n) forall (x => n % x != 0) 
```

#### Getting a dictionary of word 

The following will get each word (one per line in the input stream), transform it to a list and then filter out any word that does not contain a letter.  Filter apply a function to each member of the collection, forall apply for each element of the list a function f and return the matching elements.

```scala
 val words = in.getLines.toList filter (word => word forall (c => c.isLetter))
```

#### Set

Is a sequence that does not have duplicate elements, elements are unordered, it includes the operation contains

```scala
  // return all the ways to encode a number to a set of strings
  def encode(number: String) : Set[List[String]] =
     if (number.isEmpty) Set(List())
     else {
       for {
          split <- 1 to number.length                      // from 1 to length
          word <- wordsForNum(number take split)           // cut the string number from 0 to split
          rest <- encode(number drop split)                // recursion on the rest of the number string
       } yield word :: rest
       }.toSet
// returns  Set[List[String]]  ... List(Scala, is, fun), List(sack, bird, to)
```

Following code also illustrates that a function can be assigned to a variable. it is a map of digit strings to the words that represent them. words is list of words of a given dictionary

```scala
val wordsForNum : Map [String,Seq[String]] =
    words groupBy wordCode withDefaultValue Seq()

// wordsForNum  : Map[String,Seq[String]] = Map(63972278 -> List(newscast),37638427 -> List(cybernetics)
```

#### Map

maps are iterable and functional.

```scala
 val roman = Map( "I" -> 1 , "II" -> 2 , "V" -> 5 )   //> roman  : scala.collection.immutable.Map[String,Int] = Map(I -> 1, II -> 2, V
                                                  //|  -> 5)
 roman("V")                                       //> res5: Int = 5
 roman get ("II")                                 //> res6: Option[Int] = Some(2)
```

The Some is a class extending the trait Option type and takes a unique value. When a map does not contains a key it returns None which is declared as:

```scala
object None extends Option[Nothing]

veggie groupBy (_.head)     > res8: scala.collection.immutable.Map[Char,List[String]] = Map(b -> List(brocoli), t -> List(tom), c -> List(carrot), o -> List(olive))

// mapValues Transforms a map by applying a function to every retrieved value
veggie.groupBy(_.head).mapValues(_.length)
```

maps were partial functions this means that applying a map to a key value could lead to an exception if the key is not stored in the map. There is a function to set a default value if the key is not present

```scala
val c = veggie withDefaultValue "Unknown"
c("x")       // returns Unknown
```

#### Stream

Similar to lists but their tail is evaluate only on demand. they are defined from a constant `Stream.empty` and a constructor `Stream.cons`. The following example illustrates that the interpreter does not build the full Stream

```scala
 Stream.cons( 1,Stream.cons(2 ,Stream.Empty))      //> res0: scala.collection.immutable.Stream.Cons[Int] = Stream(1, ?)
 Stream(1, 2,3 ,4)                                 //> res1: scala.collection.immutable.Stream[Int] = Stream(1, ?)
```

Example of interesting use case. Compute the prime number from 1000 to 10000 but takes the second prime only. With a List the approach will compute all the prime while with Stream only the 2 first elements.

```scala
def isPrime(i: Int) : Boolean =
    (2 until i) forall ( x => i % x != 0)         //> isPrime: (i: Int)Boolean
  ((1000 to 10000).toStream filter isPrime)( 1)   > 1013

// :: is not producing a Stream but..
x #:: xs  == Stream.cons(x,xs)
```

### Scala Build Test

Using Scala Build Test. First start it in the folder with the project sub-folder, and eclipse .project

```shell
> sbt
>styleCheck
>compile
>test
>run
>submit jerome.boyer@gmail.com  <pwd>  5Tz7bNHph7
>console
scala >
```

### Scala program

To run a Scala program, you must supply the name of a standalone singleton object with a main method that takes one parameter, an Array[String], and has a result type of Unit

```scala
object ThisIsAnApp {
      def main(args: Array[String]) {
        for (arg <- args)
          println(arg +": "+ calculate(arg))
      }
}
```

Scala provides a trait, scala.Application, to run an application without main function

```scala
 object AnotherApp extends Application {
  
      for (season <- List("fall", "winter", "spring"))
        println(season +": "+ calculate(season))
 }
 ```

 The code between the curly braces is collected into a primary constructor of the singleton object, and is executed when the class is initialized

compile:

```shell
scalac  -d target/scala-2.10/classes
```

or use sbt > compile

```shell
# run unit test in sbt
> test
```

execute a program: `scala`

## Integration with java

scala can access java classes, extends java class and implement java interface. All classes from the java.lang package are imported by default, while others need to be imported explicitly.

## Further Readings

* [Cheat sheets](http://docs.scala-lang.org/cheatsheets/)
