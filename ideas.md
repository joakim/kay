# Ideas

Not my ideas, but ideas nonetheless.

### Trees

The code and its AST is essentially a tree of cells within cells, vaguely reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy to traverse for visualization, "realtime" IDE, persistence, refactoring, etc
  - Like Smalltalk's always-running VM with [image-based persistance](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence), but only during development
  - [Reflection](https://en.wikipedia.org/wiki/Smalltalk#Reflection)/macros, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - The message slot syntax (`()`) was chosen to enable some of Bret Victor's ideas
  - An IDE may "concretize" cells, enabling inspection of their state and direct manipulation while running
  - Maybe enables time as a factor, with time travel debugging?

It's not homoiconic like Lisp, though maybe it could be if cells and collections were the same thing?


### The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), truly object-oriented message-based programming languages like Smalltalk are really a parallel to the Internet. I believe that a programming language for the Internet should be in tune with its environment, a language of messages between cells.

Fun fact: His whole presentation is an done in an emulation of a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have some "good parts" at its core, hidden beneath the not so elegant layers of C/Java like syntax and quirks. But it's not as close a representation of the ideas behind the Internet as it could've been. Imagine if Java hadn't happened (😲), and IBM would continue backing Smalltalk, with Netscape [choosing](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk to be the lingua franca of the web in 1995. This project wouldn't have been necessary.
