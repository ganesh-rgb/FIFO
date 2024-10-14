
**My Synchronous FIFO's Elaborated Design**

  <img width="700" alt="image" src="https://github.com/user-attachments/assets/595685c2-e422-40c5-9a91-63e7cc1b89b8">

  <img width="858" alt="image" src="https://github.com/user-attachments/assets/53ffa243-4335-4ff8-9420-57598b8199f9">


+ **Synchronous FIFO Simulation Results**

  <img width="932" alt="image" src="https://github.com/user-attachments/assets/7b2bc39e-fc30-4c89-831f-9a719a1ef3ba">

**Asynchronous FIFO's Elaborated Design**
<img width="960" alt="image" src="https://github.com/user-attachments/assets/8c10c68d-5be0-4c0c-892b-86d4370f5570">

<img width="952" alt="image" src="https://github.com/user-attachments/assets/7c87e4fc-f2fb-40f4-a9bc-605e280f91ca">

+ **Asynchronous FIFO's Simulation Results**
  <img width="932" alt="image" src="https://github.com/user-attachments/assets/d2d0157c-aa40-457e-9f7e-a86f74288ad5">




+ **Elaborated Design of Asynchronous FIFO using Gray pointer & 2 Flipflop Synchronizer**
  <img width="942" alt="image" src="https://github.com/user-attachments/assets/68d72658-fe30-4d1d-ab4f-ee7be35e9b7d">

  <img width="953" alt="image" src="https://github.com/user-attachments/assets/a29aaac4-6c0b-40cf-824c-a2d525a21e9b">

+  **Simulation Results**
    <img width="952" alt="image" src="https://github.com/user-attachments/assets/7d1fae2a-a91f-4c48-b1d7-76bc1dfdbce0">




**Elaborated Design for Asynchronous FIFO for solving data miss problems in Clock Domain Crossing (CDC) given in Simulation and Synthesis Techniques for Asynchronous FIFO Design**
<img width="950" alt="image" src="https://github.com/user-attachments/assets/85cd388b-277e-483a-b9f6-f3bfeb4c9980">

<img width="943" alt="image" src="https://github.com/user-attachments/assets/a1299ac9-d51a-471a-b7fc-f3f7b38dcb6d">

+  **Simulation Results**
  <img width="941" alt="image" src="https://github.com/user-attachments/assets/6cc4f1e9-a4d7-40de-9048-1a86b42a6229">












# FIFO
In this repository, I have published my knowledge gained while working on FIFOs that handle variable length data  implementation using Verilog, System Verilog, UVM

First-in-first-out memories (FIFOs) have progressed from  fairly simple logic functions to high-speed buffers incorporating large blocks of SRAM. This application report takes a detailed look at the evolution of FIFO device functionality and at the architecture and application of FIFO devices. The first part presents the different functions of FIFOs and resulting types that are found. The second part deals with current FIFOs architecture and the different ways in where they work.

## Introduction:
In every item of digital equipment there is exchange of data between PCBs . Intermediate storage or buffering is always necesary when data arrive at the receiving PCB at a high rate or in batches, but processed slowly or irregularly.

Buffers of this kind also can be observed in every day life (for example, a queue of customers at the checkout point in a supermarket or cars backedup at traffic lights). The checkout point in a supermarket works slowly & constantly, while the number of customers coming into its very irregular. If many customers want to pay at the same time , a queue forms, which works by the priciple of **first come first served**. The backup at traffic lights is caused by the arrival of th cars, the traffic lights allowing them to pass through only in batches.

In electronic systems, buffers of this kind also are **advisable for interfaces between components that work at different speeds or irregularly**. Otherwise, the slowest compnent determines the operating speed of all other components involved in data transfer.

In a compact-disk player for instance, the speed of rotation of the disk determines the data rate. To make the reproduced sound fluctuations independent fo the speed, the data rate of A/D converter is  controlled by a quartz crystal. The **different data rates are compensated by buffering**. In this way, the sound fluctuations are largely independent of the speed at which disks rotate.


A FIFO is a special type of buffer. The name FIFO stands for first in first out and means that **the data written into the buffer first come out of its first**. There are other kinds of buffers like the **LIFO(last in first out)** often called stack memory. and the shared memory. The choice of buffer architecture depends on the application to be solved.

FIFOs can be implemented with software or hardware. The choice between a software and hardware solution depends on the application and the features desired. When rquirements change, a software FIFO easily to the by modifying the program. While a **Hardware FIFO**  demand a new boardlayout. Software is more flexible than hardware. The advantage of the hardware FIFOs shows in their  speed. A datarate of 3.6 gigabit per second is specified for **Texas Instruments model SN74ABT7819 FIFO**

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
In digital engineering, there is the constantly recurring problem of synchronizing two systems that work at different frequencies, Concurrent read/write FIFOs can also handle the data exchange between two systems of different frequencies, so internal synchronizing  circuits are called for. This section is a brief introduction to the problems that are involved in synchronization

