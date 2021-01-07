# Kay

A small programming language inspired by Smalltalk and Blade Runner.

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

It's cells all the way down, from modules to values. Cells consist of internal state (properties), code (statements and expressions) and behaviours (functions). Cells communicate by passing messages, represented as tuples `(key value key value …)`. Received messages are dynamically matched against behaviour signatures, which may be typed. There's no inheritance or prototypes, only composition and duck-typing. A cell is fully opaque, its internal state (properties) is not available from the outside except through setters/getters.

Cells are passed by reference and implemented as persistent (immutable) data structures. The receiver of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. Mutating a cell creates a new version from that "view", based on structural sharing of its past versions.

The runtime is the stem. Which is ECMAScript in the following examples.

<br/>

```lua
-- create a Replicant object
Replicant Object {
    -- internal state (properties)
    name: 'Replicant'
    model: 'generic'
    
    -- a behaviour
    (move $meters) -> {
        -- calling a behaviour on another object
        console (log "{name} the {model} replicant moved {$meters} meters")
    }
    
    -- an internal function (a behaviour assigned to a property)
    say: ($words) -> {
        console (log "{name} says: {$words}")
    }
}

-- create a Nexus9 object using Replicant as its blueprint
Nexus9 Replicant {
    model: 'Nexus 9'
    intelligence: 100
    thoughts: []  -- a list
    
    -- typed function signature
    think: ($thought:String) -> {
        thoughts (append $thought)
        console (log $thought)
    }
    
    -- a behaviour without any arguments
    (move) -> {
        console (log '*moves*')
        
        -- call the `move` behaviour "inherited" from `Replicant`
        self (move 2)
        
        -- if…else "statement" using the `if-true` behaviour of `Boolean`
        intelligence > 100 (if-true {
            think ('Why did I just move?')
            think ('Am I really a replicant?')
            think ('Do I even exist?')
            
            -- update internal state
            name (set 'Joe')
            
            say ("My name is {name}")
        }
        else {
            think ("*nothing*")
        })
    }
}

-- create a new Nexus 9 replicant with some properties, then freeze it
officer-k: Nexus9 (with (name 'K' id 'KD6-3.7' intelligence 140)) (freeze)

-- call the `move` behaviour
officer-k (move)

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'Why did I just move?'
--> 'Am I really a replicant?'
--> 'Do I even exist?'
--> 'Joe says: My name is Joe'
```

The underlying building blocks:

```lua
-- definition of the base cell, a blueprint for all cells
Cell {
    -- behaviour for cloning itself (matches an empty message)
    () -> {
        return `Object.assign(Object.create(null), self)`  -- embedded ECMAScript
    }
    
    -- setter behaviour
    (set $value) -> {
        return `self.value = $value`
    }
    
    -- behaviour for calling a behaviour as if belonging to the caller
    (call $message as $cell) -> {
        return `Reflect.apply(self, $cell, $message)`
    }
}

-- definition of Boolean, "inheriting" behaviours from Cell
Boolean Cell {
    -- "constructor" behaviour, returning a new cell set to the value cast to boolean
    ($value) -> {
        return Cell () (set `Boolean($value)`)
    }
    
    -- setter behaviour, overriding the one from Cell
    (set $value) -> {
        return Cell (call (set `Boolean($value)`) as self)
    }
}

-- instantiated booleans
true: Boolean (1)
false: Boolean (0)

-- definition of Object, the most common blueprint
Object Cell {
    -- behaviour for cloning itself with added properties (`$x:` binds a value as a local name)
    (with $props:Tuple) -> {
        -- define a local property
        object: self ()  -- call the basic clone behaviour
        
        -- call the `for` behaviour on `$props`, passing a behaviour to loop over its items
        $props (for (each $key as $value) -> {
            object (set $key to $value)  -- set an internal property on the object
        })
        
        return object
    }
    
    -- setter behaviour for properties
    (set $key to $value) -> {
        return `self[$key] = $value`
    }
    
    -- freeze itself
    (freeze) -> {
        return `Object.freeze(self)`
    }
}

console {
    (log $value) -> `console.log($value)`
}
```
