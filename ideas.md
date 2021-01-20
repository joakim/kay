# Ideas

Not all ideas are my own. Some are more wild than others. The wildest ones are probably mine.


### Trees

The code and its AST is essentially a tree of cells within cells, reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy to traverse for introspection, visualization, "realtime" IDE, refactoring, persistence, etc
  - Like Smalltalk's always-running [image-based](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence) VM, but perhaps only during development
  - [Reflection](https://en.wikipedia.org/wiki/Smalltalk#Reflection)/macros, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen because it enables some of Bret Victor's powerful ideas (see [below](#development-environment))
  - An IDE may concretize/visualize cells, enabling inspection of their state and direct manipulation while running
  - May facilitate adding time as a factor, with time travel debugging

### Development environment

Like Smalltalk, code should (be able to) be always running during development.

#### Features

- [Intelligent code completion](https://en.wikipedia.org/wiki/Intelligent_code_completion)
  - Typed message signatures and slots can take [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense) to [the next level](http://worrydream.com/LearnableProgramming/)
- Edit-in-place while running
- Breakpoints, with support for conditions
- Time travel, with intuitive navigation controls and visualization of changes
  - Similar to a browser (previous, next, reload)
  - Controls for run/pause, and which level to operate on (expression or breakpoint)

#### Panes

  - **Outline** of the project's structure, with filters/search
    - **Project** tab for navigating the project's own modules and cells
    - **External** tab for navigating and managing external modules (dependencies)
  - **Inspect** for watching (or visualizing) the state of specified cells
    - Tabs for different views into the app (showing the current cell by default when paused)
  - **Terminal** for the [direct](https://en.wikipedia.org/wiki/Direct_mode) input of messages and output of their return value (REPL)
    - Full introspection and reflection capabilities (the developer is granted "God mode")
    - Could be just an input field at the bottom, with the result shown as an overlay just above it
      - History can be navigated by up/down keys, showing the result for each message in the overlay
  - **Log** for the output of _log_ and _error_ messages (separate from the terminal), with filters/search
  - **Network** for inspecting network activity, with filters/search
  - **Stack** for the current stack trace when paused
  - **Profile** for performance profiling of code

#### Directory structure

Files should not be the concern of the developer. The IDE should abstract away files and folders, allowing developers to focus on their mental model of the project. This doesn't have to be image-based like Smalltalk. For interoperability and version control, it should still use files and folders under the hood, matching the inherent structure of the project.

##### The problem

The current state of programming is full of distractions, taking away focus from what this artform is really all about: _designing_, _building_, _thinking_, _exploring_. This is especially true for beginners, who are faced with a number of hurdles that first have to be overcome before even being _able_ to write a line of code. Anyone should be able to jump into a project and immediately write a line of code and see its result. To install an IDE and open a project is admittedly also a hurdle, but it's a much smaller one than the status quo of programming languages.

### The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), truly object-oriented message-based programming languages like Smalltalk are really analogous to the Internet. I believe that a programming language for the Internet should be in tune with its environment, a language of messages between cells.

<sub>Fun fact: The presentation was done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have some "good parts", hidden beneath layers of Java like syntax, quirks and inconsistencies. But it's not as close a representation of the ideas behind the Internet as it could've been. Imagine if Java hadn't happened 😲, IBM had stuck to Smalltalk, and Netscape had [chosen](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk in 1995, to eventually become the lingua franca of the web. This project wouldn't have been necessary.</sub>

### Forests

Speaking of trees, it makes a lot of sense to think about apps/servers as multicellular organisms communicating through soil/air/water. Trees in forests communicate by sending chemical signals (messages) and nutrients (data) over [fungal networks](https://en.wikipedia.org/wiki/Mycorrhiza), as well as [pheromones](https://en.wikipedia.org/wiki/Pheromone) through the air. Similarly, apps/servers need fungi/air/water to communicate with each other, either over short ([inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication)) or long ([networks](https://en.wikipedia.org/wiki/Computer_network)) distances. The Internet already works (and looks) a lot like fungi. But I'm sure we could do even better.

One characteristic that plants and apps have in common is that they are immobile, in contrast to animals. A mobile device running apps is like taking a potted plant for a walk. Plant cells are therefore a more suitable model for computing than animal cells.

### Evolution

Taking inspiration from (my limited understanding of) molecular biology to the extreme:

- Cells are like [plant stem cells](https://en.wikipedia.org/wiki/Plant_stem_cell)
- Every cell has a nucleus with DNA (encoded information) with restricted access from outside the nucleus
- They are isolated entities (protected by a membrane) that act on messages in their environment
- Always adapting to stimuli, the DNA in a cell may mutate over time, but most change is epigenetic
- Cells build dynamic structures (organisms) of differentiated cells, based on their ever-evolving DNA
- In the (encoded/encrypted) DNA is the "recipe" for an entire organism
- State is an emerging phenomenon of "conciousness"

Good luck implementing _that!_
