# Ideas

Not my ideas, but ideas nonetheless.

### Trees

The code and its AST is essentially a tree of cells within cells, vaguely reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy to traverse for visualization, "realtime" IDE, persistence, refactoring, etc
  - Like Smalltalk's always-running VM with [image-based persistance](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence)
  - [Reflection](https://en.wikipedia.org/wiki/Smalltalk#Reflection)/macros, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - An IDE may allow inspection of cells' state and direct manipulation of code while running (Smalltalk)
  - Possibly adding time as a factor, enabling time travel debugging?

It's not homoiconic like Lisp, though. Maybe it could be if cells and collections were the same thing?


### The Internet

As Alan Kay [points out](https://www.youtube.com/watch?v=AnrlSqtpOkw#t=2m56s), truly object-oriented message-based programming languages like Smalltalk are really a parallel to the Internet. I believe that a programming language for the Internet should be in tune with its environment.

Fun fact: His whole presentation is an done in an emulation a Smalltalk system from the 70s running on JavaScript. JavaScript _does_ have some "good parts" at its core, hidden beneath the not so elegant layers of C/Java like syntax and quirks. But it's not as close a representation of the ideas behind the Internet as it could've been. Imagine if Java hadn't happened (😲), and IBM would continue backing Smalltalk, with Netscape [choosing](https://en.wikipedia.org/wiki/JavaScript#Creation_at_Netscape) Smalltalk to be the lingua franca of the web. This project wouldn't have been necessary.
