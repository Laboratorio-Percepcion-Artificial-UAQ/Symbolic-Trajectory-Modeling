# Symbolic Trajectory Modeling

MATLAB implementation of the symbolic, state-based trajectory model and the **information-sufficiency criterion** introduced in:

> H. Hernandez-Ramirez, J. L. Perez-Ramos, D. Canton-Enriquez, A. M. Herrera-Navarro, H. Jimenez-Hernandez  
> **“How Much to Learn? An Information-Sufficiency Criterion for Detecting Motion Rules in Scenario Surveillance”**, Preprints 2025, 202510.0359.  
> DOI: [10.20944/preprints202510.0359.v1](https://doi.org/10.20944/preprints202510.0359.v1)

This repository contains the core code used to **symbolically represent motion trajectories** in video surveillance scenarios and to **detect when the learned motion grammar has reached a stable, information-sufficient state**.

---

## Table of contents

- [Overview](#overview)
- [Repository structure](#repository-structure)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Reproducing the experiments](#reproducing-the-experiments)
- [Relation to the preprint](#relation-to-the-preprint)
- [How to cite](#how-to-cite)
- [License](#license)
- [Contact](#contact)
- [Resumen en español](#resumen-en-español)

---

## Overview

The goal of this codebase is to:

1. **Segment the camera field of view into states** with high probability of motion.
2. **Encode motion as symbolic trajectories** by assigning each active state to a symbol.
3. **Infer a right-linear grammar** from the sequence of motion symbols using a SEQUITUR-like approach.
4. **Compute an information-sufficiency criterion** that indicates when the learned grammar has stabilized and captures the dominant motion dynamics in the scenario.

The same pipeline is used in the preprint to model real surveillance scenarios, including traffic flows in Querétaro City.

---

## Repository structure

Main files in this repository:

- `main.m`  
  Entry script for running the symbolic trajectory modeling pipeline on a given video or precomputed trajectories.  
  This script orchestrates:
  - state generation and connectivity checks,  
  - conversion of paths to symbolic sequences,  
  - grammar inference and rule post-processing,  
  - computation of the sufficiency / stability criterion.

- `OriSeqV1.m`  
  Utilities for handling original sequences of motion states (e.g., loading or preparing state trajectories from a scenario).

- `Watershed.m`  
  Functions related to **spatial partitioning / state definition**, typically using watershed-based segmentation on the image plane to obtain connected motion regions.

- `connectivity.m`  
  Functions to ensure **connectivity of states and paths**, and to validate that trajectories move through adjacent, connected states only.

- `convertPathsToSymbols.m`  
  Conversion from **state trajectories → symbolic sequences**. Each valid state is mapped to a unique symbol in the alphabet.

- `decode_rules.m`  
  Decoding and formatting of inferred grammar rules into a human-readable representation (e.g., for inspection and plotting of learned motion structures).

- `removeDuplicateRules.m`  
  Post-processing of grammar rules to remove redundant or duplicate rules before evaluating the sufficiency criterion.

- `Entry video link.txt`  
  Text file with a link to the **reference surveillance video** used in the experiments.  
  Download the video from this link if you want to reproduce the original scenarios.

- `LICENSE`  
  MIT license for this code.

> **Note:** Some internal details (variable names, parameters) are documented in the comments at the top of each `.m` file.

---

## Requirements

- **MATLAB** (recent version; scripts were developed in modern MATLAB releases).  
- Recommended toolboxes:
  - **Image Processing Toolbox** (for segmentation, watershed, etc.).
  - **Statistics and Machine Learning Toolbox** (if you extend the analysis with additional statistical tools).

Other versions / configurations of MATLAB may work but have not been systematically tested.

---

## Getting started

1. **Clone this repository**

   ```bash
   git clone https://github.com/Laboratorio-Percepcion-Artificial-UAQ/Symbolic-Trajectory-Modeling.git
   cd Symbolic-Trajectory-Modeling
