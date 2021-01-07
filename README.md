# Kay

A small programming language inspired by [Smalltalk](http://worrydream.com/refs/Ingalls%20-%20Design%20Principles%20Behind%20Smalltalk.pdf) and Blade Runner.

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

It's cells all the way down, from modules to values. Cells consist of internal state (properties), code (statements and expressions) and behaviors (functions). Cells communicate by passing messages, represented as tuples `(key value key value …)`. Received messages are dynamically matched against behavior signatures, which may be typed. There's no inheritance or prototypes, only composition and duck-typing. A cell is fully opaque, its internal state (properties) is not available from the outside except through setters/getters.

Cells are passed by reference and implemented as persistent (immutable) data structures. The receiver of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. Mutating a cell creates a new version from that "view", based on structural sharing of its past versions.

The runtime is the stem.

<br/>

## Examples

ECMAScript is the runtime in the following examples.

<br/>

```lua
-- create a Replicant object
Replicant Object {
    -- internal state (properties)
    name: 'Replicant'
    model: 'generic'
    
    -- a behavior
    (move $meters) -> {
        -- calling a behavior on another object
        console (log "{name} the {model} replicant moved {$meters} meters")
    }
    
    -- an internal behavior (a behavior assigned to a property)
    say: ($words) -> {
        console (log "{name} says: {$words}")
    }
}

-- create a Nexus9 object using Replicant as its blueprint
Nexus9 Replicant {
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []  -- an array
    
    -- typed behavior signature
    think: ($thought:String) -> {
        thoughts (append $thought)
        console (log "{name} thinks: $thought")
    }
    
    -- a behavior without any arguments
    (move) -> {
        console (log '*moves*')
        
        -- call the `move $meters` behavior "inherited" from `Replicant`
        self (move 2)
        
        -- if…else "statement" using the `yes-no` behavior of `Boolean`
        intelligence > 100 (yes {
            think ('Why did I move?')
            think ('Am I really a replicant?')
            think ('Do I even exist?')
            think ('My name is Joe...')
            name (set 'Joe')  -- update internal state
            say ("I have a purpose!")
        }
        no {
            think ("*nothing*")
        })
    }
}

-- create a new Nexus 9 replicant with some properties
officer-k: Nexus9 (with (name 'K' id 'KD6-3.7' intelligence 140))

-- call the `move` behavior
officer-k (move)

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'K thinks: Why did I move?'
--> 'K thinks: Am I really a replicant?'
--> 'K thinks: Do I even exist?'
--> 'K thinks: My name is Joe...'
--> 'Joe says: I have a purpose!'
```

<br/>

It's all cells:

```lua
-- an empty cell literal
cell: {}

-- a cell with internal state and code (equivalent to a function with no arguments)
code: {
    a: 2
    b: a + 3
    return b
}

-- running a cell's code (`do` is a "global" behavior)
result: do (code)  --> 5

-- the definition of `do`
do: ($cell) -> `$cell()`  -- ECMAScript embedded within backticks

-- a behavior is a cell that takes a message (equivalent to a function with arguments)
behavior: (add $a to $b) -> {
    return $a + $b
}

-- the above behavior inlined (implicit return)
inlined: (add $a to $b) -> $a + $b

-- all values are cells
number: 40 (plus 2)  --> 42

-- primitive values automagically unwrap to return their internal value when read
primitive: 42  --> 42
```

<br/>

The building blocks:

```lua
-- definition of the base cell, a blueprint for all cells
Cell {
    -- behavior for cloning itself (matches an empty message)
    () -> `Object.assign(Object.create(null), self)`
    
    -- behavior for applying a behavior on the caller
    (apply $message on $cell) -> `Reflect.apply(self, $cell, $message)`
    
    -- properties that are automagically set
    type: 'Cell'
    lineage: []
    
    -- when "extended", the new descendant sets the type to its name and adds itself to the lineage
    lineage (prepend (WeakRef (self)))
}

-- definition of the base Value cell, "extended" from Cell
Value Cell {
    -- internal state
    value: ()
    
    -- constructor
    ($value) -> self () (set $value)
    
    -- setter
    (set $value) -> `value = $value`
    
    -- getter
    (get) -> value
}

-- definition of the Boolean value
Boolean Value {
    -- setter behavior, overriding the one "inherited" from Value
    (set $value) -> `value = Boolean($value)`
    
    -- toggle behavior
    (toggle) -> self (set `!value`)
    
    -- yes-no behavior ("if-then-else", "if-then" and "if-not")
    (yes $then no $else) -> `(value ? do($then) : do($else))`
    (yes $then) -> self (yes $then no ())
    (no $else) -> self (yes () no $else)
}

-- instantiated booleans (on the "global" cell)
true: Boolean (1)
false: Boolean (0)

-- toggling a boolean
bool: true  -- sugar for `true ()`, primitive values are sweet
bool (toggle)  --> false (the value is automagically unwrapped when read)

-- definition of the Array value
Array Value {
    (first) -> `value[0]`
    (last) -> `value[value.length - 1]`
    (append $value) -> `value = [...self.value, $value]`
    (prepend $value) -> `value = [$value, ...self.value]`
    -- ...
}

-- definition of the Object value
Object Value {
    value: `new PersistentDataStructure()`
    
    -- setter behavior for object properties
    (set $key to $value) -> `self.value[$key] = $value`
    
    -- behavior for cloning itself with added properties (`$x:` binds a value as a local name)
    (with $properties:Tuple) -> {
        -- define a local property
        object: self ()  -- call the basic clone behavior
        
        -- call the `for` behavior on `$properties`, passing a behavior to loop over its items
        $properties (for (each $key as $value) -> {
            object (set $key to $value)  -- set an internal property on the object
        })
        
        return object
    }
    
    -- freeze itself
    (freeze) -> `Object.freeze(self)`
    
    -- it's lineage is: [Object, Value, Cell]
}

-- `console` is simply a cell on the "global" cell that takes messages
console: {
    (log $value) -> `console.log($value)`
    -- ...
}

-- the void type is represented by an empty tuple that only ever returns itself
() { () -> self }
```
