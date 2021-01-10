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

It's cells all the way down, from environment to values. Cells consist of slots (properties), code (statements and expressions) and methods (functions). Cells communicate by [message signaling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Signals are dynamically matched against the signatures of the cell's [receptor](https://en.wikipedia.org/wiki/Cell_surface_receptor) methods. A receptor is responsible for the [transduction](https://en.wikipedia.org/wiki/Signal_transduction) of the received signal and for producing a response.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)) ([phenotypes](https://en.wikipedia.org/wiki/Phenotype)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded.

By default, cells are opaque and isolated. A cell's internal state may only be accessed from the outside through setter and getter signals, unless slots are explicitly exposed. Exceptions are handled internally, a cell can not crash.

Cells are reference types with persistent data structures. The "[observer](https://en.wikipedia.org/wiki/Observer_(quantum_physics))" of a cell gets a fixed "view" of the cell's state as it was at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that view for the observer, based on structural sharing of its past variants. Cells may subscribe to each other, enabling reactivity.

<b title="Too long; didn't read">TL;DR:</b> A cell is the synthesis of object, block and function, implemented as an independent reference type with complete isolation and built-in persistence, communicating by message signaling. The runtime is the stem.

<br/>

## Examples

<sub>This is just an exploration of possibilities. Consider it [Readme Driven](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) Programming Language Design. Comments should be like [Haskell's](https://wiki.haskell.org/Commenting). In these examples they are also enclosed in `""` for the Smalltalk syntax highlighting to look right.</sub>

```smalltalk
-- "create a Replicant object"
Replicant: Object with {
    -- "slots (properties)"
    name: 'Replicant'
    model: 'Generic'
    
    -- "local method (a function assigned to a slot)"
    say: |(words)| => {
        print '{name} says: {words}'
    }
    
    -- "receptor method (a function exposed to the outside)"
    |move (distance)| => {
        meters: distance = 1 << 'meter' if true else 'meters'
        print '{name} the {model} replicant moved {distance} {meters}'
    }
}

-- "create a Nexus9 object by cloning and extending Replicant"
Nexus9: Replicant with {
    replicant: self  -- "a reference to this cell (used in nested cells)"
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []
    
    think: |(thought)| => {
        thoughts append (thought)
        print '{name} thinks: {thought}'
    }
    
    |move| => {
        print '*moves*'
        
        -- "signal the `move (meters)` receptor inherited from `Replicant`"
        replicant move 2
        
        -- "signaling `then` and `else` to the boolean result of `> 100`, like an if statement"
        intelligence > 100
            then -> {
                think 'Why did I move?'
                think 'Am I really a replicant?'
                think 'My name is Joe...'
                replicant name: 'Joe'  -- "mutate local state"
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

It's all cells with slots, code and messages.

`Environment > Modules > (Cells...) > Values`

```smalltalk
-- "literal for a generic cell, here with one slot (not exposed by default)"
-- "`generic` is itself a slot on the enclosing cell"
generic: {
    answer: 42
}

-- "literal signifying a code cell (block, can not use `return`)"
code: -> { … }

-- "literal signifying a method cell (function, can use `return`)"
method: => { … }

-- "literal for a method cell that takes a message (function)"
method-2: |foo| => { … }

-- "method literals may be inlined (implicit `return`)"
method-3: |foo| => true

-- "literal for a receptor method (a method that is not assigned to a slot)"
|foo (bar)| => { … }

-- "receptor method example showing how messages are used"
|receptor taking an (argument)| => {
    -- "messages are string patterns, possibly with arguments"
    -- "arguments are enclosed in `()`, the matched value will be bound to a slot of that name"
    
    -- "`()` is also used to interpolate expressions (including slots) when sending messages"
    print (argument)
    
    -- "`{}` is used to interpolate expressions (including slots) in strings"
    print 'argument is {argument}'
}

-- "cells have lexical scope"
enclosed: {
    inner: 42
    nested: {
        |answer| => inner
    }
    |answer| => nested answer
}

-- "messages can be piped/chained and expressions grouped"
print (enclosed answer = 42 << 'Indeed' if true)  --> 'Indeed'

-- "cells have closure"
adder: |(x)| => {
    |(y)| => {
        return x + y
    }
}

add-5: adder 5
add-10: adder 10
print (add-5 2)   --> 7
print (add-10 2)  --> 12

-- "a cell with local state and code (equivalent to a function expression with no arguments)"
code-cell: {
    a: 2
    b: 3
    result: a + b
    print '{a} + {b} = {result}'
    return result
}

-- "running a cell's code (`do` is an environment method)"
result: do (code-cell)  --> '2 + 3 = 5'
print (result)  --> 5

-- "a mutable cell with all slots exposed, marked with `*` (object/struct/dict in other languages)"
mutable: *{
    foo: 42
    bar: true
}

-- "mutating exposed slots from outside the cell"
-- "setters return the cell, so messages may be piped/chained (fluent interface)"
-- "here using indentation syntax for chaining setter messages"
mutable
    foo: 10
    bar: false

-- "specifying the slot name using a string"
key: 'foo'
mutable key: 42

-- "a cell with an individually exposed slot, marked with `*` (a block in other languages)"
addition: {
    a: 3  -- "a local slot"
    *b: 2  -- "an exposed slot"
    return (a + b)
}

-- "it's possible to mutate the exposed slot between calls (powerful/dangerous)"
do (addition)  --> 5
addition b: 7
do (addition)  --> 10

-- "primitive values are unboxed when read, returning their internal value"
print 42  --> 42, "not `Number 42`"
```

<br/>

The building blocks:

```smalltalk
-- "the void type is a special cell that only ever returns itself"
{}: { |_| => self }

-- "all other cells descend from the base Cell"
Cell: {
    self: `this`
    lineage: [{}]
    exposed: {}
    
    -- "clones itself (matches an empty message)"
    || => {
        clone: `Object.assign(Object.create(null), self)`
        `clone.self = clone`
        
        -- "append a reference to itself as the parent of the clone"
        `clone.lineage.push(WeakRef(self))`
        
        return (clone)
    }
    
    -- "returns the cell's lineage"
    |lineage| => lineage
    
    -- "exposed slot checker"
    |has (key)| => `Reflect.has(self.exposed, key)`
    
    -- "exposed slot setter (returns itself, enabling piping/chaining)"
    |(key): (value)| => self is mutable << then => `(Reflect.set(self.exposed, key, value), self)`
    
    -- "exposed slot getter"
    |(key)| => (self is mutable) or (self has (key)) << `Reflect.get(self.exposed, key)` if true
    
    -- "conditionals (replaces if statements, any cell can define its own truthy/falsy-ness)"
    |then (cell)| => self if true (cell)
    |else (cell)| => self if false (cell)
    |if true (cell)| => `(self ? do(cell) : undefined) ?? self`
    |if false (cell)| => `(self ? undefined : do(cell)) ?? self`
    |(value) if true| => `self ? value : undefined`
    |(value) if false| => `self ? undefined : value`
    |(value-1) if true else (value-2)| => `self ? value-1 : value-2`
    |(value-1) if false else (value-2)| => `self ? value-2 : value-1`
    
    -- "returns whether the cell has all exposed slots"
    |is exposed| => Boolean (exposed size)
    
    -- "checks whether the cell has a receptor matching the signature"
    |has receptor (signature)| => `self.hasReceptor(signature)`
    
    -- "applies a receptor of this cell to another cell"
    |apply (message) to (cell)| => `Reflect.apply(self, cell, message)`
}

-- "definition of the Object cell"
Object: {
    cell: self
    
    -- "clones itself, merging with specified cell(s)"
    |with (spec)| => {
        clone: cell
        
        -- "merge slots into clone"
        merge: |(slots)| => {
            slots each |(key) (value)| => {
                `cell.clone[key] = value`
            }
        }
        
        -- "pattern matching instead of `then` and `else`"
        spec is array << match [
            |true| -> spec each |(item)| => merge (item)
            |false| -> merge (spec)
        ]
        
        return (clone)
    }
}

-- "definition of the Value object"
Value: Object with {
    cell: self
    
    -- "internal value"
    value: {}
    preprocessors: []
    
    -- "local setter method for the internal value"
    set: |(value)| => `(cell.value = value, cell)`
    
    -- "constructor"
    |(value)| => {
        clone: cell
        `clone.value = value`
        return (clone)
    }
    
    -- "unwraps the internal value"
    |unwrap| => `cell.value`
    
    -- "adds a preprocessor for the value"
    |add preprocessor (cell)| => preprocessors append (cell)
    
    -- "pattern matching"
    |match (alternatives)| => {
        alternative: alternatives find |(method)| => matches (method signature)
        return do (alternative)
    }

    -- "pattern match checker"
    matches: |(pattern)| => -- "..."
    
    -- "conditionals"
    |if true (then)| => `(cell.value ? do(then) : undefined) ?? cell`
    |if false (else)| => `(cell.value ? undefined : do(else)) ?? cell`
    |(value) if true| => `cell.value ? value : undefined`
    |(value) if false| => `cell.value ? undefined : value`
    |(value-1) if true else (value-2)| => `cell.value ? value-1 : value-2`
    |(value-1) if false else (value-2)| => `cell.value ? value-2 : value-1`
}

-- "definition of the Boolean value"
Boolean: Value with {
    cell: self
    
    -- "preprocess the value before being set, casting it to a boolean"
    cell add preprocessor |(value)| => `Boolean(value)`
    
    -- "negates the value"
    |negate| => set `!cell.value`
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
    
    |is array| => true
    |first| => `cell.value[0]`
    |last| => `cell.value[value.length - 1]`
    |append (value)| => `cell.value = [...cell.value, value]`
    |prepend (value)| => `cell.value = [value, ...cell.value]`
    |map (mapper)| => `cell.value.map(mapper)`
    |each (handler)| => `cell.value.forEach(handler)`
    -- "..."
}

-- "the literal `|message| => { code }` is syntactic sugar equivalent to `Method |message| { code }`"
-- "any method literal declared without being assigned to a slot is a receptor of the cell"
Method: {
    |(message) (code)| => `function (message) { code }`
    |signature| => -- "..."
}

-- "`print` is a slot on the environment cell that is a method cell"
print: |(value)| => console log (value)

-- "`console` is a cell with receptors"
console: {
    |log (value)| => `console.log(value)`
    -- "..."
}

-- "the `do` method"
do: |(cell)| => `cell()`
```
