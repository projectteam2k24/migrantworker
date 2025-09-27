# MIGRANT WORKER REGISTRATION AND LOCAL JOB MANAGEMENT

**By JAIS ROY [MG22CCSR07], AMARJITH ANAND [MG22CCSR17], VYSHNAV DAS P [MG22CCSR23] Under the guidance of Dr. SHIJO M JOSEPH, A project submitted to the Kannur University in partial fulfillment of the requirements of the B.Sc. COMPUTER SCIENCE 2024-25**

## ACKNOWLEDGEMENT

We have immense pleasure in acknowledging the service and cooperation rendered by umpteen people in their known-fields and ways. The success of any task accomplished lies not only hands of the accomplisher but also the guiding light offered by all those around, towards the roads to success, they did much to shape up the success. We are grateful to our college Principal Dr. Swarupa R for extending facilities required through our project Work.<BR>
We wish to express our deepest of gratitude to our guide Dr. Shijo M Joseph and Capt.(Dr.) Jithesh K (HOD) and other faculties in the Department of Computer Science whose generous support, constant encouragement and healthy criticism have been of invaluable help to us throughout the course of this project. We also express our heart full thanks to our classmates, parents and friends for providing valuable suggestions. Above all it is the grace and blessing God the almighty, which make this endeavor a success. 
<center>
<h2>CERTIFICATION OF COMPLETION</h2>

<img src= "https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/Screenshot%202025-09-27%20162447.png" alt="certOfCompl"/>
</center>

<h3>ABSTRACT</h3>
This mobile application is designed to simplify the recruitment,  registration,  and management of migrant workers for local job markets by connecting contractors,  workers,  and job providers in one unified platform. Contractors,  upon registering with personal details and official documents,  can create worker profiles that include each worker’s skills,  salary,  and insurance information. They can assign jobs,  track work progress,  receive job notifications,  post updates,  and manage their workforce,  including adding,  removing,  or exchanging workers with other contractors.<br><br>
Workers,  after creating profiles with identity verification documents,  can apply to join contractor teams,  request contractor changes,  update residence and emergency contact information. Job providers register to post jobs with specific requirements,  and an AI feature assists by providing cost estimates,  necessary worker numbers,  and job duration based on job details. They can request workers from contractors,  rate contractors based on performance,  and report any worksite accidents directly to the contractor responsible. <br><br>
Admins oversee user activities and maintain system integrity by monitoring registered workers,  contractors,  and job providers. They have the ability to review user details,  delete accounts when necessary,  and access reports on fraudulent activities,  scams,  or work-related concerns submitted by users.<br><br>
The application integrates a messaging system for seamless communication among all users and provides notifications to keep everyone  updated on job statuses,  requests,  and important updates. By enhancing transparency,  streamlining workforce organization,  and improving collaboration,  this system creates a structured and efficient local job management solution. 

<h3>INTRODUCTION</h3>
This mobile application is designed to streamline the recruitment, registration,  and management of migrant workers in local job markets by Connecting contractors,  workers,  and job providers on a single platform. The goal is to simplify workforce management,  from hiring and onboarding to job assignment and progress tracking,  enhancing collaboration and transparency in the process. By digitizing these key functions,  the app eliminates traditional inefficiencies and delays in workforce coordination.<BR><BR>
Contractors can create worker profiles that include skills,  salary,  and insurance information,  assign jobs,  track progress,  and manage their workforce by adding or exchanging workers. Workers can create profiles with verified documents,  join contractor teams,  request changes,  and update personal information like residence and emergency contacts. Job providers can post jobs with specific requirements,  receive AI-generated estimates for costs,  worker numbers,  and job duration,  and request workers from contractors. They can also rate contractors and report accidents. The AI feature in particular helps job providers make informed decisions,  saving time and resources. <br><br>
The application features messaging and notifications to ensure clear communication and job status updates,  ultimately improving workforce organization and collaboration in the local job market. Its comprehensive design makes it a vital tool for creating a structured and efficient work environment. 

<h3>PROBLEM STATEMENT</h3>

In local job markets,  the recruitment and management of migrant workers 
are often inefficient,  fragmented,  and prone to miscommunication. Contractors 
face challenges in managing their workforce,  tracking worker progress,  and 
ensuring smooth job assignments,  while workers struggle with accessing job 
opportunities,  updating personal information,  and building a reliable work 
history. Job providers encounter difficulties in posting job requirements,  
selecting suitable workers,  and ensuring timely completion of tasks,  often 
leading to delays,  increased costs,  and lack of transparency. <BR><BR>
Existing systems for managing migrant workers are often outdated and 
lack integration,  leading to inefficiencies in communication,  worker tracking,  
and job assignment. Additionally,  there is no unified platform that connects 
contractors,  workers,  and job providers,  making it difficult for all parties to 
collaborate effectively and manage their roles efficiently. This creates a need for a 
digital solution that simplifies the recruitment,  registration,  and management 
of migrant workers,  offering a more streamlined,  transparent,  and collaborative 
approach to local job market operation. 

