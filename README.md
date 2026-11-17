# Foundry DAO Project 2026

A Decentralized Autonomous Organization (DAO) built with Solidity and Foundry, implementing an on-chain governance system that allows token holders to participate in decentralized decision-making.

The project demonstrates how decentralized governance works through proposal creation, token-based voting, vote delegation, and execution of approved proposals using a Timelock Controller.

## Overview

The DAO allows eligible token holders to propose changes, vote on proposals, and execute decisions once they receive sufficient community support.

It uses OpenZeppelin's Governor framework to manage the proposal lifecycle and a Timelock Controller to introduce a mandatory delay before approved proposals are executed.

## Features

- **Governance Token:** ERC20-based voting token using OpenZeppelin's ERC20Votes.
- **Vote Delegation:** Token holders can delegate their voting power.
- **Proposal Creation:** Eligible participants can submit proposals.
- **On-chain Voting:** Token holders can vote For, Against, or Abstain.
- **Voting Delay:** A configurable waiting period before voting begins.
- **Voting Period:** A defined period during which participants can vote.
- **Proposal Queuing:** Successful proposals can be queued through the Timelock Controller.
- **Timelock Execution:** Approved proposals are executed after the configured delay.

## Governance Workflow

The governance process follows these stages:

1. **Proposal Creation** – An eligible token holder submits a proposal.
2. **Pending** – The proposal waits for the voting delay to pass.
3. **Active** – Token holders can cast their votes.
4. **Succeeded** – The proposal receives sufficient support.
5. **Queued** – The proposal is scheduled through the Timelock Controller.
6. **Executed** – The proposal is executed after the timelock delay.

## Tech Stack

- Solidity
- Foundry
- OpenZeppelin Contracts
- ERC20Votes
- Governor
- TimelockController

## Project Structure

```text
foundry-doa-project/
├── .github/
├── src/
│   ├── GovToken.sol
│   ├── MyGovernor.sol
│   └── Box.sol
├── test/
│   └── MyGovernorTest.t.sol
├── .gitignore
├── foundry.toml
├── foundry.lock
└── README.md
```

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)

### Installation

Clone the repository:

```bash
git clone https://github.com/therealWiliiam/Foundry-DOA-Project-2026.git
```

Navigate into the project:

```bash
cd Foundry-DOA-Project-2026
```

Install dependencies:

```bash
forge install
```

### Build

Compile the smart contracts:

```bash
forge build
```

### Run Tests

Execute the test suite:

```bash
forge test
```

For detailed execution traces:

```bash
forge test -vvvv
```

## Learning Objectives

This project explores:

- Decentralized governance architecture.
- ERC20 voting power and delegation.
- OpenZeppelin Governor implementation.
- Proposal lifecycle management.
- Timelock security mechanisms.
- Smart contract testing with Foundry.

## Author

**Bill Henry-Nkeki**

GitHub: [@therealWiliiam](https://github.com/therealWiliiam)

---

*This project was developed for educational purposes to demonstrate the implementation of decentralized governance using Solidity, Foundry, and OpenZeppelin.*
