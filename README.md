# Kay

A small programming language inspired by Smalltalk and Blade Runner that compiles to JavaScript.

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.

– Alan Kay

> A system of cells interlinked within cells interlinked within cells interlinked within one stem.

– Vladimir Nabokov, Pale Fire


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
        -- define a local property (`&` references the cell itself)
        cell: &()  -- call the basic clone behaviour
        
        -- call the `for` behaviour on the `$props` tuple, with a lambda to iterate its elements
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
Console {
    (log $value) -> `console.log($value)`
}

-- create an Animal cell
Animal {
     (move $distance:Number) -> {
        -- string interpolation referencing cell properties
        Console (log "{&name} the {&color} {&kind} moved {$distance}m")
    }
}

-- create a Rabbit cell using Animal as blueprint
Rabbit from Animal {
    -- properties (internal state)
    thoughtful: false
    thoughts: []  -- a list
    
    -- function (a behaviour assigned to a property)
    think: ($thought:String) {
        thoughts (append $thought)
        Console (log $thought)
    }
    
    -- a behaviour without arguments
    (move) -> {
        -- call the `log` behaviour of the `Console` cell
        Console (log '*jumps*')
        
        -- call the `move` behaviour it got from `Animal`
        &(move 2)
        
        -- update internal state
        thoughtful (set true)

        -- call the `if-true` behaviour on the boolean `thoughtful` property
        thoughtful (if-true {
            think ('Why did I just jump?')
            think ('Am I really a rabbit?')
            think ('Do I even exist?')
        }
        else {
            think ("D'oh!")
        })
    }
}

-- create a new Rabbit cell with some properties, then freeze it
roger: Rabbit (with (name 'Roger' color 'white')) (freeze)

-- call the `move` behaviour on the rabbit
roger (move)

--> '*jumps*'
--> 'Roger the white rabbit moved 2m'
--> 'Why did I just jump?'
--> 'Am I really a rabbit?'
--> 'Do I even exist?'
```
