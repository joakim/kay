# Kay

![K in Blade Runner 2049, seen from the back walking into an orange haze](https://i.imgur.com/uakY6W8.jpg)

A simple message-based programming language inspired by [Smalltalk](http://smalltalk.org/), [Self](https://selflanguage.org/), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state), [sci-fi](https://maidenpublishing.co.uk/review/bladerunner/) and [biology](https://en.wikipedia.org/wiki/Cell_(biology)).

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
hello: '(name)' => {
    return: "hello, {name}!"
}

print « hello "world"  --> "hello, world!"
```

<br/>

## Cells

It's cells all the way down, from environment to values. Cells encapsulate slots, expressions and receptors, and communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Messages are dynamically matched against the signatures of the cell's [receptor](https://en.wikipedia.org/wiki/Cell_surface_receptor) methods. A receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of a received message and for producing a response.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)) ([phenotypes](https://en.wikipedia.org/wiki/Phenotype)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded.

Cells are by default [encapsulated and opaque](https://en.wikipedia.org/wiki/Information_hiding). The internal state may only be accessed from the outside through setter and getter messages, unless marked as exposed. Exceptions are handled internally, a cell can not crash.

Cells are [first-class](https://en.wikipedia.org/wiki/First-class_function) [reference types](https://en.wikipedia.org/wiki/Value_type_and_reference_type) that are [passed by value](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_value), with [lexical closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)). They are [persistent data structures](https://en.wikipedia.org/wiki/Persistent_data_structure#Persistent_hash_array_mapped_trie), the "[observer](https://en.wikipedia.org/wiki/Observer_(quantum_physics))" of a cell gets a fixed "view" of the cell's state as it was at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that view for the observer, based on structural sharing of its past variants. Cells may subscribe to each other, enabling [reactivity](https://en.wikipedia.org/wiki/Reactive_programming#Object-oriented).

<br/>

<b title="Too long; didn't read">TL;DR:</b> A cell is the synthesis of record, method and block, implemented as a first-class reference type with built-in persistence, communicating by message signaling. Encapsulated, opaque and safe. The runtime is the stem.

<br/>

## Slots

Slots hold the cell's state. Slots are read-only, unless explicitly marked as writable. They are only accessible from the current and any nested scopes, unless the cell is marked as exposed. Slots are similar to block-scoped variables or object properties in other languages.

<br/>

## Messages (expressions and signals)

Everything is an expression.

An expression contains one (or more) message signal(s) and evaluates to the (last) signal's return value.

A signal is a message sent to a receiver cell. Expressions are used to include values as arguments in the message.

There are no variables or statements, only cells (senders and receivers) with slots (state) and expressions (message signals).

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
  - `[]`   – static array  
  - `*{}` – exposed cell (record/object/structure/dictionary)  
  - `*[]` – dynamic array (list/sequence)  

<br/>

## Syntax

### Operators

#### Literals

  - `{}`  cell  
  - `[]`  array  
  - `""`  string  
  - `=>`  method  
  - `->`  block  
  - `true`  
  - `false`  
  - `nothing`  

#### Messaging

  - `''`  message definition  
  - `()`  message parameter, expression  

#### Flow

  - `|`   pipeline ("then")  
  - `»`   compose forward ("into")  
  - `«`   compose reversed  
  - `,`   expression separator  

#### Other

  - `*`   writable, exposed ("star")  
  - `_`   ignore, any ("blank")  
  - `--` comment  

<!--
#### Cell types

- **Record** cells are not executable
- **Method** cells are executable, take arguments and return values
- **Block** cells are executable, but can not take arguments or return values
-->

<br/>

## Examples

Sending a message to a cell:

`receiver` `message with an (argument)`

A message is a sequence of Unicode words that may contain arguments. The message forms a signature that the receiving cell's receptors are matched against. Arguments (expressions in parentheses) are evaluated and attached to the message before it is sent. Literals may be used verbatim, without parenthesis.

A message expression ends when a flow operator, binary operator, matching right parenthesis, end of line or comment is encountered.

For example, to log to the console:

```lua
console log "hello, world"
```

This sends a `log "hello, world"` message to the `console` cell, matching its `log (value)` receptor, writing the value to the console's output.

Slot assignment is done by (implicitly) sending a setter message to the current cell (`self`):

```lua
answer: 42

-- is really:
self answer: 42
```

This message matches the `(key): (value)` receptor of the cell, setting the cell's `answer` slot to `42`. Assignment messages are special in that anything following the `:` is desugared into an expression, evaluating it to return a value.

In order to use a slot as an argument in a regular message, it must be wrapped in `()`, evaluating it before the message is sent:

```lua
console log (answer)
```

A cell's receptor is defined as a message signature (`''`) tied to a cell containing expressions. The receptor's cell may have its own slots (local state), and return a value by assigning to it's own `return` slot:

```lua
host: {
    'greet (name)' {
        greeting: "Hey, {name}!"
        return: greeting
    }
}

host greet "Joe"  --> "Hey, Joe!"
```

A method (`=>`) is simply syntactic sugar for a 1-receptor cell. Here's the `host` above as a method:

```lua
host: 'greet (name)' => {
    greeting: "Hey, {name}!"
    return: greeting
}
```

An inline method implicitly returns the result of its expression. Here's the `host` method as a one-liner:

```lua
host: 'greet (name)' => "Hey, {name}!"
```

Slots are lexically scoped. When assigned to a slot, a method become a local function of the cell it's defined in and any of its nested cells:

```lua
double: '(number)' => number * 2

nested: {
    cell: {
        double 21  --> 42
    }
}
```

A block (`->`) is syntactic sugar for a cell containing expressions, but lacking a receptor. They therefore can't receive messages or return values, even when inlined. But they do have closure, making them useful when passed as arguments in messages, easily emulating control flow statements. Like this equivalent to an `if-then-else` statement:

```lua
answer = 42  --> true
    | if true -> marvin shrug
    | if false -> marvin despair
```

That's one expression of three messages, pipelined. First `= 42` is sent to the `answer` slot, returning `true`, before `then` and `else` act on the result in turn. They are chaining methods, evaluating their passed inline block only if the boolean's value is `true`/`false` (respectively), before returning the boolean for further chaining.

Expressions are evaluated left-to-right, so when passing the result of an expression as an argument, or to ensure correct order of evaluation, the expression must be wrapped in `()`:

```lua
console log ((answer = 42) "Correct" if true else "You are mistaken")
```

This quickly becomes cumbersome. To avoid parenthitis (also known as LISP syndrome), the use of flow operators `|` (pipeline), `»` (compose forward) and `«` (compose reverse) is prescribed:

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

The two styles can be combined as shown earlier (the compose operators have precedence):

```lua
10 double | negate » print  -- sugar
print « 10 double | negate  -- sugar (equivalent)

print ((10 double) negate)  -- desugared
```

For more examples, see [examples.md](examples.md).

<br/>

## What it brings

The language offers a small set of easy to understand concepts and a simple syntax, yet should be capable of implementing most constructs typically found in high-level programming languages, while remaining truly multi-paradigm.

It should even be possible to translate the global cells and methods into other natural languages than English, enabling developers to code in their native language. Combined with its simplicity and flexibility, this could be a powerful tool for teaching programming to kids worldwide, true to [the spirit of Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf).

<br/>
<br/>
<br/>

<p align="center"><sup>Made in Norway, the land of Simula</sup></p>
