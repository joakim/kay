# Kay

A simple programming language inspired by [Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf), [Self](https://selflanguage.org/), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state) and [Blade Runner](https://maidenpublishing.co.uk/review/bladerunner/).

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

## Cells

It's cells all the way down, from environment to values. Cells encapsulate slots, expressions and methods, and communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Signals are dynamically matched against the signatures of the cell's [receptor](https://en.wikipedia.org/wiki/Cell_surface_receptor) methods. A receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of the received signal and for producing a response.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)) ([phenotypes](https://en.wikipedia.org/wiki/Phenotype)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded.

By default, cells are opaque and isolated. A cell's internal state may only be accessed from the outside through setter and getter signals, unless slots are explicitly exposed. Exceptions are handled internally, a cell can not crash.

Cells are first-class reference types with persistent data structures. The "[observer](https://en.wikipedia.org/wiki/Observer_(quantum_physics))" of a cell gets a fixed "view" of the cell's state as it was at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that view for the observer, based on structural sharing of its past variants. Cells may subscribe to each other, enabling reactivity.

#### Cell types

- **Basic** cells have closure, implicitly return themselves only
- **Block** cells do not have closure, implicitly return themselves only
- **Method** cells have closure, can explicitly return values, implicitly if inlined

<br/>

<b title="Too long; didn't read">TL;DR:</b> A cell is the synthesis of object, block and method, implemented as a first-class reference type with complete isolation and built-in persistence, communicating by message signaling. The runtime is the stem.

<br/>


## Examples

<sup>This is just an exploration of possibilities. Consider it [Readme Driven](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) Programming Language Design. Comments should be like [Haskell's](https://wiki.haskell.org/Commenting). In the following examples, comments are also enclosed in `""` for the Smalltalk syntax highlighting to look right. `-->` signifies output.</sup>

```smalltalk
-- "create a Replicant object"
Replicant: Object with {
    -- "slots"
    name: 'Replicant'
    model: 'Generic'
    
    -- "receptor method (exposed to the outside)"
    | move (distance) | => {
        meters: distance = 1 << 'meter' if true else 'meters'
        print '{name} the {model} replicant moved {distance} {meters}'
    }
    
    -- "local method (assigned to a slot)"
    say: | (words) | => {
        print '{name} says: {words}'
    }
}

-- "create a Nexus9 object by cloning and extending Replicant"
Nexus9: Replicant with {
    replicant: self
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []
    
    think: | (thought) | => {
        -- "send an `append` message to the `thoughts` array with the `thought` argument's value"
        thoughts append (thought)
        print '{name} thinks: {thought}'
    }
    
    | move | => {
        print '*moves*'
        
        -- "signal the `move (meters)` receptor inherited from `Replicant`"
        replicant move 2
        
        -- "signal `then` and `else` of the boolean result of `>`, equivalent to an if statement"
        intelligence > 100
            then -> {
                think 'Why did I move?'
                think 'Am I really a replicant?'
                think 'My name is Joe...'
                replicant name: 'Joe'  -- "mutate the state of an outer cell"
                say 'My name is {name}!'
            }
            else -> think '*crickets*'
    }
}

-- "create a new Nexus 9 replicant"
officer-k: Nexus9 with { name: 'K', intelligence: 140 }

-- "signal its `move` receptor"
officer-k move

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'K thinks: Why did I move?'
--> 'K thinks: Am I really a replicant?'
--> 'K thinks: My name is Joe...'
--> 'Joe says: I have a purpose!'
```

<br/>

It's all interlinked cells with slots, expressions and messages.

`Environment > Modules > (Cells...) > Values`

```smalltalk
-- "literal for a basic cell"
basic-literal: {}

-- "a basic cell with a slot and an expression"
basic-example: {
    answer: 42
    print (answer)
}

-- "literal for a block cell (compound statements in other languages)"
block-literal: -> { … }

-- "a block cell passed as an argument to the `then` receptor of Boolean"
block-example: true then -> {
    truth: 'It is true'
    print (truth)
}

-- "literal for a method cell (function in other languages)"
method-literal: => { … }

-- "a method cell that takes a message, prints its argument and returns a string"
method-example: | (argument) | => {
    print (argument)
    return 'argument was {argument}'
}

-- "an inlined method cells, having implicit `return` (lambda in other languages)"
method-inlined: | (argument) | => true

-- "literal for a receptor method (object method in other languages)"
-- "a receptor is simply a method that is not assigned to a slot"
| foo (bar) | => { … }

-- "a receptor method illustrating how messages are used"
| receptor with one (argument) | => {
    -- "messages are flexible string patterns that may contain arguments"
    -- "arguments are enclosed in `()`, the matched value will be bound to a slot of that name"
    -- "the syntax could be extended to support typed arguments"
    
    -- "`()` is similarly used to interpolate expressions (also slots) when sending messages"
    print (argument)
    
    -- "`{}` is used to interpolate expressions (also slots) in strings"
    print 'argument is {argument}'
}

-- "a method cell without arguments (equivalent to a function expression with no arguments)"
method: => {
    a: 2
    b: 3
    result: (a + b)
    print '{a} + {b} = {result}'
    return (result)
}

-- "calling the method using `do` (an environment method)"
result: do (method)  --> '2 + 3 = 5'
print (result)       --> 5

-- "all cells have lexical scope"
scoped: {
    inner: 42
    nested: {
        | answer | => (inner)
    }
    | answer | => nested answer
}

-- "expressions can be grouped/evaluated with `()` and messages piped/chained with `<<`"
print (scoped answer = 42 << 'Indeed' if true)  --> 'Indeed'

-- "a cell with all its slots exposed, marked with `*` (object/struct/dict in other languages)"
mutable: *{
    foo: 42
    bar: true
}

-- "mutating exposed slots from outside the mutable cell"
-- "setters return the cell itself, enabling chaining of messages"
mutable (foo: 10) (bar: false)

-- "alternative syntax using the pipe operator"
mutable foo: 10 << bar: false

-- "alternative syntax using indentation (fluent interface)"
mutable
    foo: 10
    bar: false

-- "mutating a slot by referencing its name using a local slot's value"
key: 'foo'
mutable (key): 42

-- "a cell with an individually exposed slot"
exposed: {
    foo: 42
    *bar: true
}

exposed bar: false

-- "method demonstrating closure"
adder: | (x) | => {
    return | (y) | => {
        return x + y
    }
}

add-5: (adder 5)
add-10: (adder 10)

print (add-5 2)   --> 7
print (add-10 2)  --> 12

-- "inlined version of the `adder` method"
inlined: | (x) | => | (y) | => x + y

-- "self-modifying code by mutating exposed slots between calls (powerful/dangerous)"
add: | (a) to (b) | => {
    expose output: {}
    output (a + b)
}

add 2 to 3  --> {}
add output: print
add 2 to 3  --> 5

-- "primitive values are unboxed when read, returning their internal value"
print 42  --> "42, not `Number 42`"

-- "slots are really setter messages on the current cell (`self`), the following are equivalent"
foo: 42
self foo: 42
```

<br/>

The building blocks:

```smalltalk
-- "the void type is a special cell that only ever returns itself"
{}: { | _ | => self }

-- "all other cells descend from the base Cell"
Cell: {
    lineage: [{}]
    exposed: {}
    
    -- "slot initialization"
    set: | (key): ...(value) | => `Reflect.set(self, key, value)`
    
    -- "exposed slot initialization"
    expose: | (key): ...(value) | => exposed (key): value
    
    -- "clones itself (matches an empty message)"
    | | => {
        clone: `Object.assign(Object.create(null), self)`
        
        -- "append a reference to itself as the parent of the clone"
        `clone.lineage.push(WeakRef(self))`
        
        return (clone)
    }
    
    -- "returns the cell's lineage"
    | lineage | => lineage
    
    -- "exposed slot checker"
    | has (key) | => `Reflect.has(self.exposed, key)`
    
    -- "exposed slot getter"
    | (key) | => (self is mutable) or (self has (key)) << `Reflect.get(self.exposed, key)` if true
    
    -- "exposed slot setter (returns itself, enabling piping/chaining)"
    | (key): (value) | => (self is mutable) or (self has (key)) << `(Reflect.set(self.exposed, key, value), self)` if true
    
    -- "conditionals (replaces if statements, any cell can define its own truthy/falsy-ness)"
    | then (cell) | => self if true (cell)
    | else (cell) | => self if false (cell)
    | if true (cell) | => `(self ? do(cell) : undefined) ?? self`
    | if false (cell) | => `(self ? undefined : do(cell)) ?? self`
    | (value) if true | => `self ? value : undefined`
    | (value) if false | => `self ? undefined : value`
    | (value-1) if true else (value-2) | => `self ? value-1 : value-2`
    | (value-1) if false else (value-2) | => `self ? value-2 : value-1`
    
    -- "returns whether the cell has all exposed slots"
    | is exposed | => Boolean (exposed size)
    
    -- "checks whether the cell has a receptor matching the signature"
    | has receptor (signature) | => `self.hasReceptor(signature)`
    
    -- "applies a receptor of this cell to another cell"
    | apply (message) to (cell) | => `Reflect.apply(self, cell, message)`
}

-- "definition of the Object cell"
Object: {
    cell: self
    
    -- "clones itself, merging with the specified cell(s), enabling composition of multiple cells"
    | with (spec) | => {
        clone: cell
        
        -- "merge slots into the clone"
        merge: | (slots) | => {
            slots each | (key) (value) | => {
                `cell.clone[key] = value`
            }
        }
        
        -- "if merging with an array of cells, merge each cell in turn"
        spec (is array)
            then -> spec each | (item) | => merge (item)
            else -> merge (spec)
        
        return (clone)
    }
}

-- "definition of the Value object"
Value: Object with {
    cell: self
    
    -- "internal value and its validators, preprocessors and subscribers"
    value: {}
    validators: []
    preprocessors: []
    subscribers: {}
    
    -- "local setter method for mutating the internal value"
    set: | (value) | => {
        -- "validate and preprocess..."
        `(cell.value = value, cell)`
    }
    
    -- "local pattern match checker"
    matches: | (pattern) | => -- "..."
    
    -- "constructor"
    | (value) | => {
        clone: cell
        `clone.value = value`
        return (clone)
    }
    
    -- "unwraps the internal value"
    | unwrap | => `cell.value`
    
    -- "adds a validator for the value"
    | add validator (validator) | => validators append (validator)
    
    -- "adds a preprocessor for the value"
    | add preprocessor (preprocessor) | => preprocessors append (preprocessor)
    
    -- "adds a subscriber to an event"
    | on (event) (subscriber) | => subscribers (event) << append (subscriber)
    
    -- "pattern matching"
    | match (alternatives) | => {
        alternative: alternatives find | (method) | => matches (method signature)
        return do (alternative)
    }
    
    -- "conditionals"
    | if true (then) | => `(cell.value ? do(then) : undefined) ?? cell`
    | if false (else) | => `(cell.value ? undefined : do(else)) ?? cell`
    | (value) if true | => `cell.value ? value : undefined`
    | (value) if false | => `cell.value ? undefined : value`
    | (value-1) if true else (value-2) | => `cell.value ? value-1 : value-2`
    | (value-1) if false else (value-2) | => `cell.value ? value-2 : value-1`
}

-- "definition of the Boolean value"
Boolean: Value with {
    cell: self
    
    -- "preprocess the value before being set, casting it to a boolean"
    cell add preprocessor | (value) | => `Boolean(value)`
    
    -- "negates the value"
    | negate | => set `!cell.value`
}

-- "instantiated booleans (on the environment cell)"
true: Boolean 1
false: Boolean 0

-- "toggling a boolean"
bool: true
bool negate
print (bool)  --> false "(the value is automagically unwrapped when read)"

-- "definition of the Array value"
Array: Value with {
    cell: self
    
    | is array | => true
    | first | => `cell.value[0]`
    | last | => `cell.value[value.length - 1]`
    | append (value) | => `cell.value = [...cell.value, value]`
    | prepend (value) | => `cell.value = [value, ...cell.value]`
    | map (mapper) | => `cell.value.map(mapper)`
    | each (handler) | => `cell.value.forEach(handler)`
    -- "..."
}

-- "the method literal is the syntax sugar equivalent to `Method  | message | { code }`"
-- "a method literal declared without being assigned to a slot is a receptor of the cell"
Method: {
    | (message) (code) | => `function (message) { code }`
    | signature | => -- "..."
}

-- "`print` is a slot on the environment cell that is a method cell"
print: | (value) | => console log (value)

-- "`console` is a cell with receptors"
console: {
    | log (value) | => `console.log(value)`
    -- "..."
}

-- "the `do` method"
do: | (cell) | => `cell()`
```