The problem of synchronizing  an external signal with a local clock generator is solved by using a flip-flop. but this means violating the setup and hold times stated in the data sheets for the devices. As a result the flipflop can go into a metastable state.


<img width="503" alt="Picture6" src="https://github.com/user-attachments/assets/d066d5ef-e4a2-45f1-b7b5-192648895f7c">

**Synchronization of External Signal**


With a D-type flip-flop, the setup or hold times must be maintained. This means that for a short time before the clock edge (setup time) and for a  short time afterward(hold time) the level o the D input must not change to enure that the function of the flipflop is executed correctly.  If these conditions are  not maintained , the flip-flop can become metastable.

In RS flipflop, metastable states are possible if the reset and set inputs change from the active to the inactive state at the same time. In both cases the flipflop adopts an undefined and unstable, or  metastable, state.

No defined state can be ensured on the Q output. After a time, the flipflop goes into one of the two stable states, but it is impossible to predict.



<img width="677" alt="Picture7" src="https://github.com/user-attachments/assets/7e1fdc43-636d-4a81-bec8-05dd944c00f8">

**Timing Diagram for the Metastable state**



The Operating conditions for flipflop can be maintained easily in synchronous circuits. But with asynchronous circuits and in synchronous circuits, violation of the operating conditions for D and RS flipflop are unavoidable. 

Concurrent read/write  FIFOs that are  driven by two systems working asynchronous external signals.

For physical reasons, there  are no ideal flipflops with a setup and hold time of zero. so there can be no synchronizing  circuit(Fclk) and the lenght of critical time  window  (td).

MTBF = 1/fm x fclk x td
for fclk = 1MHz,
Fin of 1 KHz , and Td = 30 ps

**Mean time before failure(MTBF)** = 1/1 kHz x 1 MHz x 30 ps   = 33.3s



if a flip-flop, it is used  to synchronize  two  signals, you can no longer  expect the maximum delays stated in the data sheets, therefore , for reliable operation of a system, it is necessary to know wait after the clock pulse until the data is evaluated.

MTBF can be improved appreciably by multileve synchronization



<img width="556" alt="Picture9" src="https://github.com/user-attachments/assets/c494f83e-ea07-4797-9917-a5147934df00">

**Block Diagram of Two-Level Synchronization**

The second flipflop can only go into a metastable state if the flip-flop is already metastable. This metastablility can considerably increase the delay of the first flip-flop. But if the period of the clock signal is no longer than the sum of the increased delay plus the setup time of the second flipflop can never go into a metastable state.



<img width="534" alt="image" src="https://github.com/user-attachments/assets/73c9f8e5-cb4b-4604-b21c-811fd0cecea4">


**Timing Diagram for Two-level synchronization**

To measure metastability, conventional concurrent read/write FIFOs were operated region and the READ CLOCK input signal and EMPTYbar output signal were recorded for a period of 15  hours using a storage oscilloscope.


<img width="590" alt="image" src="https://github.com/user-attachments/assets/b2ac8c3e-f178-4ff5-90ab-cbf8307e281d">


**Signals of FIFO with Single-level Synchronization recorded for 15 hours under worst-case conditions**


The synchronizing flip-flops sometimes decides for 1 level and sometimes for a 0 level on the first clock edge. In some cases, the decision is obviously difficult for the flip-flop because it takes more time than normal. After the second clock edge, the output  is stable again in every case.

<img width="613" alt="image" src="https://github.com/user-attachments/assets/bf08a90f-c62d-48fc-9e51-9a52fe27d0a1">

**Signals of TI SN75ACT7807 FIFO with Three level synchronization**

#### ASYNCHRONOUS FIFOs:

The control signals of an asynchronous FIFO correspond most closely to human intuition and were, in the past, the only kind
of FIFO driving. the control lines of an asynchronous FIFO,
typical timing on these lines in a read and write operation.


<img width="428" alt="image" src="https://github.com/user-attachments/assets/1e2caff0-38ee-49d4-82a3-e90c81a91d45">

**Connections of Asynhronous FIFO**

+ The control lines WRITE CLOCK and FULLbar are used to write data. When a data word is to be written into an asynchronous
FIFO, it is first necessary to check whether there is space available in the FIFO. This is done by querying the FULL status line.

