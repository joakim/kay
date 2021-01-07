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

-- a behavior is a cell that takes a message (equivalent to a function with arguments)
behavior: (add $a to $b) -> {
    return $a + $b
}

-- the above behavior inlined (implicit return)
inlined: (add $a to $b) -> $a + $b

-- all values are cells
number: 40 (plus 2)  --> 42
```

<br/>

The building blocks:

```lua
-- definition of the base cell, a blueprint for all cells
Cell {
    value: ()
    
    -- behavior for cloning itself (matches an empty message)
    () -> `Object.assign(Object.create(null), self)`
    
    -- getter
    (get) -> value
    
    -- setter
    (set $value) -> `value = $value`
    
    -- behavior for calling a behavior as if belonging to the caller
    (call $message as $cell) -> `Reflect.apply(self, $cell, $message)`
}

-- definition of Boolean, "inheriting" behaviors from Cell
Boolean Cell {
    -- "constructor" behavior, returning a new cell set to the value cast to boolean
    ($value) -> {
        return Cell () (set `Boolean($value)`)
    }
    
    -- setter behavior, overriding the one from Cell
    (set $value) -> {
        return Cell (call (set `Boolean($value)`) as self)
    }
    
    (yes $true-clause:Cell no $false-clause):Cell -> {
        return `self.value ? do($true-clause) : do($false-clause)`
    }
}

-- instantiated booleans (on the "global" cell)
true: Boolean (1)
false: Boolean (0)

-- `console` is just a cell on the "global" cell
console: {
    (log $value) -> `console.log($value)`
}

-- definition of Array
Array Cell {
    (first $value) -> { return `$value[0]` }
    (last $value) -> { return `$value[$value.length - 1]` }
    (append $value) -> { return `[...self, $value]` }
    (prepend $value) -> { return `[$value, ...self]` }
    -- ...
}

-- definition of Object
Object Cell {
    -- behavior for cloning itself with added properties (`$x:` binds a value as a local name)
    (with $props:Tuple) -> {
        -- define a local property
        object: self ()  -- call the basic clone behavior
        
        -- call the `for` behavior on `$props`, passing a behavior to loop over its items
        $props (for (each $key as $value) -> {
            object (set $key to $value)  -- set an internal property on the object
        })
        
        return object
    }
    
    -- setter behavior for properties
    (set $key to $value) -> {
        return `self[$key] = $value`
    }
    
    -- freeze itself
    (freeze) -> {
        return `Object.freeze(self)`
    }
}
```
