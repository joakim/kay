# Kay

A simple message-based programming language inspired by [Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf), [Self](https://selflanguage.org/), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state) and [Blade Runner](https://maidenpublishing.co.uk/review/bladerunner/).

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

```elixir
hello: [(name)] => {
    return: 'hello, {name}!'
}

print « hello 'world'  --> 'hello, world!'
```

<br/>

## Cells

It's cells all the way down, from environment to values. Cells encapsulate slots, expressions and receptors, and communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Signals are dynamically matched against the signatures of the cell's [receptor](https://en.wikipedia.org/wiki/Cell_surface_receptor) methods. A receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of a received signal and for producing a response.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)) ([phenotypes](https://en.wikipedia.org/wiki/Phenotype)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded.

Cells are by default encapsulated and opaque. The internal state may only be accessed from the outside through setter and getter signals, unless slots are explicitly exposed. Exceptions are handled internally, a cell can not crash.

Cells are first-class reference types that are passed by value, with lexical closure. They are persistent data structures, the "[observer](https://en.wikipedia.org/wiki/Observer_(quantum_physics))" of a cell gets a fixed "view" of the cell's state as it was at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that view for the observer, based on structural sharing of its past variants. Cells may subscribe to each other, enabling reactivity.

<!--
#### Cell types

- **Record** cells are not executable
- **Method** cells are executable, take arguments and return values
- **Block** cells are executable, but can not take arguments or return values
-->

#### Slots

Slots hold the cell's internal state. They are immutable, unless explicitly marked as mutable, and only accessible from the current and any nested scopes, unless explicitly marked as exposed. Slots are similar to block-scoped variables or object properties in other languages.

<br/>

<b title="Too long; didn't read">TL;DR:</b> A cell is the synthesis of record, method and block, implemented as a first-class reference type with built-in persistence, communicating by message signaling. Encapsulated, opaque and safe. The runtime is the stem.

<br/>

## Syntax

Everything is an expression. There are no statements or variables, only cells and messages.

Syntax for sending a message to a cell:

`cell` `message with an (argument)`

The message is a sequence of words lasting until a pipe operator, closing bracket, comment or end of line is encountered. It can contain arguments and expressions, and form a signature that the receiving cell's receptors are matched against.

For example, to log to the console:

```smalltalk
console log 'hello, world'
```

This sends a `log 'hello, world'` message to the `console` cell, matching its `log (value)` receptor:

```smalltalk
console: {
    [log (value)] => `console.log(value)`
}
```

Slot assignment is done by sending a setter message, implicitly sent to the current cell:

```smalltalk
answer: 42
```

This message matches the `(key): (value)` receptor of the cell, setting the cell's `answer` slot to `42`. Assignment messages are special in that anything following the `:` is evaluated as an expression.

Using a slot as an argument in a message is otherwise done by wrapping it in `()`, evaluating it before the message is sent:

```smalltalk
console log (answer)
```

Methods can be assigned to slots, becoming a local function in the current and any nested scopes. Returning a value is done by assignment to the cell's `return` slot:

```smalltalk
double: [(number)] => {
    return: number * 2
}

double 21  --> 42
```

Blocks can form part of messages and emulate control flow statements, as this equivalent to an if-then-else statement shows:

```smalltalk
answer = 42
    | then -> {
        console log 'Correct'
        marvin shrug
    }
    | else -> marvin despair
```

Technically, that is three messages. First `= 42` is sent to the `answer` slot, returning `true`, before `then` and `else` act on the boolean in turn. They are chaining methods, evaluating the passed block only if the boolean is `true` or `false`, respectively, returning the boolean. `else` is passed an inline block.

Messages may also include expressions wrapped in `()`, as this conditional shows:

```smalltalk
console log (answer = 42 | if true => 'Correct' | if false => 'You are mistaken')
```

Kay's syntax offers a small number of easy to understand concepts, capable of implementing most constructs typically found in high-level programming languages.

### Operators

#### Literals

`{}` cell  
`[]` array, message definition  
`=>` method  
`->` block  
`""` string  
`--` comment

#### Flow

`|` pipe backward  
`«` pipe backward (or `<<`)  
`»` pipe forward (or `>>`)  
`()` evaluation, message argument  

#### Other

`,` separator  
`*` mutable, exposed  
`_` wildcard, ignore

<br/>

## Examples

<sup>Note: This is mainly an exploration of possibilities. Consider it [Readme Driven](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) Programming Language Design. The following examples use Smalltalk syntax highlighting, strings are therefore enclosed in `''` and comments in `""`. Comments should really be like [Haskell's](https://wiki.haskell.org/Commenting) `--`. `-->` signifies output.</sup>

### Blade Runner

```smalltalk
"create a Replicant cell"
Replicant: {
    "slots (`name` is marked as mutable)"
    *name: 'Replicant'
    model: 'Generic'
    
    "receptor method (responds to messages from the outside)"
    [move (distance)] => {
        meters: distance = 1 | 'meter' if true else 'meters'
        print '{name} the {model} replicant moved {distance} {meters}'
    }
    
    "local method (assigned to a slot)"
    say: [(words)] => {
        print '{name} says: {words}'
    }
}

"create a Nexus9 cell by cloning and extending the Replicant cell"
Nexus9: Replicant with {
    replicant: self
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []
    
    think: [(thought)] => {
        "send an `append` message to the `thoughts` array with the `thought` argument's value"
        thoughts append (thought)
        print '{name} thinks: {thought}'
    }
    
    [move] => {
        print '*moves*'
        
        "signal the `move (distance)` receptor cloned from `Replicant`"
        replicant move 2
        
        "signal receptors of the boolean result of `>`, equivalent to an if statement"
        intelligence > 100
            | then -> {
                think 'Why did I move?'
                think 'Am I really a replicant?'
                think 'My name is Joe...'
                
                "mutate the state of an outer cell"
                replicant name: 'Joe'
                say 'My name is {name}!'
            }
            | else -> think '*crickets*'
    }
}

"create a new Nexus 9 replicant"
officer-k: Nexus9 with { name: 'K', intelligence: 140 }

"signal its `move` receptor"
officer-k move

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'K thinks: Why did I move?'
--> 'K thinks: Am I really a replicant?'
--> 'K thinks: My name is Joe...'
--> 'Joe says: I have a purpose!'
```

<br/>

### Features

Everything is a cell: `Environment > Modules > (Cells > Cells...) > Values`

```smalltalk
"literal for a record cell"
record-literal: {}

"a record cell with a slot (object with a private property in other languages)"
record-example: {
    answer: 42
}

"literal for a block cell (compound statements or closure in other languages)"
block-literal: -> { … }

"a block cell sent as an argument to the `then` receptor of `Boolean`"
block-example: true | then -> {
    truth: 'It is true'
    print (truth)
}

"literal for a method cell (function or private method in other languages)"
method-literal: [] => { … }

"a method cell that receives a message, prints its argument and returns a string"
method-example: [(argument)] => {
    print (argument)
    return: 'argument was {argument}'
}

"an inlined method cell, having implicit `return` (lambda in other languages)"
method-inlined: [(argument)] => true

"literal for a receptor method (similar to object method in other languages)"
"a receptor is simply a method that is not assigned to a slot"
[foo (bar)] => { … }

"a receptor method illustrating how messages are used"
[receptor with one (argument)] => {
    "messages are flexible text patterns that may contain arguments"
    "arguments are enclosed in `()`, the matched value will be bound to a slot of that name"
    "the syntax could be extended to support typed arguments"
    
    "`()` is similarly used to interpolate expressions (also slots) when sending messages"
    print (argument)
    
    "`{}` is used to interpolate expressions (also slots) in strings"
    print 'argument is {argument}'
}

"a method cell without arguments (equivalent to a function expression with no arguments)"
method: => {
    a: 2
    b: 3
    result: a + b
    print '{a} + {b} = {result}'
    return: result
}

"calling the method using `do` (an environment method)"
result: do (method)  --> '2 + 3 = 5'
print (result)       --> 5

"a mutable record with all slots exposed, marked with `*` (object/struct/dict in other languages)"
mutable: *{
    foo: 42
    bar: true
}

"mutating slots from outside the cell"
"setters return the cell itself, enabling chaining of messages"
mutable (foo: 10) (bar: false)

"simpler syntax using the pipe operator"
mutable foo: 10 | bar: false

"looks great when multiline (fluent interface)"
mutable
    | foo: 10
    | bar: false

"mutating a slot by referencing its name using a local slot's value"
key: 'foo'
mutable (key): 42

"a record cell with a mutable slot (only mutable from within)"
mutable-slot: {
    cell: self
    *bar: true
    
    [mutate] => {
        cell bar: false
    }
}
mutable-slot mutate

"slots are block scoped and may be shadowed by nested cells"
scoped: {
    inner: 42
    
    nested: {
        [answer] => {
            original: inner       --> "42 (a clone of `inner`)"
            inner: 'shadowed'     --> "'shadowed' (a new, local slot)"
            return: original
        }
    }
    
    [answer] => nested answer
}

"expressions can be grouped/evaluated with `()` and messages piped/chained with `|`"
print (scoped answer = 42 | 'Indeed' if true)  --> 'Indeed'

"a method demonstrating closure"
adder: [(x)] => {
    return: [(y)] => {
        return: x + y
    }
}

add-5: adder 5
add-10: adder 10

print (add-5 2)   --> 7
print (add-10 2)  --> 12

"inlined version of the `adder` method"
inlined: [(x)] => [(y)] => x + y

"as in the self language, assignment is really implicit setter signals on the current cell (`self`)"
foo: 42
self foo: 42  -- "the two are equivalent"

"setters are special, what follows `:` is evaluated as an expression, `()` is not needed"
bar: foo

print (bar)  --> 42
```

<br/>

### Building blocks

> The cell is the basic structural, functional, and logical unit of all known programs. A cell is the smallest unit of code. Cells are often called the "building blocks of code".

<sup>Paraphrased from the Wikipedia article on [Cell (biology)](https://en.wikipedia.org/wiki/Cell_(biology)).</sup>

```smalltalk
"the void type is a special cell that only ever returns itself"
{}: { [_] => self }

"all other cells descend from the base Cell"
Cell: {
    cell: self
    lineage: [{}]
    exposed: {}
    
    "slot initialization"
    set: [(key): ...(value)] => `Reflect.set(cell, key, value)`
    
    "exposed slot initialization (`*`) is syntactic sugar for this method"
    expose: [(key): ...(value)] => exposed (key): value
    
    "clones itself (matches an empty message)"
    [] => {
        clone: `Object.assign(Object.create(null), cell)`
        
        "append a reference to itself as the parent of the clone"
        `clone.lineage.push(WeakRef(cell))`
        
        return: clone
    }
    
    "clones itself, merging with the specified cell(s), enabling composition of multiple cells"
    [with (spec)] => {
        clone: cell
        
        "merge slots into the clone"
        merge: [(slots)] => {
            slots each [(key) (value)] => `Reflect.set(clone, key, value)`
        }
        
        "if merging with an array of cells, merge each cell in turn"
        spec (is array)
            | then -> spec each [(item)] => merge (item)
            | else -> merge (spec)
        
        return: clone
    }
    
    "returns the cell's lineage"
    [lineage] => lineage
    
    "exposed slot checker"
    [has (key)] => `Reflect.has(cell.exposed, key)`
    
    "exposed slot getter"
    [(key)] => (cell is mutable) or (cell has (key)) | `Reflect.get(cell.exposed, key)` if true
    
    "exposed slot setter (returns itself, enabling piping/chaining)"
    [(key): (value)] => {
        (cell is mutable) or (cell has (key))
            | if true -> `Reflect.set(cell.exposed, key, value)`
        return: cell
    }
    
    "conditionals (replaces if statements, any cell can define its own truthy/falsy-ness)"
    [then (implication)] => cell if true (implication)
    [else (implication)] => cell if false (implication)
    [if true (implication)] => `(cell ? do(implication) : undefined) ?? cell`
    [if false (implication)] => `(cell ? undefined : do(implication)) ?? cell`
    [(value) if true] => `cell ? value : undefined`
    [(value) if false] => `cell ? undefined : value`
    [(value-1) if true else (value-2)] => `cell ? value-1 : value-2`
    [(value-1) if false else (value-2)] => `cell ? value-2 : value-1`
    
    "returns whether the cell has all exposed slots"
    [is exposed] => Boolean (exposed size)
    
    "checks whether the cell has a receptor matching the signature"
    [has receptor (signature)] => `cell.hasReceptor(signature)`
    
    "applies a receptor of this cell to another cell"
    [apply (message) to (other)] => `Reflect.apply(cell, other, message)`
}

"definition of the Value cell"
Value: {
    cell: self
    
    "internal value and its validators, preprocessors and subscribers"
    value: {}
    validators: []
    preprocessors: []
    subscribers: {}
    
    "local setter method for mutating the internal value"
    set: [(value)] => {
        "validate and preprocess..."
        `(cell.value = value, cell)`
    }
    
    "local pattern match checker"
    matches: [(pattern)] => "..."
    
    "constructor"
    [(value)] => {
        clone: cell
        `clone.value = value`
        return: clone
    }
    
    "unwraps the internal value"
    [unwrap] => `cell.value`
    
    "adds a validator for the value"
    [add validator (validator)] => validators append (validator)
    
    "adds a preprocessor for the value"
    [add preprocessor (preprocessor)] => preprocessors append (preprocessor)
    
    "adds a subscriber to an event"
    [on (event) (subscriber)] => subscribers (event) | append (subscriber)
    
    "pattern matching"
    [match (alternatives)] => {
        alternative: alternatives find [(method)] => matches (method signature)
        return: do (alternative)
    }
    
    "conditionals"
    [if true (then)] => `(cell.value ? do(then) : undefined) ?? cell`
    [if false (else)] => `(cell.value ? undefined : do(else)) ?? cell`
    [(value) if true] => `cell.value ? value : undefined`
    [(value) if false] => `cell.value ? undefined : value`
    [(value-1) if true else (value-2)] => `cell.value ? value-1 : value-2`
    [(value-1) if false else (value-2)] => `cell.value ? value-2 : value-1`
}

"definition of the Boolean value"
Boolean: Value with {
    cell: self
    
    "preprocess the value before being set, casting it to a boolean"
    cell add preprocessor [(value)] => `Boolean(value)`
    
    "negates the value"
    [negate] => set `!cell.value`
}

"instantiated booleans (on the environment cell)"
true: Boolean 1
false: Boolean 0

"toggling a boolean"
bool: true
bool negate
print (bool)  --> false "(the value is automagically unwrapped when read)"

"definition of the Array value"
Array: Value with {
    cell: self
    
    [is array] => true
    [first] => `cell.value[0]`
    [last] => `cell.value[value.length - 1]`
    [append (value)] => `cell.value = [...cell.value, value]`
    [prepend (value)] => `cell.value = [value, ...cell.value]`
    [map (mapper)] => `cell.value.map(mapper)`
    [each (handler)] => `cell.value.forEach(handler)`
    "..."
}

"the method literal is the syntax sugar equivalent to `Method (message) { code... }`"
"a method literal declared without being assigned to a slot is a receptor of the cell"
Method: {
    [(message) (code)] => `function (message) { code }`
    [signature] => "..."
}

"`print` is a slot on the environment cell that is a method cell"
print: [(value)] => console log (value)

"`console` is a cell with receptors"
console: {
    [log (value)] => `console.log(value)`
    "..."
}

"the `do` method"
do: [(cell)] => `cell()`
```

<br/>

### Biological cell simulation

Disclaimer: I am not a molecular biologist! (Nor am I a computer scientist.)

```smalltalk
foobar: Cell {
    cell: self
    
    dna: *{
        foo: 40
    }
    
    rna: Queue
    
    ribosomes: []
    
    transcribe: [(value)] => {
        instructions: { "..." }
        foo ≥ 42
            | then -> rna put (instructions)
    }
    
    ribosome: {
        process: [(instructions)] => {
            protein: Protein from (instructions)
            cell emit (protein)
        }
        
        loop -> {
            instructions: await « rna take promise
            process (instructions)
        }
    }
    
    ribosomes append (ribosome)
    
    dna on change (transcribe)
    
    [increase foo] => dna foo « increment
}

foobar increase foo
foobar increase foo

"A new protein is emitted!"
```
