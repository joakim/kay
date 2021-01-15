# Examples

<sup>Note: This is mainly an exploration of possibilities. Consider it [Readme Driven](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) Programming Language Design. Some of it may be outdated.</sup>

## Blade Runner

An object-oriented example.

Note that this style is not enforced, the language is flexible enough to support other paradigms.

```lua
-- create a Replicant cell
Replicant: {
    -- slots
    *name: "Replicant"  -- writable slot
    model: "Generic"
    
    -- local method (assigned to a slot)
    say: '(words)' => {
        print "{name} says: {words}"
    }
    
    -- receptor method (responds to messages from the outside)
    'move (distance)' => {
        meters: distance = 1 | "meter" if true else "meters"
        print "{name} the {model} replicant moved {distance} {meters}"
    }
}

-- create a Nexus9 cell by cloning and extending the Replicant cell
Nexus9: Replicant {
    replicant: self
    model: "Nexus 9"
    intelligence: 100
    thoughts: *[]  -- dynamic array
    
    think: '(thought)' => {
        -- send an `append` message to the `thoughts` array with the `thought` argument's value
        thoughts append (thought)
        print "{name} thinks: {thought}"
    }
    
    'move' => {
        print "*moves*"
        
        -- signal the `move (distance)` receptor cloned from `Replicant`
        replicant move 2
        
        -- signal receptors of the boolean result of `>`, equivalent to an if statement
        intelligence > 100
            | if true -> {
                think "Why did I move?"
                think "Am I really a replicant?"
                think "My name is Joe..."
                
                -- mutate the state of an outer cell
                replicant name: "Joe"
                say "My name is {name}!"
            }
            | if false -> think "*crickets*"
    }
}

-- create a new Nexus 9 replicant
officer-k: Nexus9 { name: "K", intelligence: 140 }

-- signal its `move` receptor
officer-k move

--> "*moves*"
--> "K the Nexus 9 replicant moved 2 meters"
--> "K thinks: Why did I move?"
--> "K thinks: Am I really a replicant?"
--> "K thinks: My name is Joe..."
--> "Joe says: I have a purpose!"
```

<br/>

## Features

Cells within cells interlinked: `Environment > Modules > (Cells > Cells...) > Values`

```lua
-- literal for a record cell
record-literal: {}

-- a record cell with a slot (object with a private property in other languages)
record-example: {
    answer: 42
}

-- literal for a block cell (compound statements or closure in other languages)
block-literal: -> {
    -- expressions...
}

-- a block sent as an argument to the `if (condition) (then)` receptor of `true`
block-example: true | if true -> {
    truth: "It is true"
    print (truth)
}

-- literal for a method cell (function or private method in other languages)
method-literal: => {
    -- expressions...
}

-- a method cell that receives a message, prints its argument and returns a string
method-example: '(argument)' => {
    print (argument)
    return: "argument was {argument}"
}

-- an inlined method cell, having implicit `return` (lambda in other languages)
method-inlined: '(argument)' => true

-- literal for a receptor method (similar to object method in other languages)
-- a receptor is simply a method that is not assigned to a slot
'foo (bar)' => {
    -- expressions...
}

-- a receptor method illustrating how messages are used
'receptor with one (argument)' => {
    -- messages are flexible text patterns that may contain arguments
    -- arguments are enclosed in `()`, the matched value will be bound to a slot of that name
    -- the syntax could be extended to support typed arguments
    
    -- `()` is similarly used to interpolate expressions (also slots) when sending messages
    print (argument)
    
    -- `{}` is used to interpolate expressions (also slots) in strings
    print "argument is {argument}"
}

-- a method cell without arguments (equivalent to a function expression with no arguments)
method: => {
    a: 2
    b: 3
    result: a + b
    print "{a} + {b} = {result}"
    return: result
}

-- calling the method using `do` (an environment method)
result: do (method)  --> "2 + 3 = 5"
print (result)       --> 5

-- an exposed record with all slots writable, marked with `*` (object/struct/dict in other languages)
mutable: *{
    foo: 42
    bar: true
}

-- mutating slots from outside the cell
-- setters return the cell itself, enabling chaining of messages
mutable (foo: 10) (bar: false)

-- simpler syntax using the pipeline operator
mutable foo: 10 | bar: false

-- looks great when multiline (fluent interface)
mutable
    | foo: 10
    | bar: false

-- mutating a slot by referencing its name using a local slot's value
key: "foo"
mutable (key): 42

-- a record cell with a writable slot (only writable from within)
writable-slot: {
    my: self
    *bar: true
    
    'mutate' => {
        my bar: false
    }
}
writable-slot mutate

-- slots are block scoped and may be shadowed by nested cells
scoped: {
    inner: 42
    
    nested: {
        'answer' => {
            original: inner       --> 42 (a clone of `inner`)
            inner: "shadowed"     --> "shadowed" (a new, local slot)
            return: original
        }
    }
    
    'answer' => {
        nested answer
    }
}

-- expressions can be grouped/evaluated with `()` and messages pipelined/chained with `|`
print (scoped answer = 42 | "Indeed" if true)  --> "Indeed"

-- a method demonstrating closure
adder: '(x)' => {
    return: '(y)' => {
        return: x + y
    }
}

add-5: adder 5
add-10: adder 10

print (add-5 2)   --> 7
print (add-10 2)  --> 12

-- inlined version of the `adder` method
inlined: '(x)' => '(y)' => x + y

-- as in the self language, assignment is really setter signals on the current cell (`self`)
foo: 42  -- syntactic sugar
self foo: (42)  -- desugared

-- assignment is special, what follows `:` is evaluated as an expression, so `()` is not needed
bar: foo
self bar: (foo)  -- desugared

-- here, `()` is needed to evaluate the slot, or the unknown message 'bar' would be sent
print (bar)  --> 42
```

