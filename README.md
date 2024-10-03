# FIFO
In this repository, I have published my knowledge gained while working on FIFOs that handle variable length data  implementation using Verilog, System Verilog, UVM

First-in-first-out memories (FIFOs) have progressed from  fairly simple logic functions to high-speed buffers incorporating large blocks of SRAM. This application report takes a detailed look at the evolution of FIFO device functionality and at the architecture and application of FIFO devices. The first part presents the different functions of FIFOs and resulting types that are found. The second part deals withb current FIFOs architecture and the different ways in where they work.

## Introduction:
In every item of digital equipment there is exchange of data between PCBs . Intermediate storage or buffering is always necesary when data arrive at the receiving PCB at a high rate or in batches, but processed slowly or irregularly.

Buffers of this kind also can be observed in every day life (for example, a queue of customers at the checkout point in a supermarket or cars backedup at traffic lights). The checkout point in a supermarket works slowly & constantly, while the number of customers coming into its very irregular. If many customers want to pay at the same time , a queue forms, which works by the priciple of **first come first served**. The backup at traffic lights is caused by the arrival of th cars, the traffic lights allowing them to pass through only in batches.

In electronic systems, buffers of this kind also are **advisable for interfaces between components that work at different speeds or irregularly**. Otherwise, the slowest compnent determines the operating speed of all other components involved in data transfer.

In a compact-disk player for instance, the speed of rotation of the disk determines the data rate. To make the reproduced sound fluctuations independent fo the speed, the data rate of A/D converter is  controlled by a quartz crystal. The **different data rates are compensated by buffering**. In this way, the sound fluctuations are largely independent of the speed at which disks rotate.


A FIFO is a special type of buffer. The name FIFO stands for first in first out and means that ****the data written into the buffer first come out of its first**. There are other kinds of buffers like the **LIFO(last in first out)** often called stack memory. and the shared memory. The choice o buffer architecture depends on the application to be solved.

FIFOs can be implemented with software or hardware. The choice between a software and hardware solution depends on the application and the features desired. When rquirements change, a software FIFO easily to the by modifying the program. While a **Hardware FIFO** may demand a new boardlayout. Software is more flexible than hardware. The advantage of the hardware FIFOs shows in their  speed. A datarate of 3.6 gigabit per second is specified for **Texas Instruments model SN74ABT7819 FIFO**

***FIFO TYPES***
Every memory in which the data word that is written first also comes out first when the memory is read is a first-in-first-out memory. 

* Shift register - FIFO with an invariable number of stored data words and thus, the necessary synchronism between the read and the write operations because a data word must be read every time one is written.
* Exclusive read/write FIFO - FIFO with a variable number of stored data words and, because of internal structure, the necessary synchronism between the read and the write operations
* Concurrent read/write FIFO - FIFO with a variable number of stored data words and possible asynchronism between the read and write operation
                               



<img width="108" alt="Picture5" src="https://github.com/user-attachments/assets/cb12fb9f-d104-4899-a112-5012ff9473a1">

**First-in-First-Out Data Flow**


The **shift register is not usually referred to as a FIFO,** although it is first-in-first-out in nature.


Two electronic systems are always connected to **I/O of FIFO**.one that writes and one that reads. If certain timing conditions must be maintained between the writing and reading the systems. 

We speak of exclusive read/write FIFOs, because the two **systems must be syncronized**. 
if there are no timing restrictions in how the systems are driven meaning that the writing systems and the reading systems can work out of synchronism , the FIFO  is called concurrent read/write. 

The first FIFO design to appear on the the market were **exclusive read/write because these were easier to implement**.

Nearly, all present FIFOs are concurrent read/write because so many applications call  for concurrent read/write versions. 
Concurrent read/write FIFOs can be used in synchronous systems without any difficulty.



**Exclusive Read/Write FIFOs**

In exclusive read/write FIFOs, the writing of data is not independent of how the data are read.  There are timing relationships between the write clock and the read clock. For instance, overlaping of the read write blocks could be prohibited. To permit use of such FIFOs, between two systems tha work  asynchronously to one another, an external circuit is required for synchronization. But this synchronization circuit usually considerably reduces the data rate.

**Concurrent Read/Write FIFOs**

In concurrent read write FIFOs, there is dependence between the writing and reading of data. Simulataneously writing and reading are possible in overlapping fashion or successively. This means that two systems with different frequencies can be connected to FIFO.

The designer need not worry about **synchronizing** the two systems because this is taken care of in the FIFO. Concurrent read/write FIFOs, depending on he control signals for writing and reading, fall into two categories.

+ Synchronous  FIFOs
+ Asynchronous FIFOs

**Metastability of Synchronizing Circuits**:


