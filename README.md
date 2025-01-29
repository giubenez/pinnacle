# PINNACLE Scripts

A couple of scripts I wrote for Pinnacle 16.2

## Pigna
A tool to automate our workflow for our planning routine

![image](https://github.com/user-attachments/assets/c2ca15a2-3456-49b9-a956-58a45aff7da7)

1) Select the Machine, Energy (from the one available in your institution) and CT-DensityTable (customize the list in the script code).
2) Select the external contour, if not present start an autocontour (change the autocontour template basing on your habbits). Rename the ROIs with similar names (E.g. ptv 60, ptv60, ptv 6000 to PTV6000)
3) We use the TUMOR lock. Therefore we have a POI corresponding to the ISOCT. Secet it, check values, lock, rename, set laser localization.
4) Add a couch template and convert it. Set red line below the chouch (it exports the ROI and uses a bash script to find the position for the red line)
5) Select the correct protocol. To load the protocols of your insitution click reload. Protocols targets should be named as described in the next point
6) Fit Names: it's used to show the protocol targets and to rename the plan ROIs accordingly. PTVs should start with PTV, it's ring should start with ring, OAR_p indicates OAR-(PTV+ring). Indeed without the autoplanning feature it's not possible to associate the ROIs of the plan to the ones of the themplate.
![image](https://github.com/user-attachments/assets/616d0d97-0403-4703-8161-fbb2422e3f8c)
The red arrow can rename the OAR selected on the left with the corresponding protocol name on the right.
The bottom part of the window is used to create auxiliary ROIs: once selected a ROI, "ring" button create a ring with the selected paddings (in-out plane or constant), UP create a ROI in the upper part, Down a roi in the bottom.
The "_p" blue button create a ROI_p which is the selected ROI - (the ROIs flagged in the first column ("_p?")). The subtraction considers the ROIs selected in the menu and not the names in the protocol.
External_p is automatically renamed to surround
8) Select the isocenter for the arcs. If you want to create a new isocenter, press "Create POI" and "Autoplace". Round 1cm simply round the shifts to 1 cm (round position(ISOCENTER-ISOCT))
9) Create two arcs with the properties of point (1)
10) Insert the prescriptions and set prescriptions and isodoses
11) Remove the padding, draw the grid (2 click necessar), select the correct grid resolution and load the template.


## ChangeMachine

A script to change the machine of all the beams in a plan without editing anything other. 
Since changing the machine of an arc might change the MLC positions resulting in a non-deliverable plan, this script can be used to swap among geometrically equivalent machines.

PLEASE NOTE THAT using this script to change to a non equivalent machine might result in a non deliverable plan.


## SumTrials

To sum up to 4 trials by copying the beams and prescriptions.
![image](https://github.com/user-attachments/assets/ff42630e-f7ee-4531-b866-285ab4519fda)



## FindMyPatient
With this script it is possible to find archived patients and archived physics.

### FindMyPatient.sh
This is not a pinnacle script but a shell script I wrote to create a database of the patients and of the physics inside the Archive directory. 
1) First of all, edit the variables at the beginning of findMyPatient.sh file with the correct Archive path.
2) Build the database by launching the script and pressing 3. The script roam around the archive and scann all the tar files looking for patients and physics.
3)  When the database is complete, you can seach patients or physics (launch the script and select 1 or 2). Enlarge the window for a better visualization
   
![image](https://github.com/user-attachments/assets/72d7c70b-da84-4732-9461-eb3ad1c9d62c)

### checkInstitution.sh

Use this script to verify if all the patients contained in the archived/backupped institution are contained inside the tars of a folder.
1) Copy and paste the script inside the folder containing all the *.tar of a backupped institution
2) Launch the script and press 1
3) Launch anodther time the script and press 2 (without closing the other instance)
4) Whan both the scripts finish, press 3 in one of them. Close the other

![image](https://github.com/user-attachments/assets/2c356fde-a078-4d55-ba84-cc94a7c9089e)










