# Ideas

Not all ideas are my own. Some are more wild than others. The wildest ones are probably mine.

(This is mostly a way for me to document my own thinking.)

<br/>

## Linguistics

| Classification | Role                  | Corresponding construct  |
| :------------- | :-------------------- | :----------------------- |
| Noun           | Names                 | Cell                     |
| Verb           | States action         | Method                   |
| Adjective      | Describes/limits noun | Protocol                 |

<br/>

## Learning

With its simple and flexible syntax, my hope is that this language could be a powerful tool for teaching programming concepts to kids worldwide, true to [the spirit of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/#smalltalkAndChildren). It should even be possible to translate its "globals" into other natural languages than English, enabling people to code in their native language.

<br/>

## Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), pure object-oriented message-based programming languages like Smalltalk are analogous to the Internet. While Smalltalk was a language for the _personal_ computer, this should be a language for the _global_ computer. I believe that such a language should be in tune with its environment: a language of _messages_ between _autonomous entities_.

If the Internet is a global machine, then the web runs in its application layer.

The lingua france of the web is JavaScript, a language with many faults but also some interesting qualities. It has a lightweight object-oriented approach, inspired by [Self](https://en.wikipedia.org/wiki/Self_(programming_language)) (prototype-based), coupled with functional programming features, inspired by [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)) (first-class functions/closures and immutable primitives). Its runtime environment is single-threaded, yet its [event loop](https://en.wikipedia.org/wiki/Event_loop) enables fast (enough) non-blocking concurrency, while being extremely error tolerant. The [V8](https://en.wikipedia.org/wiki/V8_(JavaScript_engine)) runtime even has ties to Smalltalk, its assembler was based on the [Strongtalk](https://en.wikipedia.org/wiki/Strongtalk) assembler. Smalltalk/Self and JavaScript have quite a few things in common.

In other words, it has to be a compile-to-JavaScript language (until [WebAssembly](https://en.wikipedia.org/wiki/WebAssembly) reaches maturity).

<sub>Fun fact: Kay's presentation was done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have many "good parts", hidden beneath layers of Java like syntax, quirks and inconsistencies. But those good parts are hard to get to, especially for beginners. Thought experiment: Imagine if Java hadn't happened, IBM had continued backing Smalltalk and Netscape had [chosen](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk or Self in 1995, to eventually become the lingua franca of the web. This project wouldn't have been necessary.</sub>

<br/>

## OOP + FP?

Extremes are not beneficial. While Clojure combines pure FP with managed stateful reference types, this language combines pure OOP with immutable data types and first-class functions.

Some aspects of a program may be best modelled using object-oriented thinking, while other aspects are best handled using functional programming principles. Structuring a project as discrete objects (code), interacting by sending messages containing immutable values (data), and internally processing those values using pure functions, may be the best of both worlds?

<br/>

## State

Differentiate between cells that are _objects_ (entities with behaviors) and cells that hold _values_ (data). Writable fields may be implemented like [Atoms](https://clojure.org/reference/atoms) in Clojure, as a reference type pointing to an immutable value type. This does add a level of indirection, with a performance and memory penalty, but it enables the sharing and management of state in a controlled way. Fields are read-only by default, requiring an explicit sigil (`*`) to initialize it as a writable reference type.

Having both _object_ cells (entities) and _value_ cells with immutable data types (data), allows one to reason about code in an intuitive yet beneficial way. Object cells are "concrete" autonomous entities with fields (state). Fields hold "abstract" immutable values, which if made writable can change over time. Object cells can only change their own fields directly. Other cells must ask for changes through messaging.

Abstract things (numbers, booleans, strings, dates, etc) are best represented as immutable data types, while "concrete" things are more intuitive when represented as objects with reference semantics. The challenge lies in uniting these two "worlds" in a way that makes sense and enables the expression of advanced programs with state managed safely over time.

### Time

Because time is of the essence.

[Rich Hickey's approach to identity and state](https://clojure.org/about/state) + [Bret Victor's Inventing on Principle](https://www.youtube.com/watch?v=PUv66718DII), only with cells? If writable fields are managed using "atoms", and all mutation of state is the swapping of immutable values by messages, the history of change may be (globally) recorded, rewound, paused, replayed, stepped through and inspected. [Transactions](https://clojure.org/reference/refs) may also be possible?

### Reactive

State as reactive as spreadsheets?

Must adher to Alan Kay's [Spreadsheet Value Rule](https://en.wikipedia.org/wiki/Spreadsheet#Values) (the word "cell" replaced with the word "field"):

1. A field's value relies solely on the formula the user has typed into the field
2. The formula may rely on the value of other fields, but those fields are likewise restricted to user-entered data or formulas
3. There are no "side effects" to calculating a formula: the only output is to display the calculated result inside its occupying field
4. There is no natural mechanism for permanently modifying the contents of a field unless the user manually modifies the field's contents
5. In the context of programming languages, this yields a limited form of first-order functional programming

#4 may have to be broken/reworded for this to be applicable to state in a programming language.

Data flow programming goes back to [Larry Tesler's 1968 language Compel](https://www.reddit.com/r/ProgrammingLanguages/comments/l1m4wr/a_language_design_for_concurrent_processes/). With the enormous success of spreadsheets (#1 programming environment), it's a wonder so few programming languages have caught on to its ideas.

<br/>

## Trees

The code and its AST is essentially a tree of cells within cells, reminiscent of Lisp's lists.

This enables some interesting ideas:

- Introspection and reflection
  - Easy traversal for introspection, analysis, refactoring, visualization, diffing, history/persistence, reflection, macros, etc
  - Reflection should probably not be accessible from running code, but require elevated permissions (developer environment, macros, etc)
  - Always-running environment like Smalltalk's [image-based](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence) VM, perhaps only during development?
- Metadata on the cell level
  - Extension of semantics
  - Tags, documentation, links, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen because it enables some of Bret Victor's powerful ideas (see [below](#development-environment))
  - An IDE may concretize/visualize cells, enabling inspection of their state and direct manipulation while running
  - The tree could facilitate adding time as a factor, with time travel debugging

This _could_ be implemented as a more low-level [intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation), like in [Bosque](https://github.com/microsoft/BosqueLanguage/), without any particular target language/system in mind. In any case, the focus should be on enabling a better developer experience.

### Not hierarchic, not necessarily anarchic, maybe holarchic?

[Holarchy](http://www.worldtrans.org/essay/holarchies.html) may be a more fruitful way to view the tree of cells. [Multi-agent system](https://en.wikipedia.org/wiki/Multi-agent_system) is another related concept. Without hierarchical subclassing, cells become autonomous interconnected entities (agents/actors). It's not [inheritance](https://en.wikipedia.org/wiki/Inheritance) (bestowal of rights), but [heredity](https://en.wikipedia.org/wiki/Heredity) (genetics). It's not about ruling, but about _cooperation_, _synergy_, _symbiosis_. Being _flexible_, not rigid.

[Hierarchy](https://en.wikipedia.org/wiki/Hierarchy#Etymology) – "rule of a high priest"  
[Anarchy](https://en.wikipedia.org/wiki/Anarchy#Etymology) – "without ruler"  
[Holarchy](https://en.wikipedia.org/wiki/Holarchy) – "a whole that is part of a larger whole"  

<br/>

## DSL

With such a simple syntax and underlying tree structure, the language should be very suitable for making embedded [DSLs](https://en.wikipedia.org/wiki/Domain-specific_language).

<br/>

## Directory structure

Files should not be the concern of the developer. The IDE should abstract away files and folders, allowing developers to focus on their mental model of the project. This doesn't have to be image-based like Smalltalk. For interoperability and version control, it should still use files and folders under the hood, matching the inherent structure of the project.

#### The problem

The current state of programming is full of distractions, taking away focus from what this artform is really all about: _designing_, _building_, _thinking_, _exploring_. This is especially true for beginners, who are faced with a number of hurdles that first have to be overcome before even being _able_ to write a line of code. Anyone should be able to jump right into a project and immediately write a line of code and see its result. To install an IDE and open a project is admittedly also a hurdle, but it's a much smaller one than the status quo of programming languages. It could even be built into the web browser. If not simply running [as a web app](https://microsoft.github.io/monaco-editor/). UNIX skills should not be a _requirement_ for programming.

<br/>

## Documentation

Documentation should be an integral part of the language. Not only in the shape of comments, but code itself should be self-documenting.

<br/>

## Development environment

Like Smalltalk, code should (be able to) be always running (at least during development).

### Features

- [Intelligent code completion](https://en.wikipedia.org/wiki/Intelligent_code_completion)
  - Message signatures with typed slots (and defaults) can take [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense) to [the next level](http://worrydream.com/LearnableProgramming/)
- Edit-in-place while running
- Breakpoints, with support for conditions
- Time travel, with intuitive navigation controls and visualization of changes
  - Similar to a browser (previous, next, reload)
  - Controls for run/pause, and which level to operate on (expression or breakpoint)

### Panes/views

  - **Outline** of the project's structure, with filters/search
    - **Internal** tab for navigating the project's own modules and cells
    - **External** tab for navigating and managing external modules (dependencies)
    - Allowing different _views_ of the project's structure (by hierarchy, tags, etc)
    - Could work as a menu: click a cell/method to insert it at the cursor
  - **State** for watching (or visualizing!) the state of specified cells
    - Allowing different _views_ into the project's state
    - By default showing the active/selected cell
  - **Terminal** for the [direct](https://en.wikipedia.org/wiki/Direct_mode) input of messages and output of their return value (REPL)
    - Full introspection and reflection capabilities (the developer is granted "God mode")
    - Could be just an input field at the bottom, with the result shown as an overlay just above it
      - History can be navigated by up/down keys, showing the result for each message in the overlay
  - **Log** for the output of _log_ and _error_ messages (separate from the terminal), with filters/search
  - **Network** for inspecting network activity, with filters/search
  - **Stack** for the current stack trace when paused
  - **Profile** for performance profiling of code
  - **Cards** for [interacting](https://github.com/bhauman/devcards) with the project, producing visual test cases and examples?

<br/>

## Forests

Speaking of [trees](#trees), it makes a lot of sense to think about apps/servers as multicellular organisms communicating through soil/air/water. Trees in forests communicate by sending chemical signals (messages) and nutrients (data) over [fungal networks](https://en.wikipedia.org/wiki/Mycorrhiza), as well as [pheromones](https://en.wikipedia.org/wiki/Pheromone) through the air. Similarly, apps/servers need fungi/air/water to communicate with each other, either over short ([inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication)) or long ([networks](https://en.wikipedia.org/wiki/Computer_network)) distances. The Internet already works (and looks) a lot like fungi. But I'm sure we could do even better.

One characteristic that plants and apps have in common is that they are immobile, in contrast to animals. Apps running on a mobile device is like taking potted plants for a walk. Plant cells may be a more suitable model for computing than animal cells, at least for now.

<br/>

## Evolution

Taking inspiration from (my limited understanding of) molecular biology to the extreme:

- Cells are like [plant stem cells](https://en.wikipedia.org/wiki/Plant_stem_cell)
- Every cell has a nucleus with DNA (encoded information) with restricted access from outside the nucleus
- They are isolated from their environment, protected by a membrane
- They act on messages in their environment, picked up through receptors
- They emit messages into their environment
- Messages have a signature, but no address, and may be picked up by any matching receptor
- Always adapting to stimuli, the DNA in a cell may mutate over time, but most change is epigenetic
- Cells build ever-evolving organisms of differentiated cells, based on their ever-evolving DNA
- The (encoded/encrypted) DNA holds the "recipe" for an entire organism
- Program state as the emerging phenomenon of conciousness?

Good luck implementing _[that!](https://en.wikipedia.org/wiki/Hard_problem_of_consciousness)_

<br/>

## Values within cells within modules within one runtime?

Not "it's cells all the way down", but JavaScript's "([almost](https://stackoverflow.com/questions/9108925/how-is-almost-everything-in-javascript-an-object)) everything is an object".

In this perspective, the **module** is the cell. As in biological cells, there can be various subcellular components, including [endosymbiotic](https://en.wikipedia.org/wiki/Endosymbiosis) "cells within cells" ([Mitochondrion](https://en.wikipedia.org/wiki/Mitochondrion), [Plastids](https://en.wikipedia.org/wiki/Plastid)) and other organelles. These subcellular cells are lighter and simpler than the module, but share the same general features (encapsulation, receptors/behaviors, etc).

That makes it 4 levels to reason about:

1. `Runtime` – Environment
2. `Module` – [Eukaryotic](https://en.wikipedia.org/wiki/Eukaryote#Cell_features) cell
3. `Cell` – [Endosymbiotic](https://en.wikipedia.org/wiki/Endosymbiosis) cell
4. `Value` – [Proteins](https://en.wikipedia.org/wiki/Protein) and other [biomolecules](https://en.wikipedia.org/wiki/Biomolecule)

<sup>Don't tell FP developers, but one _could_ view functions as bacteria. Or [mitochondria](https://en.wikipedia.org/wiki/Mitochondrion), to be precise. "Mitochondria are typically round to oval in shape and range in size from 0.5 to 10 μm" – sounds about right. "Mitochondria are often referred to as the powerhouses of the cell. They help turn the energy we take from food into energy that the cell can use."</sup>

Viewing a module as "the cell" makes sense. Modules/cells are the building blocks of the app/organism. Specialized, differentiated, loosely coupled. Inside you'll find a tiny contained universe of smaller structures, functionality and data that can be reasoned about in isolation.

Instead of _the cell's local state_ being its nucleus, perhaps a better analogy is _the database_ (persisted state)? Of course, each cell doesn't have its own database, but the biology-computing analogy only goes so far. The size of the human genome is [~700 MB](https://medium.com/precision-medicine/how-big-is-the-human-genome-e90caa3409b0).

<br/>

## Numbers

> Exact number manipulation is a true advantage of Smalltalk. If a SmallInteger operation leaves its range, the result becomes a LargeInteger. 

The JavaScript number magic equivalent would be `Number` -> `BigInt` if the number is an integer.
