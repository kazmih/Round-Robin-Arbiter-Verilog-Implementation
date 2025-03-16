# Round-Robin Arbiter Implementation

## Overview
This repository contains a Verilog implementation of a 4-bit round-robin arbiter. The arbiter is designed to fairly allocate resources among multiple requestors in a sequential, cyclic manner, ensuring that no single requestor can monopolize the resource.

## Design Details
The arbiter employs a finite state machine (FSM) approach with the following components:

- 4-bit input request vector (`req[3:0]`)
- 4-bit output grant vector (`grant[3:0]`)
- 5 states (IDLE, S_0, S_1, S_2, S_3)
- Round-robin priority scheme

### State Diagram

![statediag](https://github.com/user-attachments/assets/ae73ee1d-6709-42cd-b79a-332f6471a00c)

### State Transition Logic
The state machine transitions based on the current state and the request inputs. The priority is determined by the current state:

- From IDLE: priority order is 0 → 1 → 2 → 3
- From S_0: priority order is 1 → 2 → 3 → 0
- From S_1: priority order is 2 → 3 → 0 → 1
- From S_2: priority order is 3 → 0 → 1 → 2
- From S_3: priority order is 0 → 1 → 2 → 3

This ensures that after servicing a request, the next highest priority is given to the next requester in sequence, implementing fair arbitration.

### Output Logic
The output grant signal corresponds directly to the current state:
- S_0: grant = 4'b0001 (grant to requester 0)
- S_1: grant = 4'b0010 (grant to requester 1)
- S_2: grant = 4'b0100 (grant to requester 2)
- S_3: grant = 4'b1000 (grant to requester 3)
- IDLE: grant = 4'b0000 (no grants)

  ### RTL Diagram
  ![image](https://github.com/user-attachments/assets/5592bb57-1a53-4c4b-a3ba-0676e65f75b0)


## Testbench
The repository includes a comprehensive testbench (`test3_tb`) that verifies the arbiter's behavior across all possible request combinations:

- Case 0: No requests (4'b0000)
- Cases 1-15: All possible combinations of requests
  
### Simulation Results

![1](https://github.com/user-attachments/assets/95eda6ab-dc09-4c5a-98c7-ecdabb914be5)
![2](https://github.com/user-attachments/assets/54085d65-8e84-46a0-a1e8-ba6009d1e1f3)
![3](https://github.com/user-attachments/assets/7143fe2a-a21d-41e5-85b8-16f2be13a621)
![4](https://github.com/user-attachments/assets/a31e1594-992d-4483-a5fd-ca227f300194)

The testbench uses a systematic approach to verify:
- Proper priority enforcement
- Correct round-robin behavior
- Reset functionality
- Transition to IDLE when no requests are present

## Applications
This round-robin arbiter can be used in various applications such as:
- Memory controllers
- Bus arbitration
- Network packet scheduling
- Resource allocation in multi-processor systems
