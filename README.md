# Power of Interfaces

Welcome to ***Power of Interfaces - Writing better code (and better tests)*** workshop by Vjekoslav Babić.

This workshop is about:
* Interfaces, what they are and how to use them
* SOLID principles, and how to apply them in your daily AL development work
* Dependencies, and how to identify and manage them properly
* Behaviors, and how to avoid spaghetti unreadable code
* Testing with doubles, and why interfaces are better than events for that

When you attend this workshop, you'll not just learn what interfaces are, but you will harness their power to take your AL development skills to a completely new level, that was unimaginable before by most AL developers.

This repository contains the case study code examples that most of this workshop's demos and all of this workshop's exercises are based upon.

You'll get instructions on how to use this repository when you attend this workshop.

## Hint for SaaS sandbox users

If you are using this repository on a sandbox instance of Microsoft's Business Central SaaS, you won't have access to this dependency:

```json
    {
      "id": "5d86850b-0d76-4eca-bd7b-951ad998e997",
      "name": "Tests-TestLibraries",
      "publisher": "Microsoft",
      "version": "1.0.0.0"
    },
```

To fix this problem, you can use the `Microsoft_Tests-TestLibraries_23.0.12034.12841._app_` file. Copy this file manually to `.alpackages` and rename it to `Microsoft_Tests-TestLibraries_23.0.12034.12841.app`.
