** **

## Project Description Template

The purpose of this Project Description is to present the ideas proposed and decisions made during the preliminary envisioning and inception phase of the project. The goal is to analyze an initial concept proposal at a strategic level of detail and attain/compose an agreement between the project team members and the project customer (mentors and instructors) on the desired solution and overall project direction.

This template proposal contains a number of sections, which you can edit/modify/add/delete/organize as you like.  Some key sections we’d like to have in the proposal are:

- Vision: An executive summary of the vision, goals, users, and general scope of the intended project.

- Solution Concept: the approach the project team will take to meet the business needs. This section also provides an overview of the architectural and technical designs made for implementing the project.

- Scope: the boundary of the solution defined by itemizing the intended features and functions in detail, determining what is out of scope, a release strategy and possibly the criteria by which the solution will be accepted by users and operations.

Project Proposal can be used during the follow-up analysis and design meetings to give context to efforts of more detailed technical specifications and plans. It provides a clear direction for the project team; outlines project goals, priorities, and constraints; and sets expectations.

** **

## 1.   Vision and Goals Of The Project:

The vision section describes the final desired state of the project once the project is complete. It also specifies the key goals of the project. This section provides a context for decision-making. A shared vision among all team members can help ensuring that the solution meets the intended goals. A solid vision clarifies perspective and facilitates decision-making.

The vision statement should be specific enough that you can look at a proposed solution and say either "yes, this meets the vision and goals", or "no, it does not".

## 2. Users/Personas Of The Project:

##### `Project Alias` will serve as a bridge from existing bare-metal HPC clusters (example: Satori@MIT) to a native cloud environment for better resource utilization and price-efficiency. High-level goals of `Project Alias` includes:

- Provide services that help containerize existing bare-metal AI workflows and hook the images to an OpenShift cluster.
- Provide an interface to monitor and compare OpenShift workflows and bare-metal workflows from multiple perspectives.
- Generate a report that portrays the pros/cons of migrating bare-metal workflow to OpenShift environment.
- (Optional) Generalize from supporting a specific workflow to supporting a wide range of bare-metal AI workflows that uses different machine learning frameworks.


## 3.   Scope and Features Of The Project:

The Scope places a boundary around the solution by detailing the range of features and functions of the project. This section helps to clarify the solution scope and can explicitly state what will not be delivered as well.

It should be specific enough that you can determine that e.g. feature A is in-scope, while feature B is out-of-scope.

** **

## 4. Solution Concept

This section provides a high-level outline of the solution.

Global Architectural Structure Of the Project:

This section provides a high-level architecture or a conceptual diagram showing the scope of the solution. If wireframes or visuals have already been done, this section could also be used to show how the intended solution will look. This section also provides a walkthrough explanation of the architectural structure.

 

Design Implications and Discussion:

This section discusses the implications and reasons of the design decisions made during the global architecture design.

## 5. Acceptance criteria

This section discusses the minimum acceptance criteria at the end of the project and stretch goals.

## 6.  Release Planning:

`**Release 1** (week 5):` 
- Try to deploy at least one specific workflow to OpenShift
- Be able to spawn a bare metal and cloud job for a particular workflow

`**Release 2** (week 9):` 
- Write scripts that monitors both the bare-metal and cloud workflow and displays one dimension of performance in real-time
- Write a script that allows us to deploy multiple workflow to OpenShift
- Some preliminary form of an interface to communicate with our system 

`**Release 3** (week 13):` 
- Design a platform that, in tandem, can start both the bare metal and cloud job using https/ssh protocol.
- Interface to include detailed comparison between bare-metal env. & cloud-native implementations of parallel ML workflows.
- Display under-utilized nodes in OpenShift and perhaps suggestions/actual effectuations of running backfill overloads.


## General comments

Remember that you can always add features at the end of the semester, but you can't go back in time and gain back time you spent on features that you couldn't complete.

** **

For more help on markdown, see
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

In particular, you can add images like this (clone the repository to see details):

![alt text](https://github.com/BU-NU-CLOUD-SP18/sample-project/raw/master/cloud.png "Hover text")


