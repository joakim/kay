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

It's cells all the way down, from modules to values. Cells consist of local state (properties), code (statements and expressions) and methods (functions). Cells communicate by passing messages. Received messages are dynamically matched against method signatures, which may be typed. There's no inheritance or prototypes, only composition and duck-typing. A cell is fully opaque, its local state (properties) is not available from the outside except through setters/getters. A cell can not crash, any exceptions are handled internally.

Cells are passed by reference and implemented as persistent data structures. The receiver of a cell gets a "view" of the cell's state _as it was_ at that particular instant in time. Mutating a cell creates a new version from that "view", based on structural sharing of its past versions.

The runtime environment is the stem.

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
    
    -- a method
    (move $meters) => {
        -- calling a method on another object
        console log "{name} the {model} replicant moved {$meters} meters"
    }
    
    -- a local method (a method assigned to a property)
    say: ($words) => {
        console log "{name} says: {$words}"
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
    
    -- a method without any arguments
    (move) => {
        console log '*moves*'
        
        -- call the `move $meters` method "inherited" from `Replicant`
        self move 2
        
        -- if…else "statement" using the `yes-no` method of `Boolean`
        intelligence > 100 (yes {
            think 'Why did I move?'
            think 'Am I really a replicant?'
            think 'Do I even exist?'
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

-- call the `move` method
officer-k move

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
    -- method for cloning itself (matches an empty message)
    () => `Object.assign(Object.create(null), self)`
    
    -- method for cloning itself with added features (`$x:` binds a value as a local name)
    (with $properties:Tuple) => {
        clone: self ()
        
        -- call the `for` method on `$properties`, passing a method to loop over its items
        $properties for (each $key as $value) => {
            clone set $key to $value
        }
        
        -- add the parent object as an ancestor
        (clone get lineage) prepend (WeakRef self)
        
        return clone
    }
    
    -- setter method for mutating object properties
    (set $key to $value) => `self[$key] = $value`
    
    -- getter
    (get $key) => `self[$key]`
    
    -- freeze itself
    (freeze) => `Object.freeze(self)`
    
    -- method for applying a method to the caller
    (apply $message to $cell) => `Reflect.apply(self, $cell, $message)`
    
    lineage: [{}]
}

-- definition of the base Value object
Value: Object with {
    -- internal value
    value: {}
    
    -- constructor
    ($value) => (self ()) set $value
    
    -- setter
    (set $value) => self set value to $value
    
    -- getter
    (get) => self get value
    
    -- lineage: [WeakRef Object, {}]
}

-- definition of the Boolean value
Boolean: Value with {
    -- setter method, overriding the one "inherited" from Value
    (set $value) => `(self.value = Boolean($value), self)`
    
    -- toggle method
    (toggle) => self set `!value`
    
    -- yes-no method ("if-then-else", "if-then" and "if-not")
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
    (first) => `value[0]`
    (last) => `value[value.length - 1]`
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
