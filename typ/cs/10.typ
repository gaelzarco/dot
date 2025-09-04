#set text(12pt, font: "" )
#let date = datetime(
  year: 2025,
  month: 9,
  day: 3
)

#set align(center) 
#pad(top: 4cm, bottom: 1.5cm, [
  = 10; Classes and Data Abstraction

  #v(10pt)
  #set text(14pt, style: "normal")
  Gael Zarco

  #date.display("[month repr:long] [day], [year]")
])

#set align(left)
*Object-Oriented Design (OOD)*: Problem solving methodoloy

*Object*: Combines data and the operations on that data in a single unit

*Class*: A collection of a fixed number of components

*Member*: A component of a class

#pad(top: 0.5cm, [
== Classes
])

Three Categories of class members:

- `private` _(default)_
#h(1cm) - Member cannot be accesed outsite the class

- `public`
#h(1cm) - Member is accessible outside the class

- `protected`
#h(1cm) - Member is accessible within the class and all its subclasses

#pad(top: 0.5cm, [
== Unified Modeling Language Class Diagrams (UML)
])

*UML Notation*: used to graphically describe a class and its members
 
- `+` member is `public` 
- `-` member is `private` 
- `#` member is `protected` 

#align(center, [#image("./assets/uml.png", width: 100%)])

#pad(top: 1cm, [
== Accessing Class Members
])

Once an object is declared, it can access the members of the class.

*Syntax:*

```cpp
classObjectName.memberName
```

- The dot (`.`) is the *Member Access Operator*
- Member functions of a class have access to all members (`public`, `protected`, and
  `private`) of the same class, irrespective of where an object of the class is


#pad(top: 1cm, [
== Built-in Operations on Classes
])

- Arithmetic operators can *NOT* be used on class objects unless the operators are overloaded.
- Relational operators can *NOT* be used to compare two class objects for
  equality.

*Built-in operations that are valid for class objects:*

- Member access (`.`)
- Assignment (`=`)

#pad(top: 1cm, [
== `class` Scope
])

A class object can be automatic or static.

*Automatic*: created when the declaration is reached and destroyed when the
  surrounding block is exited.

*Static*: created when the declaration is reached and destroyed when the
  program terminates.

#pad(top: 1cm, [
== Reference Params and `class` Objects
])

Try to pass by reference. Avoid passing by value (creates copy).

#pad(top: 1cm, [
== Operators
])

*Scope Resolution Operator*: `::` used to access functions in a `class`.

*Member Access Operator*: `.` used to access members in a `class`,

#pad(top: 1cm, [
== Accessor and Mutator Functions
])

*Accessor Function*: Member function that only accesses the value(s) of member
variable(s).

*Mutator Function*: Member function that modifies the value(s) of member variable(s).

*Constant Function*:
- Member function that cannot modify member variables of that class.
- Member function heading with `const` at the end.

#pad(top: 1cm, [
== Order of `public` and `private` Members of a Class
])

No defined order, however follow the book's convention of `public` first.

#pad(top: 1cm, [
== Constructors
])

Use constructors to guarantee that member variables are initialized.

Two types:
- Without params (`default` constructors)
- With params

Other properties:
- Name of constructor is the same as the class.
- A constructor has no type.

*`default` Constructor Example*:

```cpp
class StudentType {
  public:
    StudentType();                          // default constructor
    std::string getName() const;
    void setName(std::string name);

  private:
    std::string name;
    std::string id;
    std::string phone;
}

int main() {
  StudentType stu1;
}

// Default constructor implementation
StudentType::StudentType() {
  name = "";
  id = "000";
  phone = "702-000-0000";
}
```

*Parameterized Constructor Example*:
```cpp
class StudentType {
  public:
    StudentType(std::string name, std::string id, std::string phone);
    std::string getName() const;
    void setName(std::string name);

  private:
    std::string name;
    std::string id;
    std::string phone;
}

int main() {
  StudentType stu1("Gael", "5006289777", "702-426-8371");
}
```

*Parameterized Constructor with Default Arguments Example*:

```cpp
class StudentType {
  public:
    StudentType(std::string name = "", std::string id = "000", std::string phone =
    "702-000-0000") {
      name = name;
      id = id;
      phone = phone;
    }
    std::string getName() const;
    void setName(std::string name);

  private:
    std::string name;
    std::string id;
    std::string phone;
}

int main() {
  StudentType stu1("Gael", "5006289777", "702-426-8371");
}
```

Classes *CAN* have more than 1 constructor.
- Each must have  a different formal parameter list (function signature).

Costructors execute automatically when a class object enters its scope.
- They cannot be called like other functions.
- Which constructor executes depends of the types of values passed to the
  `class` object when the `class` object is declared.

#pad(top: 1cm, [
== Constructor Precautions
])

C++ provides a default constructor if a class does not have one.
- Likely to be uninitialized if in-line initialization is not used.

*HOWEVER*, if a class includes constructor(s) with param(s), but not a
`default`:
- C++ does *NOT* provide the `default`.
- Appropriate args must be included when obj is declared.

_If you define any constructor, you *must always* define a `default`
constructor._

#pad(top: 1cm, [
== In-Line Initialization of Data Members and the `default` constructor
])

C++14 standard allows member initializations in class declarations.
- Called in-line initialization of the data members.

When an object is declared without params, then the object is initialized with
the in-line initialized values.
- If declared with params, then the default vals are overriden

*Example:*

```cpp
class ClockType {
  public:
    // ...
  private:
    int hr = 0;
    int min = 0;
    int sec = 0;
}
```

#pad(top: 1cm, [
== Member-Initialized Lists
])

Used to initialize class member variables when a constructor is invoked.
- Use it in the constructor definition.

*Syntax:*

```cpp
className(params): member1(value1), member2(value2) {
  // Constructor body...
}
```

*Example:*

```cpp
StudentType::StudentType(): name(""), id("000"), phone("702-000-0000") {

}
```

Member variables are initialized before the constructor body executes.

Useful for:
- Initializing `const` or `reference` members.
- Efficiently intialzing non-default-constructible objects.

*Example:*

```cpp
class clockType {
  public:
    clockType(int hour, int min, int sec)
    : hr(hour), m(min), s(sec){}
  private:
    int hr;
    int m;
    int s;
}
```

#pad(top: 1cm, [
== Arrays of Class Objects (Variables) and Constructors
])

If you declare an arr of class obects, the class should have a default
constructor.
- Typically used to intialize each (array) class object.
- Classes should *ALWAYS* have a default constructor.

If a class has a user-defined constructor, the default constructor is not
implicitly declared.

#pad(top: 1cm, [
== Destructors
])

*Destructors* are functions without any types.
- A class can have only one destructor (has no params).
- The name of the destructor is `~className`.
- Automatically executes when the class object goes out of scope.
- Should *NEVER* be invoked directly.
