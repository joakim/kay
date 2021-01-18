-- > The cell is the basic structural, functional, and logical unit of all known programs.
-- > A cell is the smallest unit of code. Cells are often called the "building blocks of code".
-- Paraphrased from https://en.wikipedia.org/wiki/Cell_(biology)

-- the void type is a special cell that only ever returns itself (or a fallback)
nothing: {
    '? (fallback)' => fallback
    _ => nothing
}

-- all other cells descend from the base Cell
Cell: {
    cell: self
    lineage: [{}]
    
    -- field initialization
    set: '(key): ...(value)' => `Reflect.set(cell, key, value)`
    
    -- clones itself
    'clone' => {
        clone: `Object.assign(Object.create(null), cell)`
        
        -- append a reference to itself as the parent of the clone
        `clone.lineage.push(WeakRef(cell))`
        
        return: clone
    }
    
    -- clones itself, merging with the specified cell(s) (initialization/mixins)
    '(spec)' => {
        clone: cell clone
        
        -- merge fields into the clone
        merge: '(mixin)' => {
            -- evaluate the mixin, giving it a chance to initialize itself
            fields: do (mixin)
            
            -- copy over its fields to the clone
            fields each '(key) (value)' => `Reflect.set(clone, key, value)`
        }
        
        -- if merging with an array of cells, merge each cell in turn
        spec is array
            | if true -> spec each '(item)' => merge (item)
            | if false -> merge (spec)
        
        return: clone
    }
    
    -- returns the cell's lineage
    'lineage' => lineage
    
    -- conditionals (replaces if statements, any cell can define its own truthy/falsy-ness)
    'if (condition) (then)' => { `(equals(cell, condition) && do(then))`, return: cell }
    'if (condition) (then) else (else)' => { `(equals(cell, condition) ? do(then) : do(else))`, return: cell }
    '(value) if (condition)' => `(equals(cell, condition) ? value : undefined)`
    '(value-1) if (condition) else (value-2)' => `equals(cell, condition) ? value_1 : value_2`
    
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
    validators: []
    preprocessors: []
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
    
    -- conditionals (checking the value field)
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

-- `print` is a field on the environment cell that is a method cell
print: '(value)' => console log (value)

-- `console` is a cell with receptors
console: {
    'log (value)' => `console.log(value)`
    -- ...
}

-- the `do` method
do: '(cell)' => `cell()`
