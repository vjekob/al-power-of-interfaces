# Exercise 1: Decoupling dependencies

In this exercise you have an example of very tightly-coupled code. The code is not flexible, it's not extensible, and it's also very difficult to test it.

Your goal is to decouple the dependencies, so that:
- You can easily exchange any of the dependencies (for example, telemetry logging instead of database logging)
- You can test the dependencies in isolation (you don't need to write any tests at this stage)

When doing this, think of how interfaces could help. Also, think of how enums could help, too.

Be ready to present and discuss your improvements in the classroom.
