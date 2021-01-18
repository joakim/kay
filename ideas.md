# Ideas

The code and its AST is essentially a tree of cells within cells, vaguely reminiscent of Lisp's lists. This enables some interesting ideas:

- Easy to traverse for visualization, "realtime" IDE, persistence, refactoring, etc
  - Like Smalltalk's always-running VM with [image-based persistance](https://en.wikipedia.org/wiki/Smalltalk#Image-based_persistence)
  - [Reflection](https://en.wikipedia.org/wiki/Smalltalk#Reflection)/macros, etc
- [Learnable programming](http://worrydream.com/LearnableProgramming/) (Bret Victor)
  - An IDE may allow inspection of cells' state and direct manipulation of code while running (Smalltalk)
  - Possibly adding time as a factor, enabling time travel debugging?

It's not homoiconic like Lisp though. Maybe it could be if cells and collections where the same thing?
