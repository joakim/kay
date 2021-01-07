# Kay

A small programming language inspired by Smalltalk and Blade Runner that compiles to JavaScript.

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.

– Alan Kay

> A system of cells interlinked within cells interlinked within cells interlinked within one stem.

– Vladimir Nabokov, Pale Fire


### Cells

It's cells all the way down, from modules to values. Cells consist of internal state, code and behaviours. They communicate by listening for and passing messages (represented as tuples `()`). Messages are pattern matched against behaviours and may be typed. There's no inheritance, only composition and behavioural traits.

Cells are passed by reference and implemented as persistent (immutable) data structures. The "reader" of a cell gets a "view" of the cell's state as it was on that particular instant in time. Mutating a cell creates a new version from that "view", with structural sharing of its past states.

The runtime is the stem.

```lua
-- the base cell cell
Cell {
    -- basic factory (matches an empty message)
    () {
        return `Object.assign(Object.create(null), this)`  -- embedded ECMAScript
    }
    
    -- factory taking a spec tuple ($ binds a message value as a local name)
    (with $spec:Tuple) {
        -- local property (& references the cell)
        cell: &()  -- call the more basic factory behaviour
        
        -- call the iterate behaviour on the $spec tuple, passing a function to iterate its elements
        $spec (iterate ($key $value) -> cell (set $key $value))
        
        return cell
    }
    
    -- generic setter
    (set $key to $value) {
        &$key: $value
    }
}

-- cell definition (uses Object as blueprint)
Console {
    (log $value): `console.log($value)`
}

-- create an Animal cell
Animal {
     (move $distance:Number) {
        -- string interpolation
        Console (log "{&name} the {&color} {&kind} moved {$distance}m")
    }
}

-- create a Rabbit cell using Animal as blueprint
Rabbit from Animal {
    -- properties (internal state)
    thoughtful: false
    thoughts: []  -- a list
    
    -- function (a cell with only one behaviour)
    think: ($thought:String) {
        thoughts (append $thought)
        Console (log $thought)
    }
    
    -- behaviour
    (move) {
        -- call the `log` behaviour of the `Console` cell
        Console (log '*jumps*')
        
        -- call the `move` behaviour inherited from `Animal` (through composition, not prototype/class)
        &(move 5)
        
        -- call an internal function
        think ('Why did I just jump?')
        think ('What is my purpose?')
        think ('Why do I exist?')
    }
}

-- create an "instance" of a rabbit
rabbit: Rabbit (with (name 'Roger' color 'white'))

-- call a behaviour on the "instance"
rabbit (move)

--> '*jumps*'
--> 'Roger the white rabbit moved 5m'
--> 'Why did I just jump?'
--> 'What is my purpose?'
--> 'Why do I exist?'
```
