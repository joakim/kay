# Kay

<!-- ![K in Blade Runner 2049, seen from the back walking into an orange haze](https://i.imgur.com/uakY6W8.jpg) -->

A simple message-based programming language inspired by [Smalltalk](https://learnxinyminutes.com/docs/smalltalk/), [Self](https://selflanguage.org/), [Erlang](https://en.wikipedia.org/wiki/Erlang_(programming_language)), [Clojure](https://clojure.org/about/state), [sci-fi](https://www.moremountains.net/film-analysis/2020/7/3/interlinked-within-cells) and [biology](https://en.wikipedia.org/wiki/Cell_(biology)).

<br/>

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.

– Alan Kay

<br/>

> The basic principle of recursive design is to make the parts have the same power as the whole.

– Bob Barton

<br/>

> A system of cells interlinked within cells interlinked within cells interlinked within one stem.

– K, Blade Runner 2049 (Vladimir Nabokov, Pale Fire)

<br/>

```lua
-- method definition
hello: '(name)' -> "hello, {name}!"

-- message pipeline
hello "world" | print

--> "hello, world!"
```

<br/>

## Cells

Cells encapsulate fields (state), receptors (methods) and messages (expressions), and communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Messages are matched against the signatures of the receiving cell's [receptors](https://en.wikipedia.org/wiki/Cell_surface_receptor). The receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of a received message and for producing a response.

There are no classes, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29) (by [concatenation](https://en.wikipedia.org/wiki/Prototype-based_programming#Concatenation)/[mixin](https://en.wikipedia.org/wiki/Mixin) or [delegation](https://en.wikipedia.org/wiki/Prototype-based_programming#Delegation)), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)). The ancestors and descendants of a cell is recorded.

Cells are [encapsulated](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)), their internal state may only be accessed from the outside through messaging, with [capability-based](https://en.wikipedia.org/wiki/Object-capability_model) security. Exceptions are handled internally, a cell should not be able to crash the system.

Cells are [first-class](https://en.wikipedia.org/wiki/First-class_citizen) [reference types](https://en.wikipedia.org/wiki/Value_type_and_reference_type) that are [passed by value](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_value). They have [lexical closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)) and may [observe](https://en.wikipedia.org/wiki/Observer_pattern) each other, enabling [reactivity](https://en.wikipedia.org/wiki/Reactive_programming#Object-oriented).

<br/>

**Summary:** A cell is the consolidation of object, function and block, implemented as a first-class reference type, communicating by messaging. Encapsulated and safe.

<br/>

## Fields

Fields hold the cell's internal state. Fields are read-only, but the bound value may be writable. Fields are lexically scoped, only directly accessible from the current and any nested scopes.

<br/>

**Summary:** Fields are the consolidation of block-scoped variables and object properties.

<br/>

## Messages

An expression contains one (or more) literal(s) or signal(s). If comma separated, it evaluates to the result of the last item.

A signal is a message sent to a cell. Expressions are used to include values as arguments in message slots. Messages are [dynamically dispatched](https://en.wikipedia.org/wiki/Dynamic_dispatch), with the ability to support [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch).

There are no statements, only cells (senders and receivers) and expressions (message signals).

<br/>

**Summary:** Everything is an expression, and every expression is the sending of a message (or messages).

<br/>

## Data types

#### Reference types

  - `{}`   – cell
  - `nothing` – bottom value (a cell that only ever returns itself)

#### Value types

  - `boolean` – `true` or `false`
  - `number` – IEEE 754 64-bit double-precision floating-point?
  - `string` – UTF-8?
  - `[]`   – collection  
  
Collection is the consolidation of indexed array (list/vector) and associative array (object/dictionary/structure), similar to Lua's [tables](https://en.wikipedia.org/wiki/Lua_(programming_language)#Tables). Collections are implemented as [persistent data structures](https://en.wikipedia.org/wiki/Persistent_data_structure#Persistent_hash_array_mapped_trie).

<br/>

## Values

Value types are immutable. If marked as writable, the value will be wrapped in a `Value` cell, similar to Clojure's [atoms](https://clojure.org/reference/atoms). This allows management of state over time, while enabling validation and subscription to events.

[Observing](https://imgur.com/iMf3GBa) a `Value` will automagically dereference it, returning a snapshot of its current state (value). [Mutating](https://en.wikipedia.org/wiki/Mutation) a `Value` will [swap](https://clojure.github.io/clojure/clojure.core-api.html#clojure.core/swap!) the old immutable value for a new one. Collections use structural sharing of past states.

<br/>

## Syntax

### Literals

  - `{}`  cell
  - `[]`  collection
  - `42`  number
  - `""`  string
  - `''`  message definition
  - `()`  message parameter, expression
  - `->`  method
  - `true`
  - `false`
  - `nothing`

### Operators

#### Flow

  - `|`   pipeline
  - `»`   compose left-to-right
  - `«`   compose right-to-left
  - `,`   expression separator
  
#### Various

  - `*`   mutable
  - `_`   ignore/any ("blank")
  - `\`   escape
  - `--` comment

#### Binary

  - Logical: `and`, `or`
  - Equality: `=`, `≠`
  - Relational: `<`, `>`, `≤`, `≥`
  - Arithmetic: `+`, `-`, `×`, `/`
  - Access: `.`

A binary operator results in a signal to the left-hand side with one argument, the right-hand side. A set of symbols are reserved for future operators.

<br/>

## Examples

#### Cells and messaging

A cell is defined with the `{}` literal:

```lua
cell: {
    -- expressions
}
```
<!--
Alternatively, one can use indentation, similar to Python. The following examples will use this style:

```lua
cell:
    -- expressions
```
-->
Expressions are messages sent to cells. To send a message:

`cell` `message with a (slot)`

A message is a sequence of Unicode words that may contain slots (arguments). The message forms a signature that the receiving cell's receptors are matched against. Slots are evaluated and attached to the message before it is sent. Literals may be used verbatim, without parenthesis.

An expression ends when a flow operator, binary operator, matching right parenthesis, end of line or comment is encountered.

For example, to log to the console:

```lua
console log "hello, world"
```

This sends a `log "hello, world"` message to the `console` cell, matching its `log (value)` receptor, writing the value to the console's output.

#### Fields

Assignment is done by (implicitly) sending a message to the current cell, `self`:

```lua
answer: 42

-- is really
self answer: 42
```

This defines an `answer` field with a value of `42` on the current cell.

A field may be defined as mutable by appending a `*`:

```lua
active: false *

-- mutate its value
active set true
```

This creates a reference type containing the specified value, similar to [Clojure's atoms](https://clojure.org/reference/atoms).

#### Methods and receptors

A method is defined as a message signature `''` tied `->` to a cell `{}`. The method's cell may have its own fields (local state), and may return a value by assigning to its `return` field:

```lua
greet: '(name)' -> {
    greeting: "Hey, {name}!"
    return: greeting
}

-- calling the method (sending a message, "Joe", to the greet method)
greet "Joe"  -- "Hey, Joe!"
```

An inline method implicitly returns the result of its expression. Here's the above method as a one-liner:

```lua
greet: '(name)' -> "Hey, {name}!"
```

Fields are lexically scoped. A method is available within the cell it's defined in and any nested cells:

```lua
greet: '(name)' -> "Hey, {name}!"

nested: {
    cell: {
        greet "Joe"  -- "Hey, Joe!"
    }
}
```

A receptor can be thought of as a method defined directly on a cell, not assigned to any field. Here's the `greet` method as a receptor on a cell named `host`:

```lua
host: {
    'greet (name)' -> "Hey, {name}!"  -- the receptor
}

-- sending the message 'greet "Joe"' to the host cell
host greet "Joe"  -- "Hey, Joe!"
```

Methods can also be passed as values (lambdas) in slots. Because methods have closure, they can emulate control flow statement blocks of traditional languages. Here is the equivalent of an `if-then-else` statement using methods without arguments serving as block statements:

```lua
marvin: ParanoidAndroid {}

answer = 42
    if true -> {
        marvin shrug
        marvin say "Only if you count in base 13"
    }
    else -> marvin despair
```

Having higher precedence, the binary message `= 42` is first sent to `answer`, resulting in a boolean (`true`), which is then sent the `if (condition) (true-block) else (false-block)` message. The message is split over several lines (indented) to improve readability. Inline method literals are passed in the `true-block` and `false-block` slots, to be evaluated by the receptor. Because methods have closure, this effectively emulates block statements in imperative languages.

<!--That's one expression of three messages pipelined. First `= 42` is sent to the `answer` field, returning `true`, before `is true` and `is false` act on the result in turn. Each evaluate their passed method only if the boolean's value is `true`/`false` (respectively), before returning the boolean for further chaining.-->

#### Evaluation operators

Expressions are evaluated left-to-right, with binary operators having higher precedence than regular messages. To ensure correct order of evaluation, improve readability, or to use an expression in a slot, wrap the code in `()`:

```lua
guess: 3 × (7 + 7)
console log ((guess = answer) "Correct" if true else "You are mistaken")
```

Nested parentheses can become tedious. To improve readability and prevent parenthitis (also known as LISP syndrome), use of the flow operators pipeline (`|`) and compose (`«` or `»`) is prescribed:

```lua
console log « guess = answer | "Correct" if true else "You are mistaken"

-- Comparison
a | b | c = ((a) b) c
a « b « c = a (b (c))
a » b » c = c (b (a))
```

The pipeline operator is suitable for chaining messages ([fluent interface](https://en.wikipedia.org/wiki/Fluent_interface)):

```lua
10 double | negate | print  -- sugar

((10 double) negate) print  -- desugared
```

While the compose operators are suitable for a more functional style:

```lua
count » increment » console log  -- sugar
console log « increment « count  -- sugar (equivalent)

console log (increment (count))  -- desugared
```

The two styles can be combined (the compose operators having higher precedence):

```lua
10 double | negate » console log  -- sugar
console log « 10 double | negate  -- sugar (equivalent)

console log ((10 double) negate)  -- desugared
```

<br/>

## What it brings

The language offers a small set of easy to understand concepts with a simple syntax, yet should be capable of implementing most constructs typically found in high-level programming languages, while remaining truly multi-paradigm.

<br/>

## Contributions

Like what you see? Got any ideas or constructive criticism? Feel free to [open an issue](https://github.com/joakim/kay/issues/new). This language is still in its early stages of design. Contributions are always welcome, this was not intended to be a solo project :)

[Ideas...](ideas.md)

[More examples...](examples/)

<br/>
<p align="center"><sup>From the land of Simula</sup></p>
