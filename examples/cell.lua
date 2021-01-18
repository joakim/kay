-- Biological cell simulation

-- Disclaimer: I am not a molecular biologist! (Nor am I a computer scientist.)

foobar: Cell {
    cell: self
    
    dna: [
        foo: 40
    ]
    
    rna: Queue new
    ribosomes: Set new
    
    transcribe: '(value)' => {
        instructions: {
            -- ...
        }
        dna foo | ≥ 42 | if true -> rna put (instructions)
    }
    
    ribosome: {
        process: '(instructions)' => {
            protein: Protein from (instructions)
            cell << events emit "protein" (protein)
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
foobar increase foo -- A new protein is emitted!
