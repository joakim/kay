# Kay

A small programming language inspired by [Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf), [Self](https://selflanguage.org/), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state) and [Blade Runner](https://maidenpublishing.co.uk/review/bladerunner/).

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

It's cells all the way down, from environment to values. Cells consist of slots (properties), code (statements and expressions) and methods (functions). Cells communicate by [message signalling](https://en.wikipedia.org/wiki/Cell_communication_(biology)). Messages are dynamically matched against the signatures of the cell's [receptor](https://en.wikipedia.org/wiki/Cell_surface_receptor) methods.

There's no inheritance, only [cloning](https://en.wikipedia.org/wiki/Clone_%28cell_biology%29), [composition](https://en.m.wikipedia.org/wiki/Composition_over_inheritance) and [protocols](https://en.wikipedia.org/wiki/Protocol_(object-oriented_programming)) ([phenotypes](https://en.wikipedia.org/wiki/Phenotype)). The [lineage](https://en.wikipedia.org/wiki/Cell_lineage) of a cell is recorded.

By default, cells are opaque and isolated. A cell's internal state may only be accessed from the outside through setter and getter messages, except for explicitly exposed slots. A cell _can not_ crash, any exceptions are handled internally.

Cells are reference types with persistent data structures. The "reader" of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. [Mutating](https://en.wikipedia.org/wiki/Mutation) a cell creates a new variant from that "view", based on structural sharing of its past variants. Cells may subscribe to each other, enabling reactivity.

<b title="Too long; didn't read">TL;DR</b>  
A cell is the synthesis of object, block and function, implemented as an independent reference type with complete isolation and built-in persistence, communicating by message signalling. The runtime environment is the stem.

<br/>

## Examples

```lua
-- create a Replicant object
Replicant: Object with {
    -- slots (properties)
    name: 'Replicant'
    model: 'generic'
    
    -- local method (a function assigned to a property)
    say: ($words) => {
        print "{name} says: {$words}"
    }
    
    -- receptor method (a function exposed to the outside)
    (move $meters) => {
        -- calling a receptor on another object
        print "{name} the {model} replicant moved {$meters} meters"
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
    
    -- a receptor without any arguments
    (move) => {
        print '*moves*'
        
        -- call the `move $meters` receptor "inherited" from `Replicant`
        self move 2
        
        -- if…else "statement" using the `yes-no` receptor of `Boolean`
        intelligence > 100 (yes {
            think 'Why did I move?'
            think 'Am I really a replicant?'
            think 'My name is Joe...'
            name set 'Joe'  -- update local state
            say "I have a purpose!"
        }
        no {
            think "*nothing*"
        })
    }
}

-- create a new Nexus 9 replicant with some properties
officer-k: Nexus9 with (name 'K' id 'KD6-3.7' intelligence 140)

-- call the `move` receptor
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
-- an empty cell literal
cell: {}

-- a cell with local state and code (equivalent to a function with no arguments)
code: {
    a: 2
    b: a + 3
    return b
}

-- running a cell's code (`do` is a "global" method)
do code  --> 5

-- the definition of `do`
do: ($cell) => `$cell()`  -- ECMAScript embedded within backticks

-- a method is a cell that takes a message (equivalent to a function with arguments)
method: (add $a to $b) => {
    return $a + $b
}

-- the above method inlined (implicit return)
inlined: (add $a to $b) => $a + $b

-- primitive values are unboxed when read to return their internal value
print 42  --> 42, not `Number 42`

-- a cell with exposed slots (marked with an asterisk)
addition: {
    *a: 2
    *b: 3
    return 2 + 3
}

-- self-modifying code (powerful, but dangerous)
do addition  --> 5
addition a: 7  -- mutate the cell's internal state from the outside
do addition  --> 10
```

<br/>

The building blocks:

```lua
-- the void type is a special cell that only ever returns itself
{}: { (_) => self }

-- all other cells descend from this base cell
Cell: {
    lineage: [{}]
    
    -- returns the cell's lineage
    (lineage) => lineage
    
    -- clones itself (matches an empty message)
    () => {
        clone: `Object.assign(Object.create(null), self)`
        
        -- append itself as the parent of the clone
        `clone.lineage.push(WeakRef(self))`
        return clone
    }
    
    -- checks whether the cell has a receptor method
    (receives $signature) => `self.receives($signature)`
}

-- definition of the Method cell
-- the literal `(args) => { body }` is syntactic sugar for `Method (args) { body }`
-- any method literal not assigned to a slot is a receptor of the cell
Method: {
    ($arguments $body) => `function ($arguments) { $body }`
}

-- definition of the Object cell
Object: {
    -- receptor for cloning itself with added features (`$x:` binds a value as a local name)
    (with $properties) => {
        clone: self ()
        
        -- call the `for` receptor on `$properties`, passing a lambda to loop over its items
        $properties for (each $key as $value) => {
            `clone[$key] = $value`
        }
        
        return clone
    }
    
    -- getter receptor
    (get $key) => `self[$key]`
    
    -- freeze itself
    (freeze) => `Object.freeze(self)`
    
    -- receptor for applying a receptor to the caller
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
    
    -- lineage: [WeakRef Object, {}]
}

-- definition of the Boolean value
Boolean: Value with {
    -- preprocess any passed value, casting it to a boolean
    value preprocess ($value) => `Boolean($value)`
    
    -- toggle receptor
    (toggle) => set `!self.value`
    
    -- yes-no receptor ("if-then-else", "if-then" and "if-not")
    (yes $then no $else) => `(value ? do($then) : do($else))`
    (yes $then) => self yes $then no {}
    (no $else) => self yes {} no $else

    -- lineage: [WeakRef Value, WeakRef Object, {}]
}

-- instantiated booleans (on the "global" cell)
true: Boolean (1)
false: Boolean (0)

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
    
    -- lineage: [WeakRef Value, WeakRef Object, {}]
}

-- `print` is a slot on the "global" cell that is a method cell
print: ($value) => console log $value

-- `console` is a cell with receptors
console: {
    (log $value) => `console.log($value)`
    -- ...
}
```
