# Ideas

Not all ideas are my own. Some are more wild than others. The wildest ones are probably mine.


### Trees

The code and its AST is essentially a tree of cells within cells, reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy to traverse for visualization, "realtime" IDE, persistence, refactoring, etc
  - Like Smalltalk's always-running VM with [image-based persistance](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence), but only during development
  - [Reflection](https://en.wikipedia.org/wiki/Smalltalk#Reflection)/macros, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen to enable some of Bret Victor's ideas
  - An IDE may "concretize" cells, enabling inspection of their state and direct manipulation while running
  - Maybe enables time as a factor, with time travel debugging?

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

### The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), truly object-oriented message-based programming languages like Smalltalk are really a parallel to the Internet. I believe that a programming language for the Internet should be in tune with its environment, a language of messages between cells.

<sub>Fun fact: His whole presentation is an done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have some "good parts" at its core, hidden beneath the not so elegant layers of C/Java like syntax and quirks. But it's not as close a representation of the ideas behind the Internet as it could've been. Imagine if Java hadn't happened 😲, IBM had stuck to Smalltalk, and Netscape had [chosen](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk to be the lingua franca of the web in 1995. This project wouldn't have been necessary.</sub>
