# OCI System Design Principles

OCI System Design Principles are a set of evolving requirements and recommendations that describe
what is important when building cloud-scale services at OCI for customers. Customers can be both
external to OCI and internal OCI partners due to the cascading dependencies that determine whether
users who consume a service have a positive or negative experience.

The guidance provided here is intended to shape systems to more easily meet the requirements of
OCI Security; Operations; Oracle Cloud Compliance & Assurance (OCCA); API Review Board, and
others. For specific team requirements, see the following sections:

- Architecture Guidelines
- Operational Readiness Requirements
- Compliance Onboarding
- API Review and Signoff Board
- Platform Bar

Note: The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

## Availability

### AV-1: Deployments Must Not Impact Availability

**Requirement:**
All deployments within the system must not impact availability.

**Guidance:**
For any HA component, some form of load balancing must be used—either client-side or provided by
a separate component dedicated to load balancing. For non-HA components, you must implement
the ability to perform in-service upgrades for all deployment modes that can support them (this is
targeted at data planes where in-service upgrades might not be possible for non-HA components).

### AV-2: Control Plane Availability Must Meet OCI's Advertised Rate

**Requirement:**
Deployments must not impact availability for public-facing Control Plane APIs. A service typically has
enough transient failures that reduce its availability such that it cannot afford to impact its availability
further with regular deployments. Guidance around how to calculate availability can be found here:
[OCI Health](https://confluence.oraclecorp.com/confluence/x/8IRj4wI). OCI's public IaaS SLAs are documented
in the [Oracle Cloud Infrastructure Service Level Agreement (SLA)](https://cloud.oracle.com/iaas/SLA).

**Guidance:**
The use of a load balancer and a highly available request-serving fleet is the traditional model most
services implement. The canonical control plane is built with the following: A load balancer, a
stateless fleet of request routing service instances, a stateless fleet of API service instances, and a
highly available data store.

Keep in mind the availability of any single feature is the multiplicative product of the availability of all
its dependencies, and itself. Thus, the availability of each of the system's components along a critical
path must be higher than your availability goals.

### AV-3: The System Must Not Propagate the Failure of a Single Non-Critical Component

**Requirement:**
The system must degrade gracefully in the event a non-critical component fails.

**Guidance:**
Non-critical components that participate in building a response should be able to mark the section of
their response as undefined, or a cached value where strong consistency is not required.

### AV-4: The System Must Implement Region Independence

**Requirement:**
One region does not impact the availability of other regions. Regions need to fail independently, and
for each coupling of regions, they must be known, owned, and intentional.

**Guidance:**
The system must not have an operationally significant dependency that is outside the region it is
deployed in. This often means at least one deployment per region, often more (see [Service Cells : a
way to limit blast radius](https://confluence.oraclecorp.com/confluence/x/PC769AI) for a pattern for
implementing strong isolation between "stacks" within a
region, availability domain, or fault domain). For services that require cross-region communication
(for example, identity's replication of data), this must be resilient to outages. The inability to
communicate with another region should simply increase the duration which a given region's data can be
inconsistent but must not prevent its operation.

For additional guidance, see [Definition of AD Independence](https://confluence.oraclecorp.com/confluence/x/PC769AI).
Note that where possible, every feature should be availability domain-local unless there's a good reason to make it regional.
Good reasons include:

1. Technical requirements, such as very high durability (for synchronous writes) that cannot be
   satisfied within a single availability domain, as a single availability domain can be destroyed in a
   fire or flood.
2. Business context, for example, time to market, development complexity/cost, and risk to quality.
   Some of these might be mitigated over time, allowing an availability domain-local version of the
   feature to be launched later.

### AV-5: Your Service Implements Proper Flow Control Between Components and Its Dependencies

**Requirement:**
Both clients and services must prevent the brown-out of themselves by their callers, and failing
dependencies.

**Guidance:**
Proper flow control between components is critical to maintaining an available system. Here's
specific guidance for both clients and servers.

**Clients:** Exponential back-off and jitter are a minimum requirement for retry policies. The use of bulk
heading to prevent a single request pool from being exhausted and the use of circuit breakers is
ideal. Retry policies SHOULD never retry client errors. A client error indicates the request must be
modified before retrying.

**Servers:** Servers SHOULD respond with enough context that clients can determine if they can retry a
request, and how long to wait before retrying. Rate limiting (throttling), even for system-internal
callers, and load shedding are recommended to protect your service against unexpected request
rate spikes that would otherwise negatively impact all customers. There are several possible
implementations of rate limiting: distributed throttling through a highly-available dedicated throttling
service, distributed state through gossip mechanism from your server application instances, locally
maintained token bucket state, or back-pressure provided by a dependency.

### AV-6: System Implements Resource-Consumption Fairness for Components That Are Susceptible to Noisy Neighbors

**Requirement:**
A single large customer, or many smaller ones, cannot completely saturate your service such that it
rejects requests from infrequent users.

**Guidance:**
This requirement is an extension of AV-5's flow control requirement. It's insufficient for a service to
prevent itself from becoming overwhelmed by an increased load, the service must also prevent a
single large customer from monopolizing all available resources. Practically, this looks like tuning the
request rate and enqueued requests that can be made by a single customer to be lower than the
overall achievable request rate and enqueued requests by the service.

### AV-7: (Recommendation) Loosely Couple Components Through Asynchronous Messaging To Improve Fault Tolerance

**Requirement:**
Discrete components MAY rely on asynchronous messaging as a way to improve their ability to cope
with failures among their dependencies.

**Note:** This is applicable only when the features of the system do not require synchronous
communication.

**Guidance:**
Asynchronous messaging helps reduce several types of coupling. This recommendation focuses on
temporal coupling.

Temporal coupling among asynchronous components refers to the degree to which the sending and
handling of a message are connected in time. Queues between components, whether provided by a
purpose-built dependency (for example, Oracle Streaming Service) or mimicked in an existing data
store dependency, help reduce temporal coupling. An asynchronous queue between components
allows you to absorb spikes in load, and scale services independently of others, at the cost of
introducing an intermediary. This benefit comes at the cost of transactional integrity and consistency
—it's more difficult to provide transactional integrity across a set of asynchronous components than
in a synchronous system.

## Durability

### DUR-1: Durability Is More Important Than Availability for Most Systems at OCI

**Requirement:**
OCI favors the durability of customer data accepted by the service over availability.

**Guidance:**
OCI services promise to safely store data so that it can be retrieved when it's requested. This applies
to all forms of data that are sent to a service unless explicitly communicated. It extends to accepting
requests as well: It is better to fail to respond to a request than to acknowledge a request and forget
about it later. You must only acknowledge requests after their intent is durably persisted.

However, it is better for a service to not respond or respond that it is temporarily unavailable (which
is an availability error) than to indicate it cannot find data when it should (which is a durability
error). Another important factor that goes along with failure rates is the time to re-replicate or
restore the data. You must understand the probability of failure while you're restoring replicas
because that affects the durability.

### DUR-2: Low-Latency Synchronous Replication Throughout a Region Should Be Employed for Durability

**Requirement:**
Data must be durably persisted across a region to tolerate the loss of at least one copy. Individual
product requirements might dictate a higher degree of durability. In general, your solution must
durably copy data such that the probability of correlated physical failures does not prevent you from
achieving your durability requirements.

### DUR-3: Idempotency Tokens Must Be Durably Persisted

**Requirement:**
Idempotent operations are those where you retry a request and the results are always the same,
which is a property that's beneficial in distributed systems. Client-provided idempotency tokens
must be durably persisted so that the service can process a retried request without introducing
unintended side effects.

**Guidance:**
Durably recording the intent of a request SHOULD also include its token, and they MUST be honored
for 24 hours from their first use per the API guidelines for [Retryable Creates](https://confluence.oraclecorp.com/confluence/x/GU7_CAM).

### DUR-4: The System's Backup and Restore Processes Are Well-Defined and Regularly Tested

**Requirement:**
Regularly assert the correctness of backups by recovering from them, and testing the resultant
environment passes all other tests.

**Guidance:**
Your build pipeline should include automated tests for your backup and restore processes so their
correctness is asserted for every build that makes it to production.

## Resiliency

### RES-1: The Components of Your Service Recover From Failure Without Human Intervention Instead of a Complete Disaster

**Requirement:**
Each component within your service MUST be able to operate in a degraded state. As the service's
dependencies become available, each component MUST be able to return to a healthy state without
human intervention.

**Guidance:**
Assume all the service's dependencies will fail, and build in mechanisms for coping with that reality.
You SHOULD optimize the time to restart each component in the service so failures during start-up
can be quickly retried - this also implies you have a throttling mechanism for how quickly a service is
restarted so frequent failures do not impact dependencies.

Graceful degradation of a component can be handled with several strategies, often employed
together. These are some internal mechanisms for dealing with failures within a component:

1. **Bulkheading:** Prevent a failing dependency from monopolizing resources within the component
   by limiting resources the component reserves while interacting with that dependency (for
   example, limit thread pool size).
2. **Circuit Breaking:** Employ this strategy to control the rate at which a component attempts to
   communicate with a failing dependency.

Having an external mechanism for asserting the health of a component (typically an individual
process or container), and killing it based on some well-thought-out rules is ideal for failures that
aren't necessarily related to dependencies, such as running out of memory, infinite loops, and fork
bombs. Note that OCI does not have a general solution for this today. The closest thing we have is
the use of OKE and Kubernetes liveness and readiness probes. Care must be taken when defining
restart policies as an intermittent failure can be exacerbated by rapidly restarting many components.
Think about how your health checks and restart policies might introduce correlated failures across an
entire fleet—for both critical and non-critical dependencies.

### RES-2: The Service Does Not Introduce Cyclic Dependencies Among Operationally Significant Dependencies

**Requirement:**
An "operationally significant dependency" is a dependency that could prevent or delay the customer
from using the feature. The set of dependencies that support the critical customer-facing features of
a service must not introduce cyclic dependencies such that the service cannot be recovered in the
event of an outage.

**Guidance:**
Cyclic dependencies between a service and one of its operationally significant dependencies often
prevent a service from being able to come back online after an outage. A service MUST actively
prevent introducing cyclic dependencies—being careful not to introduce transitive cyclic
dependencies. You should model the graph of service dependencies, and look for cycles in each of
the following scenarios:

1. Steady State: The dependency graph when your service is healthy and operating well.
2. Service failover: When the service needs to failover, but one of its dependencies during failover
   also depends upon the service.
3. Region Bootstrap: The service needs to be able to start, even in a degraded mode, during
   region build to support its dependencies without those same dependencies requiring the entire
   service to be operational.
4. Small Scale Events: Small operational events that the system is not designed to recover
   automatically from.
5. Large Scale Events: Large events on the order of a region or availability domain reboot. These
   often look a lot like region bootstrap but can have more dependencies because the system is
   likely to have entered into a steady state before the LSE.

### RES-3: Disaster Recovery Must Be Documented and Routinely Tested

**Requirement:**
Disaster recovery can only be assumed to work if it is routinely tested.

**Guidance:**
You must routinely test your system to verify it behaves reliably during disaster recovery. Automating
the process is best but often requires effort inversely proportional to the time it takes to manually
execute a recovery plan. You must at least document the process, and routinely test that it works.
The incremental effort of doing so should motivate you to automate as much of the process as
possible.

### RES-4: AD-Local Features Must Be Particularly Hardened Against Emergent Performance Degradation

**Requirement:**
The service MUST maintain consistent performance in the face of emergent behavior.

**Guidance:**
Examples of emergent performance degradation include: thrash, spin-crashing, cold-shock due to
restarting with empty caches, and packet loss. These are typically caused by misbehavior of
software in other availability domains, or changing behavior of customers during a large-scale
outage. For example, this means mitigating (tolerating) or preventing DDoS attacks for the following
reasons:

1. When an availability domain fails, remaining availability domains experience a large spike in
   requests from customers for replacement resources. We must have good throttling
   mechanisms in place and tested.
2. When an availability domain partially fails, a control plane experiences a large spike in the cost
   of failure detection and failure handling. This must not be allowed to reduce availability in other
   availability domains. We do this by building "availability domain local control planes", that is,
   control planes that are as stand-alone as possible.

### RES-5: Implement Mechanisms for Recovering From Corrupted or Deleted State

**Requirement:**
The detection and recovery from an invalid state must be possible.

**Guidance:**
The system must retain a significant amount of recent history such that it can restore its state to the
last known good state. This typically involves implementing a special undo mechanism that can
identify the last known good state, and logically undo bad committed transactions in an emergency.

Eventually, the process for retaining a system's recent history relies on the Kiev Event Stream.
See [Summary of Recovery Oriented Computing](https://confluence.oraclecorp.com/confluence/x/RC769AI) for current recommendations.

### RES-6: Mean Time Between Failures Should Not Decrease Significantly with System Size

**Requirement:**
As the system's size or usage increases you must prioritize engineering efforts to prevent the Mean
Time Between Failures (MTBF) from decreasing significantly.

**Guidance:**
Measuring and tracking MTBF is the first step. Second, as failures are detected, triaged, and fixed,
evaluate whether they should be translated into system improvements. Track these feature requests
along with your existing engineering work and prioritize them regularly. The CAPA Process provides a
framework for evaluating significant failures and a mechanism for prioritizing features to prevent
similar problems in the future.

### RES-7: Mean Time To Recovery Should Not Increase Significantly with System Size

**Requirement:**
As the system's size or usage increases, you must prioritize engineering efforts to prevent the Mean
Time To Recovery (MTTR) from increasing significantly.

**Guidance:**
This requirement looks a lot like RES-6 but requires specific attention because the system needs to
be able to recover from failure quickly at any size, regardless of how infrequently it can fail. Outage
duration directly impacts the system's ability to meet its Availability SLA.

You must aggressively optimize MTTR at every stage of the system's development. Postponing until
a "hardening cycle" is insufficient as much of the preparation should be done at the time
functionality is introduced. This preparation comes in the form of pervasive contract assertions in
code; bulkheading throughout the system, down to the smallest unit of isolation; optimizing the time
to restart each unit of isolation (see RES-1); and rate limiting for when things are stuck in a crash
loop.

When the system has been established (for example, launched into production) then the regular
measurement of MTTR helps you understand when it's time to reinvest. As stated in RES-6, the
CAPA process provides a framework for evaluating significant failures and a mechanism for
prioritizing features to prevent similar problems, as well as recovering from them more quickly in the
future.

## Scaling and Performance

### SP-1: The Bottlenecks of Each Component Within the System Are Well-Understood

**Requirement:**
A system's feature is only as performant as the weakest component involved in supporting that
feature.

**Guidance:**
To know the limits of the system is to know the limits of each component. This information helps
inform contracts for flow control between components and needs to be tested regularly.

Every component in the system should be tested to its breaking point along every appreciable
dimension. For typically front-end service applications that provide an API this means request rate.
Make sure your tests use a request load that is representative of all your production regions,
accounting for variation caused by date and time. Other components such as caches and data stores
should be tested for throughput at various miss rates, and key and object sizes. Workflow systems
typically need to consider how queue depth affects their ability to schedule work. Think carefully
about what can break each of your components and understand what their tipping point is. Then see
SP-2 for how to proactively signal when action needs to be taken to prevent a bottleneck from
becoming customer-visible.

### SP-2: Have a Mechanism for Assessing and Alarming When Action Needs to Be Taken to Scale a Component Within the System

**Requirement:**
The system MUST avoid hitting a bottleneck by proactively monitoring and signaling when a
component is nearing one.

**Guidance:**
Building observable components is critical to properly automating the detection and signaling of
impending doom. Make sure each of your components is well instrumented to emit metrics that
enable you to define alarms to signal problems. You should tune your alarms such that they fire well
in advance, giving you enough time to improve and change the system before the bottleneck
becomes customer-visible.

### SP-3: Use Infrastructure in a Cost-Efficient Manner

**Requirement:**
The resources required by the system to perform a unit of work SHOULD be within a close constant
factor of resources used by competitive systems of a similar nature.

**Guidance:**
Be cognizant of the overhead each architectural and implementation decision you make adds to the
overall system. Consider how the strategy for implementing multi-tenancy translates into resource
requirements. Adding resources allows your system to handle approximately linearly more demand;
where 'demand' is typically measured by one or more of the following: request rate, aggregate data
volume, change in distribution of record size, and new access patterns.

### SP-4: Availability and Durability Is Maintained or Improves as Demand Increases

**Requirement:**
The system MUST maintain availability and durability as load increases.

**Guidance:**
Understanding the limits of each component within the system is critical to safeguarding the stability
of the system as a whole at peak load. Each of those known limits SHOULD translate into proper
safeguards in the form of load balancing strategies, admission control, and flow control between
components within the system and its external dependencies.

### SP-5: Use Isolated Pools of Capacity

**Requirement:**
Capacity within your system should be isolated to multiple pools or cells, such that they
independently fail.

**Guidance:**
Limiting the blast radius of failure between customers is important to prevent emergent Small Scale
Events from becoming Large Scale Events (LSE). This is bulk-heading at the macro level. Each pool
(or cell) of capacity should be upgraded independently to prevent a problematic change from
affecting more than a small number of customers before being detected and rolled back.

See **Service Cells:** a way to limit blast radius for a pattern for implementing strong isolation
between "stacks" within a region, availability domain, or fault domain. Side note, you SHOULD be
able to move customers between pools, ideally without downtime.

See the Principles of Designing Fault-Tolerant Scalable Distributed Systems section
on [Surviving the Black Swans](https://confluence.oraclecorp.com/confluence/x/RC769AI#Survive+the+Black+Swans)
for more context.

### SP-6: System Must Maintain Predictable Performance at Peak Load

**Requirement:**
The system must protect itself from unexpected performance degradations when it experiences
peak load.

**Guidance:**
You must routinely test your system to verify it behaves predictably under peak load. You must
become an edge detector (not in the Image Recognition sense, in the metrics and behavior sense).
Measuring a system's capacity is often easier to do by reasoning about the mean concurrency of the
system in the context of Little's Law. Effectively, the average concurrency of the system (L) is equal
to the mean arrival rate of requests (λ) multiplied by the mean time the system takes to process each
request (W); L = λW. Little's Law is an insufficient tool by itself to model the entirety of a system's
behavior. You'll end up with a much more accurate model if you consider how the behavior of the
system changes over time: how λ changes as L increases, and how W changes as λ increases. You
must identify the discrete points at which λ and W significantly change L, and implement
mechanisms to prevent λ and W from decreasing L beyond a tolerable threshold so the system
maintains predictable performance.

There are several useful mechanisms to achieve predictable behavior under peak load. Some of them
are:

1. Proper flow control between components. Bound the number of requests you accept at a given
   time, and over time, per host, and in aggregate across your system. Some strategies for
   achieving proper flow control are back pressure, admission control, throttling, and client-side
   retry policies with proper backoff strategies.
2. Force a client to renegotiate periodically to ensure the load is distributed well across your
   system. This is typically achieved by limiting the total number of logical requests made over an
   established channel.
3. Bounding the amount of concurrent work any single component attempts to complete at a
   time. This manifests itself as limiting the total threads or coroutines used to process work at
   any given time, bounding the length of pending work requests to a queue, or minimizing the
   effect of a growing set of outstanding work from impacting your ability to schedule that same
   work.

### SP-7: Automated Performance Tests Are Part of a Continuous Deployment Process

**Requirement:**
Performance test checks must be part of your continuous integration/deployment process to verify
performance goals are maintained and do not regress with every deployment.

**Guidance:**
Performance tests and canaries can have a great deal of overlap. Consider reusing canaries for this
purpose. Running continuous performance tests as canaries would be ideal and verify that your
system implements noisy neighbor mitigation as well.

## Ability to Meet Customer Expectations

### CE-1: Provide Read-after-Write Consistency Where Important

**Requirement:**
It's much easier to build on top of systems that provide read-after-write consistency, and
customers often assume it exists even when a system does not explicitly state support for it.

### CE-2: Maximize Business Value, Even in the Face of Degradation

**Requirement:**
Highly available services are great, but ones that prioritize requests based on business value are
objectively better.

**Guidance:**
The system should prioritize requests according to the business value of the customer and the type
of request. For example, a request from one of your top 5 paying customers has vastly higher
business value than a request from a free-tier customer. Even for a high-value customer, some types
of requests have higher business value than others – for example, a request to restrict access to an
existing resource (close a security hole) is likely more valuable than a request to create a new
resource.

This practice enables a huge improvement in overload protection (load-shedding), as the system can
reject or delay the processing of requests that have lower business value. That value-based cut-off
means that a struggling/recovering system might still be able to serve your most important
customers, which radically reduces the business impact of many failure modes, particularly
sustained emergent performance degradation (distributed thrash). If instead, the system rejects
overload randomly, or even by the standard naive 'leaky bucket', then the most valuable customers
get a bad experience, roughly the same experience as users who as yet have very little value.

See Principles of Designing Fault-Tolerant Scalable Distributed Systems for more context.

### CE-3: Be Prepared for Change

**Requirement:**
Define a framework for modifying the system in the face of changing requirements.

**Guidance:**
"Software Architecture: A framework for the disciplined introduction of change" – Tom Demarco

Because change is inevitable, and without a framework for change, each change results in hacks,
and hacks significantly increase the probability of bugs, operator errors, and sustained emergent
performance degradation. So explicitly consider the space of possible future changes, without
getting trapped in analysis paralysis. The space of possible changes includes additional features,
additional non-functional requirements (for example, reducing costs), different execution
environments, and of course, rapid growth of request rates, record sizes, or data volume –
see [Definition of 'Scalability' for a distributed system](https://confluence.oraclecorp.com/confluence/x/Z0v_CAM).

See [Principles of Designing Fault-Tolerant Scalable Distributed Systems](https://confluence.oraclecorp.com/confluence/x/RC769AI)
for more context.

### CE-4: Logically Distinct Features Should Have Separate Availability Profiles

**Requirement:**
At a minimum, control planes and data planes must not be susceptible to correlated failures.

**Guidance:**
Data planes must not depend on control planes. The components that provide functionality
representing the control plane must be logically distinct from those that support the data plane.
Also, to recover from large infrastructure outages, the control plane must be able to scale out to
handle peak demand by customers.

For more context, see Principles of Designing Fault-Tolerant Scalable Distributed Systems
and Reasons for separating control plane from data plane .

### CE-5: Align Service Expectations to Customer Expectations

**Requirement:**
At a minimum, document your customer's expectations and align your service's expectations to your
customer's.

**Guidance:**

- Examine every aspect of system design from the customer's experience of it.
- Document not just what each endpoint does and how to use it, but also when and where to use
  it–and when not to use it.
- Have your designs reviewed by members of other teams to assess how usable they are.

## Region Bootstrap

### RB-1: Each Component Can Be Started When Its Dependencies Are Unavailable

**Requirement:**
The system's components MUST be able to start before its dependencies are available, and
eventually become healthy.

**Guidance:**
During region bootstrap, it's often difficult or impossible to synchronize and serialize the bringing up
of all systems. To optimize and improve our region bootstrap timing, all systems should be able to
start or attempt to start, before all of their dependencies are available. Components SHOULD be able
to operate in a degraded state when their dependencies are unavailable or quickly restart so that
they become healthy soon after their dependencies become available.

### RB-2: Automate Standup and Validation of a New Stack or Cell Within a Region in Six Hours

**Requirement:**
A system must be able to be brought online within 6 hours of its hardware and software
dependencies becoming available.

**Guidance:**
Build tooling that enables the system to be deployed in a new region quickly, with limited need to
customize.

### RB-3: Your Seed Stack Is Regularly Tested and Resembles Your Steady State Stack as Technically Possible

**Requirement:**
This applies to systems that must be deployed early in the region build process, the "seed."
Typically, these systems have special "seed stacks" that implement the functional requirements of a
subset of features provided by the system to break circular dependencies during the initial region
bootstrap. These seed stacks MUST be regularly tested.

**Guidance:**
The system MUST have automated tests that are regularly run, typically as part of a CI/CD pipeline, to
verify the seed build against its functional contracts.

## Security

### SEC-1: Customer-Facing APIs Follow API Review Board Recommendations

**Requirement:**
Customer-facing APIs must be approved by the API Review and Signoff Board to maintain consistency across to maintain all OCI APIs.

**Guidance:**
Review the API Consistency Guidelines and use the recommended tooling for a good starting
point. While the requirement is for customer-facing APIs, you should strongly consider relying on the
same mechanism to define internal APIs unless there's a specific justification against doing so. Using
the same toolchain for all APIs creates a cohesive standard mechanism for communicating between
services, regardless of whether we consider them customer-facing or not. Consider the dependency
requirements you might be forcing on your callers should you adopt another process.

### SEC-2: Secrets Are Stored Ephemerally and Are Only Accessible by the Processes That Require Them

**Requirement:**
Secrets must not be persisted to durable storage and must only be accessible by the processes that
require them, for no longer than is required.

**Guidance:**
Use Secrets Service to durably store the secrets. When using the secrets, store them ephemerally in
memory-backed file systems (for example, a RAM drive and RAM FS) with appropriately restrictive
permissions to prevent processes from accessing secrets that should not be able to.

### SEC-3: Features Must Remain Secure

**Requirement:**
Every feature exposed by your service MUST fail closed in the face of failure.

**Guidance:**
Consider the implications of your system making the wrong decision based on inconsistent data,
while coping with a local failure, or the failure of a dependency. Its decisions must never compromise
the security of the system or the data it contains.

### SEC-4: Communication Is Encrypted in Transit

**Requirement:**
Communication to the system, between the system and its dependencies, and within the system,
must be encrypted.

**Guidance:**
Use a layered approach: TLS for encryption, and some form of authorization and authentication on
top of it. Encrypting traffic might not be necessary for all data planes (for example, block storage
doesn't encrypt traffic), however, encrypting communication in control planes should be required.
See [Fine-grained Authorization](https://confluence.oraclecorp.com/confluence/x/oHl-5wI) to learn
more about a strategy that relies on OCI Identity for access management.

### SEC-5: Follow Global Product Security Coding and Cryptographic Algorithm Standards

**Requirement:**
The Oracle Secure Coding Standards (SCS) and Cryptographic Algorithms Standards are mandatory
directives that all developers must follow to avoid introducing known types of security flaws when
writing code.

**Guidance:**
Adhere to the requirements detailed in the Secure Coding Standards, the Cryptographic Algorithms
Standards, and other Oracle Software Security Assurance (OSSA) directives.

## Operations and Ownership

### OO-1: Human-Based Operational Load Scales Sub-Linearly with Deployment Footprint

**Requirement:**
As you deploy more isolated stacks or expand the size of an existing deployment, the operational
load for maintaining your service for humans scales sub-linearly.

**Guidance:**
Design components to gracefully handle failure and automatically recover. A self-healing system
does not require manual intervention. Your components should be able to operate in a degraded
state and be able to tell others (through health checks) when they are doing so.

### OO-2: Human Operators Have a Documented and Audited Procedure for Obtaining Access to Environments

**Requirement:**
Access to the system's environment is logged, audited, and clearly documented.

**Guidance:**
At some point a human operator is likely to have to access the environment the system runs in for
various reasons. This should always be in response to an operational event or as part of an explicit
instruction in a CHANGE ticket. Access to the environment needs to be clearly documented so the
same process is consistently followed by all operators. There should be a small number of options
for obtaining access to reduce the surface areas that need to be secured.

Additionally, any service under "Compliance Scope" for nearly any certification needs to log all
access to the system and integrate with OCI's centralized audit system. For more information,
see [SIEM](https://confluence.oraclecorp.com/confluence/x/Nd283QI) and
[Onboarding with Splunk](https://confluence.oraclecorp.com/confluence/x/2t_83QI).

### OO-3: The System Is Observable

**Requirement:**
The system must be instrumented such that an operator can observe the health of the system down
to the granularity required to identify an individual component and/or feature.

**Guidance:**
You must instrument your services with metrics and logging, and integrate with an external service
that supports alarming and indexing on each. For Native OCI services, the supported services
are OCI Telemetry and OCI Lumberjack.

### OO-4: Build Canaries to Continuously Test the System

**Requirement:**
Do not rely on your customers to discover emergent issues. Write automated processes to discover
them before your customers do. The thresholds that alert you to problems should be far more
sensitive than what your customers would consider degradation.

**Guidance:**
Canaries typically look like a simple application your customers would write. Make sure that your
canaries use the same communication paths your customers do, and potentially other ones, to help
you understand which parts of your system are unhealthy when degradation is detected. For
example, canaries should leverage the same DNS servers and LBs that customers do. Each canary
should be considered a critical component of your system and subject to many of the
recommendations listed here. Specifically, it must be observable!

### OO-5: Timeouts and Retries Are Dynamically Configurable

**Requirement:**
Certain sections of the system's configuration must be dynamically configurable so they can be
modified to mitigate an operational event in real time.

**Guidance:**
Store a subset of the system's configuration in a mutable data store and provide reasonable defaults
for when that data store is unavailable. Be wary of building automated processes that change this
configuration without proper safeguards in place to limit their rate of change. Build tools for humans
so they can quickly modify the behavior of the system, within tested limits, in response to an
operational event.

For cases where configuration comes from two sources, for example, "static" HOCON on disk with
optional "dynamic" overrides through Properties Service: teams might consider emitting a metric
when the two sources vary, otherwise, the static config can be misleading (or incorrect if/when the
data store is not available).