+ If free space is indicated, the data word is applied to the data inputs and written into the FIFO by a clock edge on the WRITE CLOCK input.

  
+ In analogous fashion, the control lines READ CLOCK and EMPTY are used to read data. In this case, the EMPTYbar status output has to be queried before reading, because data can be read out only if it is stored in the FIFO. Then, a clock edge is applied to the READ CLOCK input, causing the first word in the data queue to appear on the data output.

<img width="452" alt="image" src="https://github.com/user-attachments/assets/598a63b9-8b00-4b24-9ef6-cbd4ff41b00f">


**Timing Diagram for 4-bit Asychronous FIFO**

+ The timing diagram  shows the resetting of the FIFO that is always necessary at the beginning. Then, three data words are written in. The data words D1 through D3 appear one after the other on the INPUT DATA inputs and clock edges are applied to WRITE CLOCK for transfer of the data. Once the first data word has been written into the FIFO, the EMPTYbar signal changes from low level to high level.

+   Another two data words are written into the FIFO before the first read cycle. The subsequent reading out of the first data word with the aid of a clock edge on READ CLOCK does not alter the status signals. With the
writing of another two data words, the FIFO is full.

 + This is indicated by the FULL signal. Finally, the four data words D2 through D5 remaining in the FIFO are read out. Thus, the FIFO is empty again, so the EMPTYbar status line shows this by low level.

The disadvantage of a FIFO of this kind is that the status signals cannot be fully synchronized with the read and write clock.



<img width="434" alt="image" src="https://github.com/user-attachments/assets/d6c568d6-b42a-4d5b-8083-14860834fec2">

**Asynchronism When resetting FULLbar signal**

+ If there is space in the FIFO for only one data word, the next write cycle sets the FULL signal. Then, the writing system queries the FULL signal with the aid of its D flip-flop and waits until there is again space in the FIFO.

 + When a data word is read, READ CLOCK resets the FULL status line. This reset is synchronous with the reading system but asynchronous to the writing system.

+ In the worst case, the setup or hold time of the flip-flop in the writing system is violated. This flip-flop goes into a metastable
state, the results of which were discussed previously.

+ The problem described above also occurs with the EMPTY status signal. EMPTY should be synchronous with the reading system, but it is reset by the writing system. So, the resetting of EMPTY is inevitably asynchronous to the reading system.

+ This asynchronism is a result of the system, and synchronization is not possible within the asynchronous FIFO. If synchronization becomes necessary, the designer must provide it externally.

##### Synchronous FIFO:

+ Synchronous FIFOs are controlled based on methods of control proven in processor systems. Every digital processor system works synchronized with a system-wide clock signal. This system timing continues to run even if no actions are being executed.

+ Enable signals, also often called chip-select signals, start the synchronous execution of write and read operations in the various
devices, such as memories and ports.

+ The block diagram  shows all the signal lines of a synchronous FIFO. It requires a free-running clock from the writing system and another from the reading system. Writing is controlled by the WRITE ENABLE input synchronous with WRITE CLOCK.

+ The FULL status line can be synchronized entirely with WRITE CLOCK by the free-running clock. In an analogous manner, data words are read out by a low level on the READ ENABLE input synchronous with READ CLOCK.
  
+ Here, too, the free-running clock permits 100 percent synchronization of the EMPTY signal with READ CLOCK.

  <img width="286" alt="image" src="https://github.com/user-attachments/assets/52b5e03b-d5f3-4c10-bbab-27e3e447c7f7">

  **Connections of Synchronous FIFO**

  + Thus, synchronous FIFOs are integrated easily into common processor architectures, offering complete synchronism of the
FULL and EMPTY status signals with the particular free-running clock.


<img width="357" alt="image" src="https://github.com/user-attachments/assets/77af4e07-c976-4717-a692-b41c81e87eda">

**Timing Diagram of Synchronous FIFO of 4-bit length**

+ WRITE CLOCK and READ CLOCK are free running. The writing of new data into the FIFO is initialized by a low level on the WRITE ENABLE line. The data are written into the FIFO with the next rising edge of WRITE CLOCK.

+   In analogous fashion, the READ ENABLE line controls the reading out of data synchronous with READ CLOCK.
All status lines within the FIFO can be synchronized by the two free-running-clock signals. The FULL line only changes its
level synchronously with WRITE CLOCK, even if the change is produced by the reading of a data word. Likewise, the EMPTY
signal is synchronized with READ CLOCK. A synchronous FIFO is the only concurrent read/write FIFO in which the status
signals are synchronized with the driving logic.
  
**NOTE: All TI Synchronous FIFOs feature multilevel synchronization of the status lines**