<H3>EXISTING SYSTEM</H3>
Currently,  the recruitment and management of migrant workers rely on 
traditional methods like manual paperwork,  phone calls,  and fragmented digital systems. Contractors manage workers using spreadsheets or isolated software,  
while workers often find jobs through informal networks. Job providers post 
openings via local agencies or online boards,  but there is no seamless 
connection with contractors or workers. Communication is typically handled 
through phone calls or separate messaging apps,  leading to inefficiencies and 
delays. <BR><BR>
While some platforms exist for job posting or contractor management,  
they lack integration and essential features like real-time progress tracking,  AI 
based estimates,  and centralized worker profiles,  making the current systems 
inefficient and prone to errors. 

<h3>PROPOSED SYSTEM</h3>
<B>Centralized Platform:</B> A unified mobile application that connects contractors,  workers,  and job providers in one platform,  simplifying recruitment,  registration,  and workforce management. <BR><BR>
<B>Contractor Features:</B> Contractors can create and manage worker profiles,  track work progress,  assign jobs,  and handle workforce updates (e.g. adding or exchanging workers). They can also receive notifications and job updates.  <BR><BR>
<B>Worker Features:</B> Workers can create profiles with verified identity documents,  apply to join contractor teams,  update personal information,  and view their work history. They can request contractor changes and access travel assistance. <BR><BR>
<B>Job Provider Features:</B> Job providers can post job requirements,  use AI-based features for cost estimates,  estimated number of workers required,and estimated time for job completion. They can post jobs,  review contractors,  and report of accidents if any.  <BR><BR>
<B>AI Integration:</B> AI-powered chat bot assist job providers by generating cost estimates, number of workers required,  and job duration based on job details,  improving decision-making. - Improved Transparency and Efficiency: A comprehensive solution for managing job assignments,  workforce tracking,  and collaboration,  reducing miscommunication and delays in the local job market. <BR><BR>
<B>Mobile Accessibility:</B> Easy access to all features via mobile devices,  ensuring real-time updates and task management on the go. <BR><BR>
<B>Messaging and Notifications:</B> In-app messaging and notifications for smooth communication between all users,  keeping everyone informed of job statuses,  requests,  and updates.

#  Modules

## 1. Admin  
The **Admin module** enables administrators to oversee user activities and maintain system integrity by managing **workers, contractors, and job providers**.  

- Admins can access and review user details, ensuring compliance with platform guidelines.  
- They have the authority to **delete accounts** in cases of fraudulent activity, misconduct, or policy violations.  
- A **reporting system** allows admins to view and assess reports submitted by users regarding scams, fraudulent activities, and disputes.  
- By monitoring platform interactions, the Admin module helps create a **secure and transparent environment**, ensuring smooth operations and trust among all users.  

---

## 2. Contractor  
The **Contractor module** is designed to help contractors efficiently manage their workforce and job assignments.  

- Contractors can create and update **worker profiles**, including details such as skills, salary, and insurance information.  
- They can **add or remove workers** from their team and track the progress of tasks.  
- Contractors can **assign jobs** to workers based on skills and availability, ensuring the right person is matched to the right task.  
- They can **post updates** about ongoing jobs, keeping job providers and workers informed.  
- **Notifications** are sent to workers about new assignments, task changes, or job status updates for seamless communication.  

---

## 3. Job Provider  
The **Job Provider module** enables job providers to post job openings and request workers for specific tasks.  

- Job providers can specify **requirements** such as skills, number of workers, estimated duration, and cost of the task.  
- The system integrates **AI** to provide estimates for cost, workforce needed, and expected job duration.  
- Job providers can view available **worker profiles**, including past work history, to make informed decisions.  
- After job completion, job providers can **rate contractors** based on performance and quality of work.  
- They can also **report accidents or safety issues** that occur on-site for timely follow-up by contractors.  

---

## 4. Worker  
The **Worker module** allows workers to create and manage their personal profiles.  

- Profiles include **personal information, identity verification, skills, and contact details**.  
- Workers can update their **residence and emergency contacts** and view their **work history** (accessible to contractors and job providers).  
- They can **apply to join contractor teams**, request changes, or apply for jobs posted by job providers.  
- In-app **messaging** enables workers to communicate directly with contractors.  
- **Notifications** keep workers updated about job assignments, changes, and status updates.

