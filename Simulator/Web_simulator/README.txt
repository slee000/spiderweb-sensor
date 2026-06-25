>> Web_simulator:
"Web_simulator" folder contains the source code for the web simulation and structural optimization presented in the paper.

>> mesh_import.m: is the main code behind running the web simulation. The code describes the main simulation and geometrical parameters of the web as well as different studies. The code contains the description of the main web geometrical and simulation variables as comments in front of the variables. The code can generate and animate exestuation of G-code for 3D printing the webs by calling "line2gcode.m", call "SOFA_export.m" to generate SOFA scene, call SOFA simulator to run the scene, extract the data, and run the LSTM training and testing. The output is the classification study accuracy, G-code for 3D printing the web, and various plots, animations, and figures showing the intermediate results, raw readout data, and web geometries. The current parameters run a 17-point classification task on biological web 1 with pertubed excitation location in the range od one index (i.e adjust nodes) and two levels of damage, with 50 and 100 randomly selected damaged lines while plotting and reporting intermediate results including generation and visualisation of g-code for 3D printignt eh web.

>> sensitivity.m: code to run the sensitivity analysis. Default values were perturbed manually as explained in the paper and the results including the classification accuracy of five trials with randomly selected damaged lines were recorded in the "results_sensitivity.m" file in the "Results" folder for post processing. The code runs simulation with default parameters, which are based on the symmetric version of biological web 1 with free zone features, and return the accuracy achieved for a 17-point classification task for the diffentr trials as a vector.

>> web_optimiation_analysis.m: runs different optimization scenarios presented in the paper by calling "random_web.m" and "mesh_import.m". The file contains various parameters to select the type of study and post processing that users should be able to figure out their functionalities by following the comments in the code. A complete explanation of the paramters under "simulation par.s" section is provided in the "mesh_import.m" file. The current settings will run a 5 DoF optimization based on a seed web geometry with free zone features and predefined damage locations using Genetic Algorithm. The final optimization output will be tested with random damage locations. By setting " opt_type = 'ga'" and "sample_results" to a number between 1 to 5 (see comments in the code), a simulation based on random damage locations will run for the selected optimization result as reported in the paper. The code reports the mean value for classification accuracy of the web geometry and plots for the web geometry, excitation and readout locations, and raw readout signal data.

>> random_web.m: generates random geometries of the webs for optimisation. The code also runs stand alone and generates a random web geometry and plots the web.

>> SOFA_export.m: generates "*.xml" SOFA scenes based on the program input for the web geometry, excitation and and readout points, damaged lines, etc. The code does not run standalone.

>> "line2gcode.m": polishes and fixes the web geometries, generates g-code, and animates the 3D printing path of the web. The code does not run stand alone.

>> "igesToolBox_edited" Folder: contains necessary 3D party codes for analysing wire frame geometries similar to a spider web in our simulations.

>> "CAD source" folder: contains source files for spider web line and node coordinates.

>> Other dependencies: are code files with specific implementation of a function, i.e. "LSTM_fun.m" that runs the LSTM code, "pmat.m", "normV.m", "pext.m" with specific arithmetic function implementations. Running the above code also generate temporary supporting files that can be extracted for further anlysis or otherwise will be overridden upon the codes fresh run. These files include the SOFA simulation scene as "matlab_sofa.xml", the 3D printing coordinates "*.mat" and G-code "*.gcode" files, etc.

>> General notes:
- The optimization process may take hours to finish. The progress can be traced based on the optimization fundtion plots of mean vs. best fir value and current best set of parameters.
- Unexpected termination of SOFA simulation results in malfunction of SOFA in future runs returning non-oscilating readout signals. In such cases, Matlab should be restarted after closing all dependant processess terminated (chexk Windows Task Manager) to resolve this issue.

