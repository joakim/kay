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

Cells are reference types with persistent data structures. The "observer" of a cell gets an immutable "view" of the cell's state as it was at that instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that view for the observer, based on structural sharing of its past variants. Cells may subscribe to each other, enabling reactivity.

<b title="Too long; didn't read">TL;DR</b>  
A cell is the synthesis of object, block and function, implemented as an independent reference type with complete isolation and built-in persistence, communicating by message signaling. The runtime environment is the stem.

<br/>

## Examples

```lua
-- create a Replicant object
Replicant: Object with {
    -- slots (properties)
    name: 'Replicant'
    model: 'generic'
    
    -- local method (a function assigned to a slot)
    say: ($words) => {
        print "{name} says: {$words}"
    }
    
    -- receptor method (a function exposed to the outside)
    (move $meters) => {
        print "{name} the {model} replicant moved {$meters} meter{$meters <> 1 | yes -> 's'}"
    }
}

-- create a Nexus9 object using Replicant as its blueprint
Nexus9: Replicant with {
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []  -- an array
    
    -- typed method signature
    think: ($thought:String) => {
        thoughts append $thought
        print "{name} thinks: $thought"
    }
    
    -- a receptor with a unary message
    (move) => {
        print '*moves*'
        
        -- signaling the `move $meters` receptor "inherited" from `Replicant`
        self move 2
        
        -- if…else "statement" by sending a `yes-no` message to the boolean
        intelligence > 100 | yes -> {
            think 'Why did I move?'
            think 'Am I really a replicant?'
            think 'My name is Joe...'
            name set 'Joe'  -- update local state
            say "I have a purpose!"
        } no -> {
            think "*nothing*"
        }
    }
}

-- create a new Nexus 9 replicant with some properties
officer-k: Nexus9 with { name: 'K', intelligence: 140 }

-- signaling the `move` receptor
officer-k move

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'K thinks: Why did I move?'
--> 'K thinks: Am I really a replicant?'
--> 'K thinks: My name is Joe...'
--> 'Joe says: I have a purpose!'
```

<br/>

It's all cells:

```lua
-- empty cell literal
cell: {}

-- literal signifying a code cell (block)
block: -> {}

-- literal signifying a method cell (function)
method: => {}

-- literal for a method with arguments (function)
method-2: (foo $bar) => {}

-- cell with local state and code (equivalent to a function expression with no arguments)
code: {
    a: 2
    b: 3
    c: a + b
    print "{a} + {b} = {c}"
    return c
}

-- running a cell's code (`do` is an environment method)
result: do code  --> "2 + 3 = 5"
print result  --> 5

-- definition of the `do` method
do: ($cell) => `$cell()`  -- JavaScript in backticks to illustrate what it does

-- a method is a cell that takes a message (equivalent to a function with arguments)
method: (add $a to $b) => {
    return $a + $b
}

-- the above method, inlined (implicit return)
inlined: (add $a to $b) => $a + $b

-- primitive values are unboxed when read to return their internal value
print 42  --> 42, not `Number 42`

-- a mutable cell with all slots exposed (like objects/structs/dicts in other languages)
object: *{
    foo: 42
    bar: true
}

-- mutating the cell from the outside
object foo: 10
object bar: false

-- a cell with an exposed slot, marked with an asterisk (block)
addition: {
    *a: 2
    b: 3
    return 2 + 3
}

-- makes self-modifying code possible (powerful/dangerous)
do addition  --> 5
addition a: 7  -- mutate the cell's internal state from the outside
do addition  --> 10
```

<br/>

The building blocks:

```lua
-- the void type is a special cell that only ever returns itself
{}: { (_) => self }

-- all other cells descend from the base Cell
Cell: {
    lineage: [{}]
    
    -- returns the cell's lineage
    (lineage) => lineage
    
    -- clones itself (matches an empty message)
    () => {
        clone: `Object.assign(Object.create(null), self)`
        
        -- append a reference to itself as the parent of the clone
        `clone.lineage.push(WeakRef(self))`
        
        return clone
    }
    
    -- checks whether the cell has a receptor method
    (receives $signature) => `self.receives($signature)`
}

-- definition of the Method cell
-- the literal `(message) => { code }` is syntactic sugar for `Method (message) { code }`
-- a method literal declared without being assigned to a slot is a receptor of the cell
Method: {
    ($message $code) => `function ($message) { $code }`
}

-- definition of the Object cell
Object: {
    -- clones itself, merging with specified cell(s)
    (with $spec) => {
        clone: self ()
        
        -- merge slots into clone
        merge: ($slots) => {
            $slots each ($key and $value) => {
                `self.clone[$key] = $value`
            }
        }
        
        $spec is-array? | yes -> {
            $spec each ($item) => { merge $item }
        } no -> {
            merge $spec
        }
        
        return clone
    }
    
    -- getter
    (get $key) => `self[$key]`
    
    -- freezes itself
    (freeze) => `Object.freeze(self)`
    
    -- applies a receptor of this cell to another cell
    (apply $message to $cell) => `Reflect.apply(self, $cell, $message)`
}

-- definition of the Value object
Value: Object with {
    -- internal value
    value: {}
    
    -- setter method for the internal value
    set: ($value) => `(self.value = $value, self)`
    
    -- constructor
    ($value) => {
        new: self ()
        `new.value = $value`
        return new
    }
    
    -- getter receptor for the internal value
    (get) => self get value
}

-- definition of the Boolean value
Boolean: Value with {
    -- preprocess any passed value, casting it to a boolean
    value add-preprocessor ($value) => `Boolean($value)`
    
    -- toggle receptor
    (toggle) => set `!self.value`
    
    -- yes-no receptor ("if-then-else", "if-then" and "if-not")
    (yes $then no $else) => `(value ? do($then) : do($else))`
    (yes $then) => self yes $then no {}
    (no $else) => self yes {} no $else
}

-- instantiated booleans (on the environment cell)
true: Boolean 1
false: Boolean 0

-- toggling a boolean
bool: true  -- sugar for `true ()`, primitive values are sweet
bool toggle  --> false (the value is automagically unwrapped when read)

-- definition of the Array value
Array: Value with {
    (first) => `self.value[0]`
    (last) => `self.value[value.length - 1]`
    (append $value) => `value = [...self.value, $value]`
    (prepend $value) => `value = [$value, ...self.value]`
    -- ...
}

-- `print` is a slot on the environment cell that is a method cell
print: ($value) => console log $value

-- `console` is a cell with receptors
console: {
    (log $value) => `console.log($value)`
    -- ...
}
```
