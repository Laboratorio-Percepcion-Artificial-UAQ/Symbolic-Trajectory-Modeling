# Symbolic Trajectory Modeling

MATLAB implementation of a symbolic trajectory modeling framework for surveillance scenarios, including grammar induction and an information-sufficiency criterion for motion pattern learning.

## Table of contents

- [Description](#description)
- [Data availability](#data-availability)
- [Repository structure](#repository-structure)
- [Requirements](#requirements)
- [Usage](#usage)
<!--
--- [Reproducing the experiments](#reproducing-the-experiments)
--- [Relation to the preprint](#relation-to-the-preprint)
--- [How to cite](#how-to-cite)
--- [License](#license)
--- [Contact](#contact)
-->
---

## Description

This repository contains the source code associated with the experimental reproducibility of the article:

**H. Hernandez-Ramirez, J. L. Perez-Ramos, D. Canton-Enriquez, A. M. Herrera-Navarro, H. Jimenez-Hernandez**  
**“How Much to Learn? An Information-Sufficiency Criterion for Detecting Motion Rules in Scenario Surveillance”**  
Preprints 2025, 202510.0359  
DOI: [10.20944/preprints202510.0359.v1](https://doi.org/10.20944/preprints202510.0359.v1)

The repository implements a symbolic, state-based representation of motion trajectories in video surveillance scenarios. Its main purpose is to support the construction of symbolic motion sequences, the inference of grammar-based motion rules, and the evaluation of a sufficiency criterion that determines when the observed motion patterns have been learned with adequate structural stability.

## Data availability

The datasets associated with this repository are publicly available in Mendeley Data:

**Reproducibility Data for “A Grammar-Based Criterion for Learning Sufficiency in Motion Modeling”**  
DOI: [10.17632/r95xbg36vb.2](https://doi.org/10.17632/r95xbg36vb.2)

The dataset includes the video material corresponding to Scenario E1, authorized for redistribution by the authors, as well as the derived artifacts required to reproduce Scenario E4 based on the VIRAT benchmark. The original VIRAT videos are not redistributed and should be obtained from the official VIRAT source.

## Repository structure

The main files currently included in this repository are:

- `main_scenario1.m`  
  Main execution script for the experiment associated with Scenario 1.

- `main_scenario4.m`  
  Main execution script for the experiment associated with Scenario 4.

- `OriSeqV1.m`  
  Functions related to sequence preparation and symbolic trajectory processing.

- `Watershed.m`  
  Functions for spatial partitioning and state generation in the scene.

- `connectivity.m`  
  Utilities for validating spatial and sequential connectivity between states.

- `convertPathsToSymbols.m`  
  Functions for transforming motion paths into symbolic sequences.

- `decode_rules.m`  
  Utilities for decoding and formatting the inferred grammar rules.

- `removeDuplicateRules.m`  
  Functions for postprocessing and removing redundant rules.

- `LICENSE`  
  MIT license for the source code.

## Requirements

The code was developed in MATLAB and may require standard functionality for:

- video reading,
- matrix and sequence processing,
- image-based scene partitioning,
- symbolic rule manipulation.

Depending on the local configuration and extensions to the experiments, the following MATLAB toolboxes may be useful:

- Image Processing Toolbox
- Statistics and Machine Learning Toolbox

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/Laboratorio-Percepcion-Artificial-UAQ/Symbolic-Trajectory-Modeling.git
   cd Symbolic-Trajectory-Modeling
