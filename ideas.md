# Ideas

Not all ideas are my own. Some are more wild than others. The wildest ones are probably mine.

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

## Trees

The code and its AST is essentially a tree of cells within cells, reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy traversal for introspection, analysis, refactoring, visualization, diffing, history/persistence, reflection, macros, etc
  - ... not just of code, but also state
  - Always-running environment like Smalltalk [image-based](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence) VM, but perhaps only during development
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen because it enables some of Bret Victor's powerful ideas (see [below](#development-environment))
  - An IDE may concretize/visualize cells, enabling inspection of their state and direct manipulation while running
  - The tree could facilitate adding time as a factor, with time travel debugging
- Metadata on the cell level
  - Tags, links, etc
  - Should probably not be accessible from code, but from the developer environment (see below), macros, etc

This _could_ be implemented as a more low-level [intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation), like in [Bosque](https://github.com/microsoft/BosqueLanguage/), without any particular target language/system in mind. In any case, the focus should be on enabling a better developer experience.

### Not hierarchic, not necessarily anarchic, maybe holarchic?

[Holarchy](http://www.worldtrans.org/essay/holarchies.html) may be a more fruitful way to view the tree of cells. [Multi-agent system](https://en.wikipedia.org/wiki/Multi-agent_system) is another related concept. Without hierarchical subclassing, cells become autonomous, interconnected units (agents/actors). Inheritance is about _genetics_, not rule. It's all about _communication_, _cooperation_, _synergy_, _symbiosis_. Being _flexible_, not rigid.

[Hierarchy](https://en.wikipedia.org/wiki/Hierarchy#Etymology): "rule of a high priest"  
[Anarchy](https://en.wikipedia.org/wiki/Anarchy#Etymology): "without ruler"  
[Holarchy](https://en.wikipedia.org/wiki/Holarchy): "a whole that is part of a larger whole"  

<br/>

## Development environment

Like Smalltalk, code should (be able to) be always running (during development).

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

## Directory structure

Files should not be the concern of the developer. The IDE should abstract away files and folders, allowing developers to focus on their mental model of the project. This doesn't have to be image-based like Smalltalk. For interoperability and version control, it should still use files and folders under the hood, matching the inherent structure of the project.

#### The problem

The current state of programming is full of distractions, taking away focus from what this artform is really all about: _designing_, _building_, _thinking_, _exploring_. This is especially true for beginners, who are faced with a number of hurdles that first have to be overcome before even being _able_ to write a line of code. Anyone should be able to jump into a project and immediately write a line of code and see its result. To install an IDE and open a project is admittedly also a hurdle, but it's a much smaller one than the status quo of programming languages.

<br/>

## Documentation

Documentation should be an integral part of the language. Not only in the shape of comments, but code itself should be self-documenting.

<br/>

## The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), truly object-oriented message-based programming languages like Smalltalk are analogous to the Internet. I believe that a programming language for the Internet should be in tune with its environment, a language of messages between cells.

<sub>Fun fact: The presentation was done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have some "good parts", hidden beneath layers of Java syntax, quirks and inconsistencies. But it's not as close a representation of the ideas behind the Internet as it could've been. Imagine if Java hadn't happened 😲, IBM had continued backing Smalltalk and Netscape had [chosen](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk or Self in 1995, to eventually become the lingua franca of the web. This project wouldn't have been necessary.</sub>

<br/>

## Forests

Speaking of [trees](#trees), it makes a lot of sense to think about apps/servers as multicellular organisms communicating through soil/air/water. Trees in forests communicate by sending chemical signals (messages) and nutrients (data) over [fungal networks](https://en.wikipedia.org/wiki/Mycorrhiza), as well as [pheromones](https://en.wikipedia.org/wiki/Pheromone) through the air. Similarly, apps/servers need fungi/air/water to communicate with each other, either over short ([inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication)) or long ([networks](https://en.wikipedia.org/wiki/Computer_network)) distances. The Internet already works (and looks) a lot like fungi. But I'm sure we could do even better.

One characteristic that plants and apps have in common is that they are immobile, in contrast to animals. A mobile device running apps is like taking a potted plant for a walk. Plant cells may therefore be a more suitable model for computing than animal cells, at least for now.

<br/>

## Evolution

Taking inspiration from (my limited understanding of) molecular biology to the extreme:

- Cells are like [plant stem cells](https://en.wikipedia.org/wiki/Plant_stem_cell)
- Every cell has a nucleus with DNA (encoded information) with restricted access from outside the nucleus
- They are isolated entities (protected by a membrane) that act on messages in their environment
- Always adapting to stimuli, the DNA in a cell may mutate over time, but most change is epigenetic
- Cells build ever-evolving organisms of differentiated cells, based on their ever-evolving DNA
- The (encoded/encrypted) DNA holds the "recipe" for an entire organism
- Program state as the emerging phenomenon of [conciousness](https://en.wikipedia.org/wiki/Hard_problem_of_consciousness)?

Good luck implementing _that!_

<br/>

## Values within cells within modules within one runtime?

Not "it's cells all the way down", but JavaScript's "([almost](https://stackoverflow.com/questions/9108925/how-is-almost-everything-in-javascript-an-object)) everything is an object".

In this perspective, the **module** is the cell. As in biological cells, there can be various subcellular components, including [endosymbiotic](https://en.wikipedia.org/wiki/Endosymbiosis) "cells within cells" ([Mitochondrion](https://en.wikipedia.org/wiki/Mitochondrion), [Plastids](https://en.wikipedia.org/wiki/Plastid)) and other organelles. These subcellular cells are lighter and simpler than the module, but share the same general features (encapsulation, receptors/behaviors, etc).

That makes it 4 levels to reason about:

1. `Runtime` – Environment
2. `Module` – "[Eukaryotic](https://en.wikipedia.org/wiki/Eukaryote#Cell_features)" cell
3. `Cell` – "[Endosymbiotic](https://en.wikipedia.org/wiki/Endosymbiosis)" cell
4. `Value` – [Proteins](https://en.wikipedia.org/wiki/Protein) and other [biomolecules](https://en.wikipedia.org/wiki/Biomolecule)

Viewing a module as "the cell" makes sense. Modules/cells are the building blocks of the app/organism. Specialized, differentiated, loosely coupled. Inside you'll find a tiny contained universe of smaller structures, functionality and values, that is easy to reason about in isolation.

Instead of _the cell's local state_ being its nucleus, perhaps a better analogy is _the database_ (persisted state)? Of course, each cell doesn't have its own database, but the biology-computing analogy only goes so far. The size of the human genome is [~700 MB](https://medium.com/precision-medicine/how-big-is-the-human-genome-e90caa3409b0).
