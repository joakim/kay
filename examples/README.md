# Examples

<sup>Note: This is mainly an exploration of possibilities. Consider it [Readme Driven](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) Programming Language Design. Some of it may be outdated.</sup>

## Blade Runner

An object-oriented example.

Note that this style is not enforced, the language is flexible enough to support other paradigms.

```lua
-- create a Replicant cell
Replicant: {
    -- fields
    *name: "Replicant"  -- mutable field
    model: "Generic"
    
    -- local method (assigned to a field)
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
    thoughts: []
    
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
-- literal for a cell
cell-literal: {
    -- ...
}

-- literal for a block cell (compound statements or closure in other languages)
block-literal: -> {
    -- ...
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
method-example: 'word (argument)' => {
    print (argument)
    return: "argument was {argument}"
}

-- an inlined method with one argument, having implicit `return` (lambda in other languages)
method-inlined: argument => true

-- literal for a receptor method
-- a receptor is simply a method that is not assigned to a field
'foo (bar)' => {
    -- expressions...
}

-- a receptor method illustrating how typed messages may be used
'enable-user username: (name: String) active: (enabled: Boolean)' => {
    -- messages are flexible text patterns that may contain slots `()` holding arguments
    -- a slot's matched value will be bound to a field of that name
    -- slots could support static typing, checking against type or protocol?
    
    -- `()` is also used to interpolate expressions (also fields) in slots when sending messages
    print (argument)
    
    -- while `{}` is used to interpolate expressions (also fields) in strings
    print "argument is {argument}"
}

-- a method cell without arguments
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

-- a table is an indexed/associative array, similar to lua's tables
object: [  -- associative (keyed)
    foo: 42
    bar: true
]
list: [1, 2, 3]  -- indexed (0-based)
tuple: [42, true]

-- mutating object fields
-- setters return the table itself, enabling chaining of messages
object foo: 42 | bar: false | baz: "qux"

-- looks nice when multiline (fluent interface)
object
    | foo: 42
    | bar: false
    | baz: "qux"

-- mutating a field by referencing its name using a local field's string value
key: "foo"
object (key): 42

-- a cell with a mutable field (only mutable from within)
mutable-field: {
    my: self
    *bar: true
    
    'mutate' => {
        my bar: false
    }
}
mutable-field mutate

-- fields are block scoped and may be shadowed by nested cells
scoped: {
    original: self
    inner: 42
    
    nested: {
        'answer' => {
            inner: "shadowed"  --> "shadowed" (a new, local field)
            return: original inner   --> `scoped`'s `inner`
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

-- here, `()` is needed to evaluate the field, or the unknown message 'bar' would be sent
print (bar)  --> 42
```