<br/>

## Building blocks

> The cell is the basic structural, functional, and logical unit of all known programs. A cell is the smallest unit of code. Cells are often called the "building blocks of code".

<sup>Paraphrased from the Wikipedia article on [Cell (biology)](https://en.wikipedia.org/wiki/Cell_(biology)).</sup>

```lua
-- the void type is a special cell that only ever returns itself
{}: { '_' => { return: self } }

-- all other cells descend from the base Cell
Cell: {
    cell: self
    lineage: *[{}]
    exposed: {}
    
    -- slot initialization
    set: '(key): ...(value)' => `Reflect.set(cell, key, value)`
    
    -- exposed slot initialization (`*`) is syntactic sugar for this method
    expose: '(key): ...(value)' => exposed (key): value
    
    -- clones itself (matches an empty message)
    '' => {
        clone: `Object.assign(Object.create(null), cell)`
        
        -- append a reference to itself as the parent of the clone
        `clone.lineage.push(WeakRef(cell))`
        
        return: clone
    }
    
    -- clones itself, merging with the specified cell(s), enabling composition of multiple cells
    '(spec)' => {
        clone: cell
        
        -- merge slots into the clone
        merge: '(slots)' => {
            slots each '(key) (value)' => `Reflect.set(clone, key, value)`
        }
        
        -- if merging with an array of cells, merge each cell in turn
        spec is array
            | if true -> spec each '(item)' => merge (item)
            | if false -> merge (spec)
        
        return: clone
    }
    
    -- returns the cell's lineage
    'lineage' => lineage
    
    -- exposed slot checker
    'has (key)' => `Reflect.has(cell.exposed, key)`
    
    -- exposed slot setter (returns itself, enabling piping/chaining)
    '(key): (value)' => {
        (cell is exposed) and (cell has (key))
            | if true -> `Reflect.set(cell.exposed, key, value)`
        return: cell
    }
    
    -- conditionals (replaces if statements, any cell can define its own truthy/falsy-ness)
    'if (condition) (then)' => { `(equals(cell, condition) && do(then))`, return: cell }
    'if (condition) (then) else (else)' => { `(equals(cell, condition) ? do(then) : do(else))`, return: cell }
    '(value) if (condition)' => `(equals(cell, condition) ? value : undefined)`
    '(value-1) if (condition) else (value-2)' => `equals(cell, condition) ? value_1 : value_2`
    
    -- returns whether the cell is exposed
    'is exposed' => Boolean (exposed size)
    
    -- checks whether the cell has a receptor matching the signature
    'has receptor (signature)' => `cell.hasReceptor(signature)`
    
    -- applies a receptor of this cell to another cell
    'apply (message) to (other)' => `Reflect.apply(cell, other, message)`
}

-- definition of the Value cell
Value: {
    cell: self
    
    -- internal value and its validators, preprocessors and subscribers
    value: {}
    validators: *[]
    preprocessors: *[]
    subscribers: {}
    
    -- local setter method for mutating the internal value
    set: '(value)' => {
        -- validate and preprocess...
        `(cell.value = value, cell)`
    }
    
    -- local pattern match checker
    matches: '(pattern)' => {
        -- ...
    }
    
    -- constructor
    '(value)' => {
        clone: cell
        `clone.value = value`
        return: clone
    }
    
    -- checker
    'is value' => true
    
    -- unwraps the internal value
    'unwrap' => `cell.value`
    
    -- adds a validator for the value
    'add validator (validator)' => { validators append (validator) }
    
    -- adds a preprocessor for the value
    'add preprocessor (preprocessor)' => { preprocessors append (preprocessor) }
    
    -- adds a subscriber to an event
    'on (event) (subscriber)' => { subscribers (event) | append (subscriber) }
    
    -- pattern matching
    'match (alternatives)' => {
        alternative: alternatives find '(method)' => matches (method signature)
        return: do (alternative)
    }
    
    -- conditionals (checking the value slot)
    'if (condition) (then)' => { `(equals(cell.value, condition) && do(then))`, return: cell }
    'if (condition) (then) else (else)' => { `(equals(cell.value, condition) ? do(then) : do(else))`, return: cell }
    '(value) if (condition)' => `(equals(cell.value, condition) ? value : undefined)`
    '(value-1) if (condition) else (value-2)' => `equals(cell.value, condition) ? value_1 : value_2`
}

-- definition of the Boolean value
Boolean: Value {
    cell: self
    
    -- preprocess the value before being set, casting it to a boolean
    cell add preprocessor '(value)' => `Boolean(value)`
    
    'and (other-value)' => `cell.value && other_value`
    
    -- negates the value
    'negate' => set `!cell.value`
}

-- instantiated booleans (primitives on the environment cell)
true: Boolean 1
false: Boolean 0

-- toggling a boolean
bool: true
bool negate
print (bool)  --> false "(the value is automagically unwrapped when read)"

-- definition of the Array value
Array: Value {
    cell: self
    
    'is array' => true
    'first' => `cell.value[0]`
    'last' => `cell.value[value.length - 1]`
    'append (value)' => `cell.value = [...cell.value, value]`
    'prepend (value)' => `cell.value = [value, ...cell.value]`
    'map (mapper)' => `cell.value.map(mapper)`
    'each (handler)' => `cell.value.forEach(handler)`
    -- ...
}

-- `print` is a slot on the environment cell that is a method cell
print: '(value)' => console log (value)

-- `console` is a cell with receptors
console: {
    'log (value)' => `console.log(value)`
    -- ...
}

-- the `do` method
do: '(cell)' => `cell()`
```

<br/>

## Biological cell simulation

Disclaimer: I am not a molecular biologist! (Nor am I a computer scientist.)

```lua
foobar: Cell {
    cell: self
    
    dna: *{
        foo: 40
    }
    
    rna: Queue new
    ribosomes: Set new
    
    transcribe: '(value)' => {
        instructions: {
            -- ...
        }
        foo ≥ 42 | if true -> rna put (instructions)
    }
    
    ribosome: {
        process: '(instructions)' => {
            protein: Protein from (instructions)
            cell emit (protein)
        }
        
        loop -> {
            instructions: await (rna take promise)
            process (instructions)
        }
    }
    
    ribosomes add (ribosome)
    
    dna on change (transcribe)
    
    'increase foo' => {
        dna foo | increment
    }
}

foobar increase foo
foobar increase foo

-- A new protein is emitted!
```
