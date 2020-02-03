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

#### The functions and features of `Project Alias` are as follows:

* Create any documentation and scripts that allow users to containerize existing High Performance (AI) workflows

* Generate charting that compares performance metrics (potentially with regard to: elasticity, economics, performance, data access and scalability) between bare-metal and OpenShift environments.

* Generate display (of suggestions) for ‘under-utilized’ nodes in OpenShift that could be used for running backfill workloads.

* Use of a 'Hybrid Cloud’ environment that will allow data to be processed either at local workstations with some nodes from AWS/GSP, or at OpenShift’s own centers (a medley of on-site, private cloud and third-party).

* Ability to operate with ease across multiple deployments (MIT HPC, MIT-IBM Watson lab, etc.).

* A easy-to-operate interface with the following features/functions:

    * Simple management of the users of the system.
    
    * Ability to add/deploy a wide-variety extant projects with ease.
    
    * Manipulation (with relatively low latency) of low-level resources such as: computing, network, storage, node allocation.
    
    * Simple to view instances and launch/suspend new or existing instances.
    
    * View existing networks.
    
* Secure user authentication.

* Ability to be scalable (a large number of users, services, projects, data) with workflows easily containerized in a timely fashion:

    * Streamlining scaling up through the following methods will also be explored:
    
        * Minimizing data inertia.
        
        * Circumventing workflow tied to a current system.
        
* Ability to deploy researcher workflows or code with ease from a bare metal environment to OpenShift/Kubernetes

* Generalized: orientation is mostly towards high-performance AI workflows, but should have the capability to deploy a wide range of projects. 

## 4. Solution Concept
#### Global Architectural Structure Of the Project:

#### Design Implications and Discussion:

**1. Scripts/Executables:**
In order to compare two systems benefits, the Scripts/Executables will be needed to easily upload the codes to the bare-metal system and cloud-native (OpenShift) at the same time. And the scripts/executables will be one of the most important parts of the whole workflow since it not only sends the codes but also sends results from the bare-metal system to the OpenShift database to let task monitor service compare and then return the comparison results to the users.

**2. Automatic deploy experiments:** 
Because tasks need to be deployed automatically, so there should have an interface or containers to automatically execute the experimental codes in two different environments.

**3. Database:**
Usually, the data set of tasks could be massive and it makes no sense for the local database store them. The database in the OpenShift only stores the results of tasks from both the cloud-native and bare-metal system. Tasks will retrieve data set from the data source outside, e.g. AWS.

**4. Task monitor service:** 
Since the tasks need uncertain time to complete, and may fail at any time, task monitor service will be needed to keep track of the detailed status of tasks, to see if each step finishes or fails (data preprocessing, data training, data prediction and so on), then after all tasks finishing, it will gather all the results to form the final deliverables.

**5. Outside data import interface:**
Besides the data directly from users, systems will be able to retrieve the data from an external resource and able to do data screening. Because normally, the size of those data is very large, typically in gigabytes. 

## 5. Acceptance criteria

- Directing resources to under-utlized nodes (or minimally displaying that there are such instances) in an effortless manner.
- Extending to a wider class of projects by circumventing the problem of workflows being tied to a current system.
- Minimizing data inertia to allow for quick scaling up in the presence of high(er)-performance projects.

## 6.  Release Planning:

The minimum acceptance criteria is an interface that is able to deploy and containerize a more general class of high-performance AI projects, many of which are currently existing in the MIT HPC. The system must also be able to generate comparison metrics (on a few dimensions such as elasticity, performance, economics, etc.) between the project being run in a native cloud environment (in our case; the ‘hybrid cloud’ system, OpenShift) and a bare metal environment. Some *stretch goals* we hope to implement are:

`Release 1 (Week 5):` 
- Try to deploy at least one specific workflow to OpenShift
- Be able to spawn a bare metal and cloud job for a particular workflow

`Release 2 (Week 9):` 
- Write scripts that monitors both the bare-metal and cloud workflow and displays one dimension of performance in real-time
- Write a script that allows us to deploy multiple workflow to OpenShift
- Some preliminary form of an interface to communicate with our system 

`Release 3 (Week 13):` 
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