## Data Flow Diagram

![Level 0](https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/level0.png)  
![Level 1](https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/level1.png)  
![Level 2](https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/level2.png)  
![Level 3](https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/level3.png)  
![Level 4](https://raw.githubusercontent.com/projectteam2k24/migrantworker/refs/heads/main/level4.png)  

# System Development

## Front End

### Dart  
Dart is an open-source, general-purpose programming language developed by Google. First released in 2011, Dart is designed for client-side development, with a focus on building high-performance applications for web, mobile, and desktop platforms. Its syntax is similar to languages like Java and JavaScript, making it accessible to developers familiar with object-oriented programming.  

Dart is compiled and can execute in both just-in-time (JIT) and ahead-of-time (AOT) modes. JIT compilation enables fast development cycles with features like hot reload, while AOT compilation enhances execution speed by producing optimized native machine code. Dart supports multiple programming paradigms, including object-oriented, functional, and reactive programming.  

The language features a sound type system with optional null safety, helping developers write more reliable and efficient code. Dart’s standard library provides extensive built-in support for asynchronous programming through its Future and Stream APIs, making it well-suited for handling concurrent operations.  

Dart was initially created as a JavaScript alternative for web applications but has since evolved into a versatile language powering frameworks like **Flutter**, Google’s UI toolkit for cross-platform mobile and web app development. With its structured yet flexible nature, Dart continues to gain traction in modern application development.  

---

### Flutter  
Flutter is an open-source UI toolkit developed by Google for building natively compiled applications for mobile, web, and desktop from a single codebase. First released in 2017, Flutter enables developers to create visually rich and highly performant applications with a consistent user experience across multiple platforms.  

Flutter uses the Dart programming language and employs an ahead-of-time (AOT) compilation process to generate optimized native code, ensuring smooth performance. Its reactive framework allows developers to build UIs declaratively using widgets, which serve as the building blocks for app interfaces. Flutter’s widget-based architecture provides extensive customization and flexibility, enabling developers to create expressive and dynamic user experiences.  

A key feature of Flutter is its **hot reload capability**, which significantly speeds up the development process by allowing real-time code changes without restarting the application. Flutter also includes a rich set of pre-designed widgets that follow **Material Design** and **Cupertino** guidelines, ensuring a native-like experience on both Android and iOS.  

Flutter’s layered architecture promotes fast rendering and high responsiveness, making it suitable for complex animations and modern UI designs. With its growing community, extensive ecosystem, and seamless integration with backend services, Flutter has become a popular choice for developers looking to build cross-platform applications efficiently.  

---

### Android Studio  
Android Studio, developed by Google, is the official integrated development environment (IDE) for Android app development. It offers a powerful and user-friendly environment with features like an intelligent code editor, visual layout editor, and a versatile emulator for testing on various devices.  

Supporting both Java and Kotlin, Android Studio provides robust debugging and profiling tools for optimizing app performance. With seamless integration of version control systems and frequent updates to align with the latest Android platform advancements, it remains a preferred choice for developers to create high-quality and innovative Android applications.  

---

## Back End

### Firestore  
Firestore, officially known as **Cloud Firestore**, is a flexible, scalable, and fully managed NoSQL database developed by Google as part of its Firebase platform. First introduced in 2017, Firestore is designed to store, sync, and query data for web and mobile applications in real time while offering seamless integration with other Firebase services and Google Cloud products.  

Unlike traditional SQL databases, Firestore follows a **document-oriented model**, where data is stored as collections and documents rather than tables and rows. Documents, which are stored in JSON-like format, contain fields of various data types, including strings, numbers, arrays, maps, and timestamps. Collections serve as containers for documents, allowing for hierarchical data structuring that is both scalable and easy to manage.  

Firestore supports **real-time synchronization**, ensuring that data updates are instantly reflected across all connected devices. It also offers **offline support**, enabling applications to read, write, and sync data even when users are offline, with automatic synchronization once connectivity is restored. Its powerful querying capabilities allow developers to filter, sort, and retrieve data efficiently using indexed queries.  

As a fully managed cloud-based database, Firestore is designed to **scale automatically**, handling millions of concurrent users without requiring manual server management. It also ensures strong security through Firebase Authentication and role-based access control via Firestore Security Rules.  

Firestore integrates seamlessly with Google Cloud services, making it an excellent choice for **serverless applications, real-time chat apps, collaborative platforms, and IoT solutions**. With its combination of real-time capabilities, offline functionality, and effortless scalability, Firestore is a robust and reliable choice for modern application development.  
