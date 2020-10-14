# Development Process
All contributions should have a corresponding task on the [projects board](https://github.com/nateybear/longhorn-rstata/projects) of this repo to track requirements and progress.

New features should be developed on separate branches and integrated through pull requests. This allows for a formal review process before integrating. If you are fixing a bug or updating documentation for an existing feature, you are free to commit to the main branch.

All code should be thoroughly reviewed before integrating (especially with pull requests). Nate claims right to BDFL, mostly as a check to force contributors to clean up sloppy code. Code that is not properly reviewed will be rolled back.

Developers should use the workflow described in the [R Packages](https://r-pkgs.org) book. Particularly, you must run styler::style_* before committing.

# Documentation
All code should be thoroughly documented before committing. All exported functions should have a Roxygen comment with a description of all of its features AND examples. The README.Rmd should be updated with new examples as features are added.

This is user-facing code. No one will use it if it is not documented.

# Unit testing
None, such as there is. Your test is to replicate Stata's output. EAT YOUR OWN DOG FOOD. Use this package for metrics homeworks, make sure it works for your use cases.

# Clean Code
Follow Uncle Bob's suggestions. He wrote the book "Clean Code" and is primarily a Java guy, but his advice is generally applicable. Here's a [useful rundown](https://medium.com/swlh/the-must-know-clean-code-principles-1371a14a2e75).

For R development in particular, refer to Hadley Wickham's book on [Advanced R](http://adv-r.had.co.nz/Introduction.html).

Here are some key things to keep in mind as a contributor:
* Write readable code---focus on "what" you are doing, not "how" you are doing it.
* Functions should be short and should do one thing only.
* Names should be descriptive and readable, even at the expense of length. Use nouns, verbs, and adjectives.
* Use (even overuse) [functional programming](http://adv-r.had.co.nz/Functional-programming.html) concepts. It will make you a better coder.
