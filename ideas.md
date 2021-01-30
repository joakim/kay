# Ideas

Not all ideas are my own. Some are more wild than others. The wildest ones are probably mine.

(This is mostly a way for me to document my own thinking.)

<br/>

## Linguistics

| Classification | What is does          | Corresponding construct |
| :------------- | :-------------------- | :---------------------- |
| Noun           | Names                 | Cell                    |
| Verb           | States action         | Function                |
| Adjective      | Describes/limits noun | Protocol                |

<br/>

## Learning

With its simple syntax and semantics, my hope is that this language could be a powerful tool for teaching programming to kids worldwide, true to [the spirit of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/#smalltalkAndChildren).

It should even be possible to translate into other natural languages than English, enabling people to code in their native language!

<br/>

## Pure OOP

Most object-oriented languages are highly complex, while pure OOP languages like Smalltalk and Self have almost Lisp like qualities. This language aims to bring back that simplicity of the early Smalltalks, and goes even further by leaving out classical inheritance (apologies to Nygaard).

Instead of subclassing, there's cloning. Instead of interfaces, there's protocols. Inheritance becomes a question of [heredity](https://en.wikipedia.org/wiki/Heredity), not of [bestowal of rights](https://en.wikipedia.org/wiki/Inheritance). It's not about _ruling_, but about _synergy_, _symbiosis_, _cooperation_. It's not about _hierarchy_, but about being _flexible_. In that spirit, cloning may be done by concatenation (mixin) or delegation (prototype).

<br/>

### Not hierarchic, not necessarily anarchic, maybe holarchic?

[Hierarchy](https://en.wikipedia.org/wiki/Hierarchy#Etymology) – "rule of a high priest"  
[Anarchy](https://en.wikipedia.org/wiki/Anarchy#Etymology) – "without ruler"  
[Holarchy](https://en.wikipedia.org/wiki/Holarchy) – "a whole that is part of a larger whole"  

[Holarchy](http://www.worldtrans.org/essay/holarchies.html) may be a more fruitful way to view cells. [Multi-agent system](https://en.wikipedia.org/wiki/Multi-agent_system) is another related concept. Without hierarchical subclassing, cells become autonomous interconnected entities ([actors](https://en.wikipedia.org/wiki/Actor_model)).

<br/>

### + Pure FP

Extremes are not beneficial. While Clojure combines pure functional programming with managed stateful reference types, this language combines pure OOP with immutable value types and first-class functions.

Certain aspects of a program might be best modelled using object-oriented thinking, while other aspects best handled using functional programming principles. Structuring a project as discrete entities, interacting by sending messages containing immutable values, and internally processing those values using pure functions, might be the best of both worlds?

<br/>

## The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), a pure object-oriented message-based programming language like Smalltalk resembles the Internet. While Smalltalk was a language for the _personal_ computer, this should be a language for the _global_ computer. I believe that such a language has to be in tune with its environment: a language of _messages_ between _autonomous entities_.

If the Internet is a global machine, then the web runs on its application layer.

The lingua franca of the web is JavaScript, a language with many faults but also some interesting qualities. It has a lightweight object-oriented approach inspired by [Self](https://en.wikipedia.org/wiki/Self_(programming_language)) (prototype-based), coupled with functional programming features inspired by [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)) (immutable primitives and first-class functions). Its runtime environment is single-threaded, yet its [event loop](https://en.wikipedia.org/wiki/Event_loop) enables fast (enough) non-blocking concurrency, while being extremely error tolerant. The [V8](https://en.wikipedia.org/wiki/V8_(JavaScript_engine)) runtime even has ties to Smalltalk, its assembler was based on the Strongtalk assembler. Smalltalk/Self and JavaScript have quite a few things in common.

In other words, this has to be a compile-to-JavaScript language (at least until [WebAssembly](https://en.wikipedia.org/wiki/WebAssembly) reaches maturity).

<sub>Fun fact: Kay's presentation was done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have many "good parts", hidden beneath layers of Java like syntax, quirks and inconsistencies. But those good parts are hard to get to, especially for beginners. Thought experiment: Imagine if Java hadn't happened, IBM had continued backing Smalltalk and Netscape had [chosen](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk or Self in 1995, to eventually become the lingua franca of the web. This project wouldn't have been necessary.</sub>

<br/>

## State

The fields of cells are read-only by default. Mutating fields directly is discouraged. A field points to either a cell (by reference) or an immutable value type. (Value types are [autoboxed](https://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Autoboxing) to their corresponding _value_ cell when used a recipient of a message.)

With all this immutability, how does one mutate state? Mutability can be implemented using something like Clojure's [atoms](https://clojure.org/reference/atoms) – a reference type (cell) wrapping an immutable value type, with [behaviors for replacing](https://clojure.github.io/clojure/clojure.core-api.html#clojure.core/swap!) the current value with a new one. This does add one level of indirection, having some performance and memory penalty, but it enables the management of state in a controlled way. Reads should still be fast. As a bonus, it enables reactivity, validation and metadata.

The differentiation of _entities_ and _values_ as two fundamental concepts, as opposed to "everything is an object", may be helpful when reasoning about code. An _object_ cell is a "concrete" thing with reference semantics, behaviors and internal state. Its fields can hold "abstract" things with value semantics (numbers, booleans, strings, dates, collections, etc). Although they are in fact immutable, they may be replaced over time if wrapped in a _value_ cell. "Concrete" entities containing "abstract" values.

The challenge lies in uniting those two worlds in a way that makes sense intuitively while enabling the expression of advanced programs, with state managed safely over time.

<br/>

### Time

Because time is of the essence.

The idea is to combine [Rich Hickey's approach to identity and state](https://clojure.org/about/state) with [Bret Victor's Inventing on Principle](https://www.youtube.com/watch?v=PUv66718DII), using cells. If mutability is managed with atoms, and all mutation of state is the swapping of immutable values by messaging, the history of changes may be (globally) recorded, rewound, paused, replayed, stepped through and inspected. [Transactions](https://clojure.org/reference/refs) may also be possible?

<br/>

### Reactive

When all mutation of state is done by messaging, reactivity is a short step away. Maybe even as reactive as spreadsheets?

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
  - Always-running environment like Smalltalk's [image-based](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence) VM, but only during development?
- Metadata on the cell level
  - Extension of semantics
  - Tags, documentation, links, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen because it enables some of Bret Victor's powerful ideas (see [below](#development-environment))
  - An IDE may concretize/visualize cells, enabling inspection of their state and direct manipulation while running
  - The tree could facilitate adding time as a factor, with time travel debugging

This _could_ be implemented as a more low-level [intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation), like in [Bosque](https://github.com/microsoft/BosqueLanguage/), without any particular target language/system in mind. In any case, the focus should be on enabling a better developer experience.

<br/>

## Directory structure

Files should not be the concern of the developer. The IDE should abstract away files and folders, allowing developers to focus on their mental model of the project. This doesn't have to be image-based like Smalltalk. For interoperability and version control, it should still use files and folders under the hood, matching the inherent structure of the project.

<br/>

#### The problem

The current state of programming is full of distractions, taking away focus from what this artform is really all about: _designing_, _building_, _thinking_, _exploring_. This is especially true for beginners, who are faced with a number of hurdles that first have to be overcome before even being _able_ to write a line of code. Anyone should be able to jump right into a project and immediately write a line of code and see its result. To install an IDE and open a project is admittedly also a hurdle, but it's a much smaller one than the status quo of programming languages. It could even be built into the web browser. If not simply running [as a web app](https://microsoft.github.io/monaco-editor/). UNIX skills should not be a _requirement_ for programming.

<br/>

## Documentation

Documentation should be an integral part of the language. Not only in the shape of comments, but code itself should be self-documenting.

<br/>

## Development environment

Like Smalltalk, code should (be able to) be always running (at least during development).

<br/>

### Features

- [Intelligent code completion](https://en.wikipedia.org/wiki/Intelligent_code_completion)
  - Message signatures with typed slots (and defaults) can take [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense) to [the next level](http://worrydream.com/LearnableProgramming/)
- Edit-in-place while running
- Breakpoints, with support for conditions
- Time travel, with intuitive navigation controls and visualization of changes
  - Similar to a browser (previous, next, reload)
  - Controls for run/pause, and which level to operate on (expression or breakpoint)

<br/>

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

Numbers should support units (such as `cm`, `ms`, `kg`, `percent`) and easy conversion between compatible units (for example `10 seconds as ms`).

Smalltalk is known for its exact number representation. This will have to be handled by libraries, as JavaScript's `Number` has "arbitrary imprecision".

> If a SmallInteger operation leaves its range, the result becomes a LargeInteger.

The JavaScript number magic equivalent would be `Number` -> `BigInt` if the number is an integer.
