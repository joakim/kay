# Kay

A small programming language inspired by [Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf), [Erlang](https://www.eighty-twenty.org/2011/05/08/weaknesses-of-smalltalk-strengths-of-erlang), [Clojure](https://clojure.org/about/state) and [Blade Runner](https://maidenpublishing.co.uk/review/bladerunner/).

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

It's cells all the way down, from modules to values. Cells consist of local state (properties), code (statements and expressions) and methods/behaviors (functions). Cells communicate by message passing. Received messages are dynamically matched against behavior signatures, which may be typed.

There's no inheritance or prototypes, only composition and traits (duck-typing).

Cells are completely isolated from one another. A cell's local state is only accessible from the outside in a controlled manner through setters and getters. A cell simply _can not_ crash, any exceptions are handled internally.

Cells are reference types with persistent data structures. The receiver of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. Mutating a cell creates a new version from that "view", based on structural sharing of its past versions. Cells in the same context may subscribe to each other's events, enabling reactivity.

In short: A cell is the synthesis of object, block and function, implemented as a reference type with complete isolation and built-in persistence. The runtime environment is the stem.

<br/>

## Examples

ECMAScript is the runtime in the following examples.

<br/>

```lua
-- create a Replicant object
Replicant: Object with {
    -- local state (properties)
    name: 'Replicant'
    model: 'generic'
    
    -- local method (a function assigned to a property)
    say: ($words) => {
        console log "{name} says: {$words}"
    }
    
    -- behavior (a function exposed to the outside)
    (move $meters) => {
        -- calling a behavior on another object
        console log "{name} the {model} replicant moved {$meters} meters"
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
        console log "{name} thinks: $thought"
    }
    
    -- a behavior without any arguments
    (move) => {
        console log '*moves*'
        
        -- call the `move $meters` behavior "inherited" from `Replicant`
        self move 2
        
        -- if…else "statement" using the `yes-no` behavior of `Boolean`
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

-- call the `move` behavior
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
result: do code  --> 5

-- the definition of `do`
do: ($cell) => `$cell()`  -- ECMAScript embedded within backticks

-- a method is a cell that takes a message (equivalent to a function with arguments)
method: (add $a to $b) => {
    return $a + $b
}

-- the above method inlined (implicit return)
inlined: (add $a to $b) => $a + $b

-- primitive values automagically unwrap to return their internal value when read
primitive: 42  --> 42
```

<br/>

The building blocks:

```lua
-- the void type is represented by an empty cell that only ever returns itself
{}: { (*) => self }

-- definition of the base Object cell
Object: {
    -- behavior for cloning itself (matches an empty message)
    () => `Object.assign(Object.create(null), self)`
    
    -- behavior for cloning itself with added features (`$x:` binds a value as a local name)
    (with $properties:Tuple) => {
        clone: self ()
        
        -- call the `for` behavior on `$properties`, passing a lambda to loop over its items
        $properties for (each $key as $value) => {
            `clone[$key] = $value`
        }
        
        -- add the parent object as an ancestor
        (clone get lineage) prepend (WeakRef self)
        
        return clone
    }
    
    -- getter behavior
    (get $key) => `self[$key]`
    
    -- freeze itself
    (freeze) => `Object.freeze(self)`
    
    -- behavior for applying a behavior to the caller
    (apply $message to $cell) => `Reflect.apply(self, $cell, $message)`
    
    lineage: [{}]
}

-- definition of the base Value object
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
    
    -- getter behavior for the internal value
    (get) => self get value
    
    -- lineage: [WeakRef Object, {}]
}

-- definition of the Boolean value
Boolean: Value with {
    -- preprocess any passed value, casting it to a boolean
    value preprocess ($value) => `Boolean($value)`
    
    -- toggle behavior
    (toggle) => set `!self.value`
    
    -- yes-no behavior ("if-then-else", "if-then" and "if-not")
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

-- `console` is simply a cell on the "global" cell that takes messages
console: {
    (log $value) => `console.log($value)`
    -- ...
}
```
