# Engineering Question Bank: Enterprise Architecture Documentation

For architecture-led questions grouped by all twelve platforms and tied to
every canonical detailed use case, use the
[MidhHealth Use-Case Interview Question Bank](use-case-interview-question-bank.md).
The questions below remain the broader role and technology collection.

These questions are selected from MAAS production interview-question sources, including company interview captures, scenario packs, technology packs, and curated MAAS database entries. Wording is normalized only for readability.

Source labels are kept with each question so engineers can trace preparation back to MAAS interview intelligence.

## 30 MAAS Real Skill, Tool, and Project Questions

1. Tell me about a database or platform that you helped design or improve, and what your role was in that. 6. Were you the only database engineer on that project, or were you working as part of a team? _(Source: MAAS database: PRIORITY DISPATCH CORPORATION)_
2. Can you describe a time when you were responsible for designing and delivering different cloud projects simultaneously, and how you ensured each project was successfully delivered? _(Source: MAAS database: ATLAS TECHNICA)_
3. How do you collaborate with autonomy, robotics and data teams when designing a backend cloud service? _(Source: MAAS database: BEEP)_
4. How did you design your GKE and Cloud Run architecture for high availability and low latency at Honeywell? _(Source: MAAS database: BEEP)_
5. Do you have any questions so far about the company, the team, or the role before we move on? _(Source: MAAS database: BRIGHT HORIZONS)_
6. Can you walk me through a time you had to design or automate security controls into cloud infrastructure or platform? _(Source: MAAS database: CENTRALREACH)_
7. What cloud platforms have you worked on? _(Source: MAAS database: COLLABWARE)_
8. If a client comes with services running locally and asks you to move them to the cloud, how would you approach the project at a high level? _(Source: MAAS database: EA)_
9. What cloud platform project are you most proud of building? _(Source: MAAS database: GONGIO)_
10. Are you essentially developing, or more designing and managing platforms in cloud? _(Source: MAAS database: JP MORGAN CHASE)_
11. Can you walk me through a production AWS infrastructure project you owned end-to-end and your architecture choices? _(Source: MAAS database: MONTAI THERAPEUTICS)_
12. Is the Systems Administrator role more focused on day‑to‑day operations or does it involve project work like infrastructure upgrades or cloud initiatives? _(Source: MAAS database: PENAIR CREDIT UNION)_
13. Do you have any questions for me about the role, company, or team? _(Source: MAAS database: PERDUE FARMS)_
14. What about designing highly available cloud architectures have you faced this kind of expertise _(Source: MAAS database: PULSERISE TECHNOLOGIES)_
15. Can you walk me through your current project architecture and your role in it? _(Source: MAAS database: PWC)_
16. Beyond the job description, what new or exciting projects is the Production Engineering team working on? _(Source: MAAS database: REDFIN)_
17. What questions do you have for me about the role, team, or company? _(Source: MAAS database: VERSANA)_
18. Can you describe one Azure environment that you personally own from architecture design through production, all the way to support? _(Source: MAAS database: WOUNDLOCAL)_
19. If we ask you to design a secure Azure environment for a HIPAA-related backend platform from scratch, what would your architecture look like right now? _(Source: MAAS database: WOUNDLOCAL)_
20. Are there any upcoming projects where the new DBA will play a key role? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
21. Who handles deployment of SQL Server environments in the cloud - DBA or cloud team? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
22. Can you describe a project where you implemented or managed Azure cloud infrastructure? _(Source: MAAS database: MARATHON PETROLEUM CORPORATION (MPC))_
23. What specifically did you build with GCP / cloud platforms? _(Source: MAAS database: MCLANE COMPANY, INC.)_
24. In total, how many years of experience do you have with each cloud platform? _(Source: MAAS database: MCLANE COMPANY, INC.)_
25. How would you ensure knowledge sharing across the platform team? _(Source: MAAS database: MOLSON COORS BEVERAGE COMPANY)_
26. Can you describe your current project and your role at Transamerica? _(Source: MAAS database: MOLSON COORS BEVERAGE COMPANY)_
27. Can you walk me through some key clients or projects you have worked with? _(Source: MAAS file: companies/ashnik)_
28. Explain how you designed the monitoring, logging, and alerting for one of your projects. _(Source: MAAS file: companies/ashnik)_
29. Share an example of a cloud migration, modernization, or automation project you delivered. _(Source: MAAS file: companies/ashnik)_
30. You need event-driven automation each time a file lands in Cloud Storage. How will you design this end-to-end? _(Source: MAAS file: scenarios/scenario)_

## 10 Architecture Questions

1. Explain the components of Splunk - Forwarder, Indexer, and Search Head. What role does each play? _(Source: MAAS file: technologies/splunk)_
2. Walk me through the architecture - CloudFormation creates the cluster, then what's reacting to the auto-scaling events? _(Source: MAAS database: VERISK)_
3. A Cloud Run service must connect securely to VMs in a private VPC. How will you configure egress + VPC connectors + private routing? _(Source: MAAS file: scenarios/scenario)_
4. A team wants to filter logs generated only by specific microservices and export them to BigQuery. How will you design log-based routing? _(Source: MAAS file: scenarios/scenario)_
5. Your production service experiences random latency spikes. How will you design proactive monitoring using SLOs, SLIs, and alert policies? _(Source: MAAS file: scenarios/scenario)_
6. Explain Splunk Enterprise vs. Splunk Cloud. What are the major differences in architecture and management? _(Source: MAAS file: technologies/splunk)_
7. Explain Kubernetes architecture and control plane components. _(Source: Top MNC 2024)_
8. What are the steps to design a scalable Jenkins architecture? _(Source: MAAS database)_
9. What are the steps to design a highly available architecture in AWS? _(Source: MAAS database)_
10. What was the project trying to solve and what was the architecture? _(Source: MAAS database: BEAUTIFUL.AI)_

