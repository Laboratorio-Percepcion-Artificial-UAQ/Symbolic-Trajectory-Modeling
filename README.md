# Symbolic Trajectory Modeling

MATLAB implementation of a symbolic trajectory modeling framework for surveillance scenarios, including grammar induction and an information-sufficiency criterion for motion pattern learning.

## Table of contents

- [Description](#description)
- [Data availability](#data-availability)
- [Supplementary material](#supplementary-material)
- [Methodological scope](#methodological-scope)
- [Supported scenarios](#supported-scenarios)
- [Repository structure](#repository-structure)
- [Requirements](#requirements)
- [Usage](#usage)
- [Reproducing the experiments](#reproducing-the-experiments)
- [How to cite](#how-to-cite)
- [License](#license)
- [Contact](#contact)

---

## Description

This repository contains the source code associated with the experimental reproducibility of the article:

**H. Hernandez-Ramirez, J. L. Perez-Ramos, D. Canton-Enriquez, A. M. Herrera-Navarro, H. Jimenez-Hernandez**  
**“How Much to Learn? An Information-Sufficiency Criterion for Detecting Motion Rules in Scenario Surveillance”**  
Preprints 2025, 202510.0359  
DOI: [10.20944/preprints202510.0359.v1](https://doi.org/10.20944/preprints202510.0359.v1)

The repository implements a symbolic, state-based representation of motion trajectories in video surveillance scenarios. Its main purpose is to support the construction of symbolic motion sequences, the inference of grammar-based motion rules, and the evaluation of an information-sufficiency criterion that determines when the observed motion patterns have been learned with adequate structural stability.

## Data availability

The datasets associated with this repository are publicly available in Mendeley Data:

**Reproducibility Data for “A Grammar-Based Criterion for Learning Sufficiency in Motion Modeling”**  
DOI: [10.17632/r95xbg36vb.2](https://doi.org/10.17632/r95xbg36vb.2)

The dataset includes the video material corresponding to Scenario E1, authorized for redistribution by the authors, as well as the derived artifacts required to reproduce Scenario E4 based on the VIRAT benchmark. The original VIRAT videos are not redistributed and should be obtained from the official VIRAT source.

## Supplementary material

Additional supplementary material supporting the experiments reported in this repository is included in the supplementary document associated with the study.

This material contains:

- **Table S1**: motion-processing parameters used in the experimental setup for **Scenarios E1 and E4**.
- **Table S2**: grammar-learning parameters used in the experimental setup for **Scenario E1**.

The supplementary material is intended to provide a clearer description of the methodological parameterization used during preprocessing, motion extraction, symbolic trajectory construction, and grammar-learning stages.

If distributed within this repository, the supplementary file should be placed in a dedicated directory such as:

supplementary_material/
└── Supplementary_Materials_Parameters.pdf

## Methodological scope

This repository supports the reproducibility of a symbolic motion modeling pipeline based on the following stages:

- spatial partitioning of the scene into states,
- trajectory-to-symbol conversion,
- symbolic sequence construction,
- grammar induction from symbolic motion patterns,
- postprocessing of inferred rules,
- evaluation of the information-sufficiency criterion.

The implementation is intended for controlled experimental reproduction of the scenarios described in the associated article.

## Supported scenarios

The repository currently includes executable scripts for the following scenarios:

- **Scenario E1**  
  Reproduced through `main_scenario1.m` using the corresponding video material provided in the associated Mendeley Data repository.

- **Scenario E4**  
  Reproduced through `main_scenario4.m` using the derived artifacts associated with the VIRAT-based experimental setting.

## Repository structure

The main files currently included in this repository are:

- `main_scenario1.m`  
  Main execution script for the experiment associated with Scenario E1.

- `main_scenario4.m`  
  Main execution script for the experiment associated with Scenario E4.

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

Depending on the local configuration and possible extensions of the experiments, the following MATLAB toolboxes may be useful:

- Image Processing Toolbox
- Statistics and Machine Learning Toolbox

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/Laboratorio-Percepcion-Artificial-UAQ/Symbolic-Trajectory-Modeling.git
   cd Symbolic-Trajectory-Modeling

2. Download the associated dataset from Mendeley Data:

DOI: [10.17632/r95xbg36vb.2](https://doi.org/10.17632/r95xbg36vb.2)

3. Place the required video files or derived artifacts in the appropriate local directory according to the selected scenario.

4. Open the repository in MATLAB.
 
5. Run the script corresponding to the desired experiment: main_scenario1.m or main_scenario4

## Reproducing the experiments

The experiments reported in this repository can be reproduced by combining the source code hosted here with the dataset deposited in Mendeley Data.

To reproduce the experiments:

1. Clone this repository.
2. Download the associated dataset from Mendeley Data.
3. Place the required video files or derived artifacts in the appropriate local directory according to the scenario to be executed.
4. Open the repository in MATLAB.
5. Select the script corresponding to the experiment of interest:
     * main_scenario1.m for Scenario E1
     * main_scenario4.m for Scenario E4
6. Verify that the input filename and local path specified in the selected script match the downloaded dataset files.
7. Run the selected script from the MATLAB command window.

The outputs generated by the scripts allow the user to reproduce the symbolic trajectory modeling process, including state-based motion representation, symbolic sequence generation, grammar induction, and the evaluation of the information-sufficiency criterion.

## How to cite

If you use this repository in academic work, please cite both the associated article and the dataset.

**Article citation**
@article{hernandezramirez2025informationsufficiency,
  author  = {Hernandez-Ramirez, H. and Perez-Ramos, J. L. and Canton-Enriquez, D. and Herrera-Navarro, A. M. and Jimenez-Hernandez, H.},
  title   = {How Much to Learn? An Information-Sufficiency Criterion for Detecting Motion Rules in Scenario Surveillance},
  journal = {Preprints},
  year    = {2025},
  volume  = {2025},
  pages   = {202510.0359},
  doi     = {10.20944/preprints202510.0359.v1}
}

**Dataset citation**
@dataset{hernandezramirez2026motionmodelingdata,
  author    = {Hernandez-Ramirez, Herlindo and Perez-Ramos, Jorge Luis and Canton-Enriquez, Daniel and Herrera-Navarro, Ana Marcela and Jimenez-Hernandez, Hugo},
  title     = {Reproducibility Data for ``A Grammar-Based Criterion for Learning Sufficiency in Motion Modeling''},
  year      = {2026},
  version   = {2},
  publisher = {Mendeley Data},
  doi       = {10.17632/r95xbg36vb.2}
}

## License

This repository is distributed under the terms of the MIT License. See the LICENSE file for further details.

## Contact

For questions, comments, or reports related to this repository, please use the GitHub issue tracker.

For academic inquiries related to the associated article, please refer to the author information provided in the preprint.
