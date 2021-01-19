# Kay

<!-- ![K in Blade Runner 2049, seen from the back walking into an orange haze](https://i.imgur.com/uakY6W8.jpg) -->

A simple message-based programming language inspired by [Smalltalk](https://www.codeproject.com/Articles/1241904/Introduction-to-the-Smalltalk-Programming-Language), [Self](https://selflanguage.org/), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state), [sci-fi](https://maidenpublishing.co.uk/review/bladerunner/) and [biology](https://en.wikipedia.org/wiki/Cell_(biology)).

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
hello: name => "hello, {name}!"

print « hello "world"  --> "hello, world!"
```

<br/>

## Cells

It's cells all the way down, from environment to values. Cells encapsulate fields, expressions and receptors, and communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Messages are matched against the signatures of the receiving cell's [receptors](https://en.wikipedia.org/wiki/Cell_surface_receptor). The receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of a received message and for producing a response.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded, however.

Cells are by default [encapsulated and opaque](https://en.wikipedia.org/wiki/Information_hiding). Their internal state may only be accessed from the outside through messaging. Any exceptions are handled internally, a cell can not crash the system.

Cells are [first-class](https://en.wikipedia.org/wiki/First-class_citizen) [reference types](https://en.wikipedia.org/wiki/Value_type_and_reference_type) that are [passed by value](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_value). They have [lexical closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)) and may [observe](https://en.wikipedia.org/wiki/Observer_pattern) each other, enabling [reactivity](https://en.wikipedia.org/wiki/Reactive_programming#Object-oriented).

<br/>

**Summary:** A cell is the consolidation of object, function and block, implemented as a first-class reference type, communicating by messaging. Encapsulated and safe. Reactive. The runtime is the stem.

<br/>

## Fields

Fields hold the cell's internal state. Fields are read-only, unless explicitly marked as writable. They are lexically scoped, only accessible from the current and any nested scopes.

<br/>

**Summary:** Fields are the consolidation of block-scoped variables and object properties.

<br/>

## Messages (expressions and signals)

An expression contains one (or more) message signal(s) and evaluates to the (last) signal's return value.

A signal is a message sent to a cell. Expressions are used to include values as arguments in message slots. Messages are dynamically dispatched.

There are no statements, only cells (senders and receivers) with fields (state) and expressions (message signals).

<br/>

**Summary:** Everything is an expression, and every expression is a message (or messages) sent.

<br/>

## Data types

Preliminary data types.

#### Primitive

  - `nothing` – bottom value (a cell that only ever returns itself)
  - `boolean` – `true` or `false`
  - `number` – IEEE 754 64-bit double-precision floating-point?
  - `string` – UTF-8?

#### Composite

  - `{}`   – cell
  - `[]`   – collection (indexed/associative array)

Collection is the consolidation of indexed array (list/vector) and associative array (object/dictionary/structure), similar to Lua's tables. Collections are implemented as [persistent data structures](https://en.wikipedia.org/wiki/Persistent_data_structure#Persistent_hash_array_mapped_trie). An "[observer](https://imgur.com/iMf3GBa)" of a collection gets a [snapshot](https://en.wikipedia.org/wiki/Snapshot_(computer_storage)) of its state at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a collection results in a new local variant based on that snapshot, with structural sharing of its past states.

<br/>

## Syntax

### Literals

  - `{}`  cell
  - `[]`  collection
  - `""`  string
  - `=>`  function
  - `->`  block
  - `''`  message definition
  - `()`  message parameter, expression
  - `true`
  - `false`
  - `nothing`

### Operators

#### Flow

  - `|`   pipeline
  - `»`   compose left-to-right
  - `«`   compose right-to-left
  - `,`   expression separator
  
#### Binary

  - Logical: `and`, `or`
  - Equality: `=`, `≠`
  - Relational: `<`, `>`, `≤`, `≥`
  - Arithmetic: `+`, `-`, `×`, `/`

#### Other

  - `*`   writable ("star")
  - `_`   match any, ignore ("blank")
  - `--` comment

A binary operator results in a signal to the left-hand side with one argument, the right-hand side. A set of symbols are reserved for future operators.

<!--
#### Cell types

- **Object** cells are not executable
- **Function** cells are executable, take arguments and return values
- **Block** cells are executable, but can not take arguments or return values
-->

<br/>

## Examples

A cell is defined with the `{}` literal:

```lua
name: {
    -- expressions
}
```

Sending a message to a cell:

`receiver` `message with a (slot)`

A message is a sequence of Unicode words that may contain slots (arguments). The message forms a signature that the receiving cell's receptors are matched against. Slots are evaluated and attached to the message before it is sent. Literals may be used verbatim, without parenthesis.

A message expression ends when a flow operator, binary operator, matching right parenthesis, end of line or comment is encountered.

For example, to log to the console:

```lua
console log "hello, world"
```

This sends a `log "hello, world"` message to the `console` cell, matching its `log (value)` receptor, writing the value to the console's output.

Assignment is done by (implicitly) calling the `set` function on the current cell:

```lua
answer: 42

-- is really:
set "answer": (42)  --> 42
```

Assignment messages are syntactic sugar, anything before the `:` gets desugared into a string and anything after gets desugared into an expression. The above example sets the cell's `answer` field to `42` (a `Number` cell). 

A function is defined as a message signature (`''`) tied (`=>`) to a cell (`{}`). The function's cell may have its own fields (local state), and may return a value by assigning to its `return` field:

```lua
greet: '(name)' => {
    greeting: "Hey, {name}!"
    return: greeting
}

-- applying the function:
greet "Joe"  --> "Hey, Joe!"
```

An inline function implicitly returns the result of its expression. If the message consists of just a single argument slot, the signature can be reduced to just that slot. Here's the above function as a one-liner:

```lua
greet: name => "Hey, {name}!"
```

When a function is assigned to a field, it becomes a local function of that cell and any of its nested cells:

```lua
greet: name => "Hey, {name}!"

nested: {
    cell: {
        greet "Joe"  --> "Hey, Joe!"
    }
}
```

A receptor is a function that's defined directly on a cell, not assigned to any field. Here's the `greet` function as a receptor:

```lua
host: {
    'greet (name)' => "Hey, {name}!"
}

-- sending the message 'greet "Joe"' to the `host` cell:
host greet "Joe"  --> "Hey, Joe!"
```

A block (`->`) is syntactic sugar for a cell containing expressions, but lacking a receptor. It therefore can't receive messages or return values, even when inlined. But blocks do have closure, making them useful in message slots, easily emulating control flow statements. Like this equivalent to an `if-then-else` statement:

```lua
answer = 42
    | if true -> marvin shrug
    | if false -> marvin despair
```

That's one expression of three messages, pipelined. First `= 42` is sent to the `answer` field, returning `true`, before `if true` and `if false` act on the result in turn. Each evaluate their passed block only if the boolean's value is `true`/`false` (respectively), before returning the boolean for further chaining.

Expressions are evaluated left-to-right, so when passing the result of an expression in a message slot, or to ensure correct order of evaluation, the expression must be wrapped in `()`:

```lua
console log ((answer = 42) "Correct" if true else "You are mistaken")
```

This quickly becomes cumbersome. To avoid parenthitis (also known as LISP syndrome), the use of flow operators pipeline (`|`) and compose (`«` or `»`) is prescribed:

```lua
console log « answer = 42 | "Correct" if true else "You are mistaken"
```

The pipeline operator is best suited to an object-oriented style of programming (sending messages to objects):

```lua
10 double | negate | print  -- sugar

((10 double) negate) print  -- desugared
```

While the compose operators are best suited to a functional programming style (applying functions to values):

```lua
double 10 » negate » print  -- sugar
print « negate « double 10  -- sugar (equivalent)

print (negate (double 10))  -- desugared
```

The two styles can be combined (the compose operators have higher precedence):

```lua
10 double | negate » print  -- sugar
print « 10 double | negate  -- sugar (equivalent)

print ((10 double) negate)  -- desugared
```

[More examples](examples/)

<br/>

## What it brings

The language offers a small set of easy to understand concepts and a simple syntax, yet should be capable of implementing most constructs typically found in high-level programming languages, while remaining truly multi-paradigm.

It should even be possible to translate the globals into other natural languages than English, enabling developers to code in their native language. With its simplicity and flexibility, my hope is that this could be a powerful tool for teaching programming to kids worldwide, true to [the spirit of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/#smalltalkAndChildren).

<br/>
<br/>

<p align="center"><sup>Made in the land of Simula</sup></p>