## 10 System Design Questions

1. How would you design a disaster recovery strategy for a web application? _(Source: MAAS database: AMERICAN AIRLINES)_
2. How do you design and configure SharePoint when it is connected to Microsoft Teams? _(Source: MAAS database: ESKATON)_
3. How do you design a monitoring/observability strategy from scratch? _(Source: MAAS database: GALLUP)_
4. Would you walk me through the CI/CD pipeline your team uses today, and call out the parts you designed? _(Source: MAAS database: GONGIO)_
5. How would you design a secure Azure architecture using SQL, storage, private endpoints, and compliance requirements? _(Source: MAAS database: HOLLAND & HART LLP)_
6. In architecture and design, do you have vigorous debates about the right approaches? _(Source: MAAS database: KUVARE HOLDINGS)_
7. Can you give an instance where you had to work with the dev team to change their design because the schema they were proposing wasn’t right? _(Source: MAAS database: WI-TRONIX)_
8. Day one: we hire you, and we say we need a High Availability plan because we have a huge risk with our SQL Server running on a VM. What would your strategy/approach be? _(Source: MAAS database: STAGE FRONT)_
9. How involved were you in the design of protecting those platforms versus just operating protections? _(Source: MAAS database: ALO)_
10. What operating experience is most relevant for designing and delivering environments for multiple client groups? _(Source: role requirement catalog)_

## 10 Behavioral Questions

1. Can you describe a time where you collaborated with diverse roles to complete a project? _(Source: MAAS database: CDC FOUNDATION)_
2. Can you describe a time where you successfully worked with a remote team to meet a project goal? _(Source: MAAS database: CDC FOUNDATION)_
3. Can you tell me about a time you worked with other team members or across the organization to implement a project? _(Source: MAAS database: VIANT TECHNOLOGY)_
4. Can you give a one to two minute overview of your background? _(Source: MAAS System/Cloud Screening)_
5. Walk me through your experience and recent role progression. _(Source: MAAS System/Cloud Screening)_
6. Can you tell me about your current role and day‑to‑day responsibilities? _(Source: MAAS database: ESRI)_
7. Tell me about your experience at Nano Tech (previous role). _(Source: MAAS database: CLINICAL ARCHITECTURE)_
8. Can you tell me about your experience interviewing with our team so far? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
9. Tell me a little bit about yourself. - Tell me about the last project you worked on. - What did you do specifically for that role? _(Source: MAAS database: HIPPOCRATIC AI)_
10. Tell me about a time you pushed back on a proposed solution because of platform risks or standards concerns? _(Source: MAAS database: MOLSON COORS BEVERAGE COMPANY)_

## 10 Troubleshooting Questions

1. How do you interact with the development team members, and how do you troubleshoot when someone says they're having performance issues - where do you start? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
2. Can you clarify your experience with incidents, incident response, or troubleshooting production issues? _(Source: MAAS database: MCLANE COMPANY, INC.)_
3. walk me through a significant production incident that you were involved in so well how did you diagnose the issue then what was your role in resolving it _(Source: MAAS database: ATTAIN)_
4. How do you design systems to avoid single points of failure? _(Source: Production-Level Errors in DevOps)_
5. Your SRE team wants dashboards showing CPU, latency, error rate, memory, traffic, and cost. How will you design a unified monitoring dashboard? _(Source: MAAS file: scenarios/scenario)_
6. What steps should be taken to troubleshoot pods that are experiencing a CrashLoopBackOff status in a production environment? _(Source: MAAS database)_
7. How would you debug a production level issue step by step and also give me example of resolving issue? _(Source: MAAS database: CAMBIA HEALTH SOLUTIONS)_
8. If you were in a situation where you get brought in, and SQL Server is experiencing high CPU utilization... what's the process that you follow on how to troubleshoot it? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
9. What is your process for troubleshooting a service that is crashing or returning incorrect responses? _(Source: MAAS database: CLOUDFLARE)_
10. How do you troubleshoot issues in a production AWS environment? _(Source: MAAS database: DISH)_

## 10 Scenario-Based Questions

1. Was this the first time you actually tested your DR strategy in a real production situation? _(Source: MAAS database: CRATE AND BARREL)_
2. In your first 90 days, how would you establish DevOps competency within this team and help others understand your role? _(Source: MAAS database: BRIGHT HORIZONS)_
3. Since this is a new DevOps role for the team, how would you build DevOps competency within the team in your first 90 days? _(Source: MAAS database: BRIGHT HORIZONS)_
4. If production is completely down and customers are impacted, how would you handle it? _(Source: MAAS database: CLOUDFLARE)_
5. . How would you describe your work‑style preference - individual projects or team‑based projects? _(Source: MAAS database: THE UNIVERSITY OF CHICAGO)_
6. What are effective strategies to reduce AWS cloud costs in a production environment? _(Source: MAAS database)_
7. If you had to choose an index strategy for a mixed OLTP and report workload, what would be your approach or strategy? _(Source: MAAS database: CLINICAL ARCHITECTURE)_
8. In your current role, do you lead problem management activities such as incident investigation and root cause analysis, or do you mainly contribute as part of a team led by someone else? _(Source: MAAS database: COMPUTERSHARE)_
9. Tell me about a **production incident** you handled - what was your role, and how did you prevent recurrence? _(Source: MAAS database: PREPASS)_
10. What would your plan/strategy be for migrating us to the cloud (besides consolidating the databases)? _(Source: MAAS database: STAGE FRONT)_
