# Kay

A small programming language inspired by Smalltalk and Blade Runner that compiles to JavaScript.

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.

– Alan Kay

> A system of cells interlinked within cells interlinked within cells interlinked within one stem.

– K, Blade Runner 2049 (Vladimir Nabokov, Pale Fire)


### Cells

It's cells all the way down, from modules to values. Cells consist of internal state (properties), code (statements) and behaviours (functions). Cells communicate by passing messages, represented as tuples `(key value key value …)`. Received messages are matched against behaviour signatures, which may be typed. There's no inheritance or prototypes, only composition and duck-typing. A cell is opaque, its internal state (properties) is not available from the outside, except through setters/getters.

Cells are passed by reference and implemented as persistent (immutable) data structures. The receiver of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. Mutating a cell creates a new version from that "view", with structural sharing of the past versions of its state.

The runtime is the stem.

```lua
-- the base cell, used as a blueprint for all cells
Cell {
    -- behaviour for cloning itself (matches an empty message)
    () -> {
        return `Object.assign(Object.create(null), self)`  -- embedded ECMAScript
    }
    
    -- behaviour for cloning itself with added properties (`$foo:` binds a value as a local name)
    (with $props:Tuple) -> {
        -- define a local property
        cell: &()  -- call the basic clone behaviour (`&` references the cell itself)
        
        -- call the `for` behaviour on the `$props, passing a behaviour to loop over its elements
        $props (for (each $key as $value) -> {
            cell (set $key to $value)  -- set an internal property on the cell
        })
        
        return cell
    }
    
    -- generic setter behaviour
    (set $key to $value) -> {
        return `self[$key] = $value`
    }
    
    -- freeze itself
    (freeze) -> {
        return `Object.freeze(self)`
    }
}

-- cell definition (uses Cell as its blueprint)
console {
    (log $value) -> `console.log($value)`
}

-- create a Replicant
Replicant {
     (move $meters:Number) -> {
        -- string interpolation referencing cell properties
        console (log "{&name} the {&model} replicant moved {$meters} meters")
    }
}

-- create a Rabbit cell using Animal as blueprint
Nexus9 from Replicant {
    -- properties (internal state)
    model: 'Nexus 9'
    thoughts: []  -- a list
    thoughtful: false
    
    -- function (a behaviour assigned to a property)
    think: ($thought:String) {
        thoughts (append $thought)
        console (log $thought)
    }
    
    -- a behaviour without arguments
    (move) -> {
        -- call the `log` behaviour of the `console` cell
        console (log '*moves*')
        
        -- call the `move` behaviour it got from `Animal`
        &(move 2)
        
        -- update internal state
        thoughtful (set true)

        -- call the `if-true` behaviour on the boolean `thoughtful` property
        thoughtful (if-true {
            think ('Why did I just move?')
            think ('Am I really a replicant?')
            think ('Do I even exist?')
        }
        else {
            think ("*nothing*")
        })
    }
}

-- create a new Nexus 9 replicant with some properties, then freeze it
officer-k: Nexus9 (with (name 'K' id 'KD6-3.7')) (freeze)

-- call the `move` behaviour
officer-k (move)

--> '*moves*'
--> 'K the Nexus 9 replicant moved 2 meters'
--> 'Why did I just move?'
--> 'Am I really a replicant?'
--> 'Do I even exist?'
```
