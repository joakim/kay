# Kay

A small programming language inspired by Smalltalk and Blade Runner that compiles to JavaScript.

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.

– Alan Kay

> A system of cells interlinked within cells interlinked within cells interlinked within one stem.

– Vladimir Nabokov, Pale Fire


### Cells

It's cells all the way down, from modules to values. Cells consist of internal state, code and behaviours. They communicate by listening for and passing messages (represented as tuples `()`). Messages are pattern matched against behaviours and may be typed. There's no inheritance, only composition and behavioural traits. A cell's properties (its internal state) are not available from the outside except through setters/getter.

Cells are passed by reference and implemented as persistent (immutable) data structures. The receiver of a cell gets a "view" of the cell's state as it was at that particular instant in time. Mutating a cell creates a new version from that "view", with structural sharing of its past states.

The runtime is the stem.

```lua
-- the base cell, used as a blueprint for all cells
Cell {
    -- behaviour for cloning itself (matches an empty message)
    () {
        return `Object.assign(Object.create(null), self)`  -- embedded ECMAScript
    }
    
    -- behaviour for cloning itself with added properties ($foo: binds a value as a local name)
    (with $props:Tuple) {
        -- local property (& references the cell itself)
        cell: &()  -- call the basic clone behaviour
        
        -- call the iterate behaviour on the $props tuple, with a lambda to iterate its elements
        $props (iterate ($key $value) -> {
            -- set internal properties on the cell
            cell (set $key to $value)
        })
        
        return cell
    }
    
    -- generic setter behaviour
    (set $key to $value) {
        &$key: $value
    }
    
    -- freeze a cell
    (freeze) {
        return `Object.freeze(self)`
    }
}

-- cell definition (uses Cell as its blueprint)
Console {
    (log $value): `console.log($value)`
}

-- create an Animal cell
Animal {
     (move $distance:Number) {
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
    (move) {
        -- call the `log` behaviour of the `Console` cell
        Console (log '*jumps*')
        
        -- call the `move` behaviour it got from `Animal`
        &(move 5)
        
        -- update internal state
        thoughtful (set true)
        
        -- call the internal `think` function
        think ('Why did I just jump?')
        think ('What is my purpose?')
        think ('Why do I exist?')
    }
}

-- create a new Rabbit cell with some properties, then freeze it
rabbit: Rabbit (with (name 'Roger' color 'white')) (freeze)

-- call the `move` behaviour on the rabbit
rabbit (move)

--> '*jumps*'
--> 'Roger the white rabbit moved 5m'
--> 'Why did I just jump?'
--> 'What is my purpose?'
--> 'Why do I exist?'
```
