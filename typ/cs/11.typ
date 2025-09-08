#set text(12pt)
#let date = datetime(
  year: 2025,
  month: 9,
  day: 8
)

#set align(center) 
#pad(top: 4cm, bottom: 1.5cm, [
  = 11; Inheritance & Composition

  #v(10pt)
  #set text(14pt, style: "normal")
  Gael Zarco

  #date.display("[month repr:long] [day], [year]")
])
#set align(left)

- *Inheritance*: "is-a"
- *Composition*: "has-a"

#pad(top: 0.5cm, [
== Inheritance ("is-a")
])

Allows creation of new classes from existing ones. It reduces complexity.

- *Derived*: New classes from existing ones. Inherits properties of its base
  class.
- *Base*: Original class
- *Single Inheritance*: Derived class has a single base class.
- *Multiple Inheritance*: Derived class has more than one base class.
- *Public Inheritance*: All `public` members of the base class become `public`
  members of the derived class, unless otherwise specified.

Inheritance can be viewed as a tree-like structure.

#align(center, [#image("./assets/inherit.png", width: 100%)])
_Inhertance: Figure 1_

*Syntax:*

```cpp
class className : memberAccessSpecified baseClassName {
  // Member list
}
```
_Inhertance: Figure 2_

- `memberAccessSpecifier` is `public`, `protected`, or `private` (default).
- `private` members of a base class are private to the base class.
  - Derived class cannot directly access them.
- `public` members of the base class can be inherited as `public` or `private`
  members, depending on inheritance specifier.
- Derived class can:
  - Add new members (data and/or functions)
  - Override (redefine) `public` member functions of the base class

#align(center, [#image("./assets/inherit_2.png", width: 100%)])
_Inhertance: Figure 3_

#pad(top: 0.5cm, [
== Overiding/Overloading Member Functions of the Base Class
])

To *override* a `public` member function:
- Derived function must have the *SAME* name, number, and types, of params as in
  the base class.
  - Otherwise, it is *overloaded*.
- Use `::` to access base class functions from within derived class.


#pad(top: 0.5cm, [
== Constructors of Derived/Base Classes
])

A derived class constructor cannot directly access `private` members of the base
class.
- It can init `public` or `protected` members of the base class.

Derived class declared $->$ constructor from base class executed.

#align(center, [#image("./assets/inherit_3.png", width: 100%)])
_Inhertance: Figure 4_

*Destructors* deallocate memory resources allocated by a `class`.

#pad(top: 0.5cm, [
== Header File of a Derived Class
])

Create new header files to define new classes.
- For derived classes, include the header file of the base class.
- Definitions appear in a separate `.cpp` file.

#pad(top: 0.5cm, [
== Multiple Inclusions of a Header File
])

Use `#include` to include a header file
- Use `""` instead of `<>`

#pad(top: 0.5cm, [
== C++ Steam Classes
])

The `std::ios` class is the base class of all stream classes.

#align(center, [#image("./assets/stream.png", width: 100%)])
_Inhertance: Figure 5_

`istream` and `ostream` provide ops for data transfer between devices.

#pad(top: 0.5cm, [
== Protected Members of a Class
])

A derived class *CANNOT* directly access `private` members of its base class.
- Declare them as `protected` in the base class so the derived class can
  directly access them.

#pad(top: 0.5cm, [
== Inheritance as `public`, `protected`, or `private`
])

#align(center, [#image("./assets/access.png", width: 100%)])
_Inhertance: Figure 6_

#pad(top: 0.5cm, [
== Composition (Aggregation)
])

One or more member(s) of a class are *objects* of another class type.
- *composition* is considered stricter than *aggregation*.

Member objects of a class:
- Constructed *before* containing class' constructor body executes.

#pad(top: 0.5cm, [
== Object-Oriented Design (OOD) and Object-Oriented Programming (OOP)
])

Fundamental principles:
- *Encapsulation*: Combine data & operations on that data in a single unit
  (`class`).
- *Inheritance*: Derived units inherit data and operations from base unit.
- *Polymorphism*: Abilitiy to use the same expression to denote different
  ops.

in *Object-Oriented Design*:
- The *object* is the fundamental entity.
- Debugging often occurs at the class level.
- A program is a collection of *interacting objects*.

*Object-Oriented Programming* implements OOD in a programming language
- C++ supports OOP through the use of classes.
- A function name and operators can be *overloaded*.
- Templates provide *Parametric Polymorphism*.
- C++ supports *Runtime Polymorphism*.

Every object has *internal* (`private`/`protected` members) and *external*
  (`public` members) state.

