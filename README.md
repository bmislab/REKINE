# REKINE
[![GitHub issues](https://img.shields.io/github/issues/sccn/bmsilab?color=%23fa251e&logo=GitHub)](https://github.com/bmislab/REKINE/issues)
![Twitter Follow](https://img.shields.io/twitter/follow/BMISLab?style=social)

# What is bmislab?
The Brain-Machine Interface Systems Lab (BMISLAB) is a team of researchers led by José María Azorín. Our work focuses on human-machine interaction through brain control in order to improve human capabilities in neural rehabilitation.
This repository is an open source signal processing environment for electroencephalography (EEG) signals running on Matlab. This folder contains original Matlab functions from the BMISLAB that have been adapted to the context of the EUROBENCH project, REKINE.

# Installing/cloning
**Recommended:** Download both dataset (enlace) and code (enlace) as a separated zips and open them in the same folder.
```
code analysis --  https://github.com/bmislab/REKINE/tree/main/Code
dataset -- 
```

# Sub-directories:

 - /code - All distributed REKINE functions (new_preprocesar_standarized, select_files, load_session, multi_linear_regression, plot_decoded_trajectories)
 - /EEG_dataset   - Directory to place all the recorded data of the REKINE project experiments

# To use REKINE code: 

1. Start Matlab

2. Use Matlab to navigate to the folder containing the codes.

3. Type "[C_corr_out,X_dec_out]=new_preprocesar_standarized(G,L,N,filter_freq,resampling,show_flag)" at the Matlab command prompt ">>", fill the input parameters as desired, but following the requirements stated in the function and press enter.

4. When the explorer oppens, select all the CSV files corresponging to the desired trials for one speficic subject.

5. The results of the code will be always shown in the command window

6. Please send feedback and suggestions to: eianez@umh.es

# In publications, please reference:

J.V. Juan, L. de la Ossa, E. Iáñez, M. Ortiz, L. Ferrero and J.M. Azorín (2022). Decoding Lower-Limbs Kinematics from EEG Signals while Walking with an Exoskeleton. Artificial Intelligence in Neuroscience: Affective Analysis and Health Applications. IWINAC 2022. Lecture Notes in Computer Science, vol. 13258, pp. 615-624. Springer, Cham. https://doi.org/10.1007/978-3-031-06242-1_61.
 
# Documentation:

