*Project: IRDR Dataset
*Stata v.16.0
*Bianca Guillermo

*does
	*clean dataset
	*produce two-way tables for insects and diseases found in replacement varieties per season
	*create dummy variables for insects and diseases (1-Yes, 0-No)

*to do
	*fix problem where insects were put under the disease category and vice versa
	*finalize expected output

* **********************************************************************
* 0 - SETUP 
* **********************************************************************

*Clear data
	clear all

*Define directory
	global root = "C:\Users\Bianca Guillermo\git\04_syntax\EBGuillermo\raw"
	global output = "C:\Users\Bianca Guillermo\git\04_syntax\EBGuillermo\refined"
	
* ***********************************************************************
* 1 - PREPARING DATA
* ***********************************************************************

*Import raw data
	import excel "$root\IRDR.xlsx", sheet("Sheet1") firstrow

*Create draft version of data
	save "$output\0_IRDR_draft", replace
	
* ***********************************************************************
* 2 - DATA CLEANING
* ***********************************************************************

*Keep variables of interest
	keep session hh hhid PreyVeng Date Morning Market Climate repvar_jw repvar_jd DR_jw IR_jw DR_jd IR_jd

*Convert variable names to lower cases
	rename 	_all, lower

*Put delimiter in multiple responses
	replace ir_jd = "BROWN PLANTHOPPER, GOLDEN APPLE SNAIL, STEM BORER, LEAF FOLDER" if ir_jd == "BROWN PLANTHOPPER, GOLDEN APPLE SNAIL STEM BORER LEAF FOLDER" /*obs 70*/
	replace ir_jd = "STEM BORER, BROWN PLANTHOPPER, LEAF FOLDER, RICE BUG" if ir_jd == "STEM BORER, BROWN PLANTHOPPER, LEAF FOLDERM RICE BUG" /*obs 109*/
		
*Split multiple responses in one cell
	split dr_jw, p(, .)
	split ir_jw, p(, .)
	split dr_jd, p(, .)
	split ir_jd, p(, .)
	
*Remove leading and traling spaces in IRDR variables
	replace dr_jw1 = trim(dr_jw1)
	replace dr_jw2 = trim(dr_jw2)
	replace dr_jw3 = trim(dr_jw3)
	replace dr_jw4 = trim(dr_jw4)
	replace ir_jw1 = trim(ir_jw1)
	replace ir_jw2 = trim(ir_jw2)
	replace ir_jw3 = trim(ir_jw3)
	replace ir_jw4 = trim(ir_jw4)
	replace ir_jw5 = trim(ir_jw5)
	replace ir_jw6 = trim(ir_jw6)
	replace dr_jd1 = trim(dr_jd1)
	replace dr_jd2 = trim(dr_jd2)
	replace dr_jd3 = trim(dr_jd3)
	replace dr_jd4 = trim(dr_jd4)
	replace ir_jd1 = trim(ir_jd1)
	replace ir_jd2 = trim(ir_jd2)
	replace ir_jd3 = trim(ir_jd3)
	replace ir_jd4 = trim(ir_jd4)
	replace ir_jd5 = trim(ir_jd5)
	replace ir_jd6 = trim(ir_jd6)
	
*Transpose from wide to long
	drop dr_jw- ir_jd
	reshape long dr_jw ir_jw dr_jd ir_jd, i(hhid) j(number) string
		
*Clean IR and DR data contents
	replace ir_jw = "PLANTHOPPER" if ir_jw == "BROWN PLATNHOPPER"
	replace ir_jw = "PLANTHOPPER" if ir_jw == "BROWN PLANTHOPPER"
	replace ir_jw = "PLANTHOPPER" if ir_jw == "PLANTHPPER"
	replace ir_jw = "ARMYWORM" if ir_jw == "ARMY WORM"
	replace ir_jw = "LEAF FOLDER" if ir_jw == "LEAF FODLER"
	replace ir_jw = "THRIPS" if ir_jw == "RICE THRIP"
	replace ir_jw = "THRIPS" if ir_jw == "THIRP"
	replace ir_jw = "STEM BORER" if ir_jw == "STEMBORER"
	
	replace ir_jd = "ARMYWORM" if ir_jd == "ARMY WORM"
	replace ir_jd = "PLANTHOPPER" if ir_jd == "BROWN PLANTHOPPER"
	replace ir_jd = "PLANTHOPPER" if ir_jd == "BROWN PLATNHOPPER"
	replace ir_jd = "CASEWORM" if ir_jd == "CASE WORM"
	replace ir_jd = "LEAF FOLDER" if ir_jd == "LEAF FODLER"
	replace ir_jd = "THRIPS" if ir_jd == "RICE THRIP"
	replace ir_jd = "THRIPS" if ir_jd == "THRIP"
	replace ir_jd = "THRIPS" if ir_jd == "THRIPS"
	replace ir_jd = "BACTERIAL BLIGHT" if ir_jd == "BACTERIAL LEAF BLIGHT"
	
	replace dr_jw= "BACTERIAL BLIGHT" if dr_jw== "BACTERIAL LEAF BLIGHT"
	replace dr_jw= "NECK BLAST" if dr_jw== "LEAF BLIGHT"
	replace dr_jw= "NECK BLAST" if dr_jw== "NECK BLST"
	replace dr_jw= "NECK BLAST" if dr_jw== "NECK BNLAST"
	replace dr_jw= "BLAST" if dr_jw== "RICE BLAST"
	replace dr_jw= "BLAST" if dr_jw== "RUICE BLAST"
	replace dr_jw= "SHEATH BLIGHT" if dr_jw== "SEHAT BLIGHT"
	replace dr_jw= "SHEATH BLIGHT" if dr_jw== "SHEATH BLGIHT"
	replace dr_jw= "PLANTHOPPER" if dr_jw== "BROWN PLANTHOPPER"
	
	replace dr_jd= "BACTERIAL BLIGHT" if dr_jd== "BACTERIAL LEAF BLIGHT"
	replace dr_jd= "BACTERIAL BLIGHT" if dr_jd== "LEAF BLIGHT"
	replace dr_jd= "BLAST" if dr_jd== "BLAST RICE"
	replace dr_jd= "BLAST" if dr_jd== "RICE BLAST"
	replace dr_jd= "BLAST" if dr_jd== "RICE BLAT"
	replace dr_jd= "BLAST" if dr_jd== "TICE BLAST"
	replace dr_jd= "NECK BLAST" if dr_jd== "NECK B LAST"
	replace dr_jd= "SHEATH BLIGHT" if dr_jd== "SHEAT BLIGHT"
	replace dr_jd= "SHEATH BLIGHT" if dr_jd== "SHEATH BLAST"
	replace dr_jd= "TUNGRO" if dr_jd== "TUNGOR"
	replace dr_jd= "PLANTHOPPER" if dr_jd== "BROWN PLANTHOPPER"
	replace dr_jd= "THRIPS" if dr_jd== "THIRP"

* **********************************************************************
* 3 -	DUMMY VARIABLES FOR INSECTS AND DISEASES
* **********************************************************************
	
*Wet season
	gen AW_jw = 1 if ir_jw == "ARMYWORM" | dr_jw == "ARMYWORM"
	gen BBLIGHT_jw = 1 if ir_jw == "BACTERIAL BLIGHT" | dr_jw == "BACTERIAL BLIGHT"
	gen Blast_jw = 1 if ir_jw == "BLAST" | dr_jw == "BLAST"
	gen CW_jw = 1 if ir_jw == "CASEWORM" | dr_jw == "CASEWORM"
	gen Check_jw = 1 if ir_jw == "CHECK" | dr_jw == "CHECK"
	gen Drought_jw = 1 if ir_jw == "DROUGHT" | dr_jw == "DROUGHT"
	gen GM_jw = 1 if ir_jw == "GALL MIDGE" | dr_jw == "GALL MIDGE"
	gen GAS_jw = 1 if ir_jw == "GOLDEN APPLE SNAIL" | dr_jw == "GOLDEN APPLE SNAIL"
	gen LF_jw = 1 if ir_jw == "LEAF FOLDER" | dr_jw == "LEAF FOLDER"
	gen PH_jw = 1 if ir_jw == "PLANTHOPPER" | dr_jw == "PLANTHOPPER"
	gen Rat_jw = 1 if ir_jw == "RAT" | dr_jw == "RAT"
	gen RB_jw = 1 if ir_jw == "RICE BLAST" | dr_jw == "RICE BLAST"
	gen RBug_jw = 1 if ir_jw == "RICE BUG" | dr_jw == "RICE BUG"
	gen Rodent_jw = 1 if ir_jw == "RODENT" | dr_jw == "RODENT"
	gen SR_jw = 1 if ir_jw == "SHEATH ROT" | dr_jw == "SHEATH ROT"
	gen SHGH_jw = 1 if ir_jw == "SHORT-HORNED GRASSHOPPER" | dr_jw == "SHORT-HORNED GRASSHOPPER"
	gen SB_jw = 1 if ir_jw == "STEM BORER" | dr_jw == "STEM BORER"
	gen SM_jw = 1 if ir_jw == "SUBMERGENCE" | dr_jw == "SUBMERGENCE"
	gen Thrips_jw = 1 if ir_jw == "THRIPS" | dr_jw == "THRIPS"
	gen BLS_jw = 1 if ir_jw == "BACTERIAL LEAF STREAK" | dr_jw == "BACTERIAL LEAF STREAK"
	gen BS_jw = 1 if ir_jw == "BROWN SPOT" | dr_jw == "BROWN SPOT"
	gen GS_jw = 1 if ir_jw == "GRASSY STOUT" | dr_jw == "GRASSY STOUT"
	gen NB_jw = 1 if ir_jw == "NECK BLAST" | dr_jw == "NECK BLAST"
	gen RS_jw = 1 if ir_jw == "RAGGED STUNT" | dr_jw == "RAGGED STUNT"
	gen SBLIGHT_jw = 1 if ir_jw == "SHEATH BLIGHT" | dr_jw == "SHEATH BLIGHT"
	gen SP_jw = 1 if ir_jw == "SHEATH PANICLE" | dr_jw == "SHEATH PANICLE"
	gen Tungro_jw = 1 if ir_jw == "TUNGRO" | dr_jw == "TUNGRO"
		
	replace AW_jw = 0 if ir_jw != "ARMYWORM" | dr_jw != "ARMYWORM"
	replace BBLIGHT_jw = 0 if ir_jw != "BACTERIAL BLIGHT" | dr_jw != "BACTERIAL BLIGHT"
	replace Blast_jw = 0 if ir_jw != "BLAST" | dr_jw != "BLAST"
	replace CW_jw = 0 if ir_jw != "CASEWORM" | dr_jw != "CASEWORM"
	replace Check_jw = 0 if ir_jw != "CHECK" | dr_jw != "CHECK"
	replace Drought_jw = 0 if ir_jw != "DROUGHT" | dr_jw != "DROUGHT"
	replace GM_jw = 0 if ir_jw != "GALL MIDGE" | dr_jw != "GALL MIDGE"
	replace GAS_jw = 0 if ir_jw != "GOLDEN APPLE SNAIL" | dr_jw != "GOLDEN APPLE SNAIL"
	replace LF_jw = 0 if ir_jw != "LEAF FOLDER" | dr_jw != "LEAF FOLDER"
	replace PH_jw = 0 if ir_jw != "PLANTHOPPER" | dr_jw != "PLANTHOPPER"
	replace Rat_jw = 0 if ir_jw != "RAT" | dr_jw != "RAT"
	replace RB_jw = 0 if ir_jw != "RICE BLAST" | dr_jw != "RICE BLAST"
	replace RBug_jw = 0 if ir_jw != "RICE BUG" | dr_jw != "RICE BUG"
	replace Rodent_jw = 0 if ir_jw != "RODENT" | dr_jw != "RODENT"
	replace SR_jw = 0 if ir_jw != "SHEATH ROT" | dr_jw != "SHEATH ROT"
	replace SHGH_jw = 0 if ir_jw != "SHORT-HORNED GRASSHOPPER" | dr_jw != "SHORT-HORNED GRASSHOPPER"
	replace SB_jw = 0 if ir_jw != "STEM BORER" | dr_jw != "STEM BORER"
	replace SM_jw = 0 if ir_jw != "SUBMERGENCE" | dr_jw != "SUBMERGENCE"
	replace Thrips_jw = 0 if ir_jw != "THRIPS" | dr_jw != "THRIPS"
	replace BLS_jw = 0 if ir_jw != "BACTERIAL LEAF STREAK" | dr_jw != "BACTERIAL LEAF STREAK"
	replace BS_jw = 0 if ir_jw != "BROWN SPOT" | dr_jw != "BROWN SPOT"
	replace GS_jw = 0 if ir_jw != "GRASSY STOUT" | dr_jw != "GRASSY STOUT"
	replace NB_jw = 0 if ir_jw != "NECK BLAST" | dr_jw != "NECK BLAST"
	replace RS_jw = 0 if ir_jw != "RAGGED STUNT" | dr_jw != "RAGGED STUNT"
	replace SBLIGHT_jw = 0 if ir_jw != "SHEATH BLIGHT" | dr_jw != "SHEATH BLIGHT"
	replace SP_jw = 0 if ir_jw != "SHEATH PANICLE" | dr_jw != "SHEATH PANICLE"
	replace Tungro_jw = 0 if ir_jw != "TUNGRO" | dr_jw != "TUNGRO"
	
*Dry season
	gen AW_jd = 1 if ir_jd == "ARMYWORM" | dr_jd == "ARMYWORM"
	gen BB_jd = 1 if ir_jd == "BACTERIAL BLIGHT" | dr_jd == "BACTERIAL BLIGHT"
	gen Blast_jd = 1 if ir_jd == "BLAST" | dr_jd == "BLAST"
	gen CW_jd = 1 if ir_jd == "CASEWORM" | dr_jd == "CASEWORM"
	gen Check_jd = 1 if ir_jd == "CHECK" | dr_jd == "CHECK"
	gen Drought_jd = 1 if ir_jd == "DROUGHT" | dr_jd == "DROUGHT"
	gen GM_jd = 1 if ir_jd == "GALL MIDGE" | dr_jd == "GALL MIDGE"
	gen GAS_jd = 1 if ir_jd == "GOLDEN APPLE SNAIL" | dr_jd == "GOLDEN APPLE SNAIL"
	gen LF_jd = 1 if ir_jd == "LEAF FOLDER" | dr_jd == "LEAF FOLDER"
	gen PH_jd = 1 if ir_jd == "PLANTHOPPER" | dr_jd == "PLANTHOPPER"
	gen Rat_jd = 1 if ir_jd == "RAT" | dr_jd == "RAT"
	gen RB_jd = 1 if ir_jd == "RICE BLAST" | dr_jd == "RICE BLAST"
	gen RBug_jd = 1 if ir_jd == "RICE BUG" | dr_jd == "RICE BUG"
	gen Rodent_jd = 1 if ir_jd == "RODENT" | dr_jd == "RODENT"
	gen SR_jd = 1 if ir_jd == "SHEATH ROT" | dr_jd == "SHEATH ROT"
	gen SHGH_jd = 1 if ir_jd == "SHORT-HORNED GRASSHOPPER" | dr_jd == "SHORT-HORNED GRASSHOPPER"
	gen SB_jd = 1 if ir_jd == "STEM BORER" | dr_jd == "STEM BORER"
	gen SM_jd = 1 if ir_jd == "SUBMERGENCE" | dr_jd == "SUBMERGENCE"
	gen Thrips_jd = 1 if ir_jd == "THRIPS" | dr_jd == "THRIPS"
	gen BLS_jd = 1 if ir_jd == "BACTERIAL LEAF STREAK" | dr_jd == "BACTERIAL LEAF STREAK"
	gen BS_jd = 1 if ir_jd == "BROWN SPOT" | dr_jd == "BROWN SPOT"
	gen GS_jd = 1 if ir_jd == "GRASSY STOUT" | dr_jd == "GRASSY STOUT"
	gen NB_jd = 1 if ir_jd == "NECK BLAST" | dr_jd == "NECK BLAST"
	gen RS_jd = 1 if ir_jd == "RAGGED STUNT" | dr_jd == "RAGGED STUNT"
	gen SBLIGHT_jd = 1 if ir_jd == "SHEATH BLIGHT" | dr_jd == "SHEATH BLIGHT"
	gen SP_jd = 1 if ir_jd == "SHEATH PANICLE" | dr_jd == "SHEATH PANICLE"
	gen Tungro_jd = 1 if ir_jd == "TUNGRO" | dr_jd == "TUNGRO"

	replace AW_jd = 0 if ir_jd != "ARMYWORM" | dr_jd != "ARMYWORM"
	replace BB_jd = 0 if ir_jd != "BACTERIAL BLIGHT" | dr_jd != "BACTERIAL BLIGHT"
	replace Blast_jd = 0 if ir_jd != "BLAST" | dr_jd != "BLAST"
	replace CW_jd = 0 if ir_jd != "CASEWORM" | dr_jd != "CASEWORM"
	replace Check_jd = 0 if ir_jd != "CHECK" | dr_jd != "CHECK"
	replace Drought_jd = 0 if ir_jd != "DROUGHT" | dr_jd != "DROUGHT"
	replace GM_jd = 0 if ir_jd != "GALL MIDGE" | dr_jd != "GALL MIDGE"
	replace GAS_jd = 0 if ir_jd != "GOLDEN APPLE SNAIL" | dr_jd != "GOLDEN APPLE SNAIL"
	replace LF_jd = 0 if ir_jd != "LEAF FOLDER" | dr_jd != "LEAF FOLDER"
	replace PH_jd = 0 if ir_jd != "PLANTHOPPER" | dr_jd != "PLANTHOPPER"
	replace Rat_jd = 0 if ir_jd != "RAT" | dr_jd != "RAT"
	replace RB_jd = 0 if ir_jd != "RICE BLAST" | dr_jd != "RICE BLAST"
	replace RBug_jd = 0 if ir_jd != "RICE BUG" | dr_jd != "RICE BUG"
	replace Rodent_jd = 0 if ir_jd != "RODENT" | dr_jd != "RODENT"
	replace SR_jd = 0 if ir_jd != "SHEATH ROT" | dr_jd != "SHEATH ROT"
	replace SHGH_jd = 0 if ir_jd != "SHORT-HORNED GRASSHOPPER" | dr_jd != "SHORT-HORNED GRASSHOPPER"
	replace SB_jd = 0 if ir_jd != "STEM BORER" | dr_jd != "STEM BORER"
	replace SM_jd = 0 if ir_jd != "SUBMERGENCE" | dr_jd != "SUBMERGENCE"
	replace Thrips_jd = 0 if ir_jd != "THRIPS" | dr_jd != "THRIPS"
	replace BLS_jd = 0 if ir_jd != "BACTERIAL LEAF STREAK" | dr_jd != "BACTERIAL LEAF STREAK"
	replace BS_jd = 0 if ir_jd != "BROWN SPOT" | dr_jd != "BROWN SPOT"
	replace GS_jd = 0 if ir_jd != "GRASSY STOUT" | dr_jd != "GRASSY STOUT"
	replace NB_jd = 0 if ir_jd != "NECK BLAST" | dr_jd != "NECK BLAST"
	replace RS_jd = 0 if ir_jd != "RAGGED STUNT" | dr_jd != "RAGGED STUNT"
	replace SBLIGHT_jd = 0 if ir_jd != "SHEATH BLIGHT" | dr_jd != "SHEATH BLIGHT"
	replace SP_jd = 0 if ir_jd != "SHEATH PANICLE" | dr_jd != "SHEATH PANICLE"
	replace Tungro_jd = 0 if ir_jd != "TUNGRO" | dr_jd != "TUNGRO"
	
* **********************************************************************
* 4 -	VARIABLE LABEL, LABEL DEFINITIONS, AND LABEL VALUES
* **********************************************************************
	
*Labelling variables
	label variable hhid "Unique Household ID" 
	label variable session "Session" 
	label variable hh "Household ID per session" 
	label variable preyveng "Province" 
	label variable date "Date" 
	label variable morning "Morning Session" 
	label variable market "Market Information" 
	label variable climate "Climate Information" 
	label variable repvar_jw "Replacement Variety (Wet)" 
	label variable repvar_jd "Replacement Variety (Dry)" 
	label variable number "Insect/Disease Number" 
	label variable ir_jw "Insect (Wet)" 
	label variable ir_jd "Insect (Dry)" 
	label variable dr_jw "Disease (Wet)" 
	label variable dr_jd "Disease (Dry)"
	label variable AW_jw "Armyworm (Wet Season)" 
	label variable BBLIGHT_jw "Bacterial Blight (Wet Season)" 
	label variable Blast_jw "Blast (Wet Season)" 
	label variable CW_jw "Caseworm (Wet Season)" 
	label variable Check_jw "Check (Wet Season)" 
	label variable Drought_jw "Drought (Wet Season)" 
	label variable GM_jw "Gall Midge (Wet Season)" 
	label variable GAS_jw "Golden Apple Snail (Wet Season)" 
	label variable LF_jw "Leaf Folder (Wet Season)" 
	label variable PH_jw "Planthopper (Wet Season)" 
	label variable Rat_jw "Rat (Wet Season)" 
	label variable RB_jw "Rice Blast (Wet Season)" 
	label variable RBug_jw "Rice Bug (Wet Season)" 
	label variable Rodent_jw "Rodent (Wet Season)" 
	label variable SR_jw "Sheath Rot (Wet Season)" 
	label variable SHGH_jw "Short-Horned Grasshopper (Wet Season)" 
	label variable SB_jw "Stem Borer (Wet Season)" 
	label variable SM_jw "Submergence (Wet Season)" 
	label variable Thrips_jw "Thrips (Wet Season)" 
	label variable BLS_jw "Bacterial Leaf Streak (Wet Season)" 
	label variable BS_jw "Brown Spot (Wet Season)" 
	label variable GS_jw "Grassy Stout (Wet Season)" 
	label variable NB_jw "Neck Blast (Wet Season)" 
	label variable RS_jw "Ragged Stunt (Wet Season)" 
	label variable SBLIGHT_jw "Sheath Blight (Wet Season)" 
	label variable SP_jw "Sheath Panicle (Wet Season)" 
	label variable Tungro_jw "Tungro (Wet Season)" 
	label variable AW_jd "Armyworm (Dry Season)" 
	label variable BB_jd "Bacterial Blight (Dry Season)" 
	label variable Blast_jd "Blast (Dry Season)" 
	label variable CW_jd "Caseworm (Dry Season)" 
	label variable Check_jd "Check (Dry Season)" 
	label variable Drought_jd "Drought (Dry Season)" 
	label variable GM_jd "Gall Midge (Dry Season)" 
	label variable GAS_jd "Golden Apple Snail (Dry Season)" 
	label variable LF_jd "Leaf Folder (Dry Season)" 
	label variable PH_jd "Planthopper (Dry Season)" 
	label variable Rat_jd "Rat (Dry Season)" 
	label variable RB_jd "Rice Blast (Dry Season)" 
	label variable RBug_jd "Rice Bug (Dry Season)" 
	label variable Rodent_jd "Rodent (Dry Season)" 
	label variable SR_jd "Sheath Rot (Dry Season)" 
	label variable SHGH_jd "Short-Horned Grasshopper (Dry Season)" 
	label variable SB_jd "Stem Borer (Dry Season)" 
	label variable SM_jd "Submergence (Dry Season)" 
	label variable Thrips_jd "Thrips (Dry Season)" 
	label variable BLS_jd "Bacterial Leaf Streak (Dry Season)" 
	label variable BS_jd "Brown Spot (Dry Season)" 
	label variable GS_jd "Grassy Stout (Dry Season)" 
	label variable NB_jd "Neck Blast (Dry Season)" 
	label variable RS_jd "Ragged Stunt (Dry Season)" 
	label variable SBLIGHT_jd "Sheath Blight (Dry Season)" 
	label variable SP_jd "Sheath Panicle (Dry Season)" 
	label variable Tungro_jd "Tungro (Dry Season)" 
	
	
*Define and label values for variables
	*preyveng
		label define L_preyveng 1 "Prey Veng" 0 "Takeo"
		label values preyveng L_preyveng

	*morning
		label define L_morning 1 "Yes" 0 "No"
		label values morning L_morning 

	*market 
		label define L_market 1 "With market information" 0 "Otherwise"
		label values market L_market

	*climate
		label define L_climate 1 "With climate information" 0 "Otherwise"
		label values climate L_climate
		
	*insects and diseases dummy variables
		label define yesno 1 "Yes" 0 "No"
		label values  AW_jw yesno
		label values  BBLIGHT_jw yesno
		label values  Blast_jw yesno
		label values  CW_jw yesno
		label values  Check_jw yesno
		label values  Drought_jw yesno
		label values  GM_jw yesno
		label values  GAS_jw yesno
		label values  LF_jw yesno
		label values  PH_jw yesno
		label values  Rat_jw yesno
		label values  RB_jw yesno
		label values  RBug_jw yesno
		label values  Rodent_jw yesno
		label values  SR_jw yesno
		label values  SHGH_jw yesno
		label values  SB_jw yesno
		label values  SM_jw yesno
		label values  Thrips_jw yesno
		label values  BLS_jw yesno
		label values  BS_jw yesno
		label values  GS_jw yesno
		label values  NB_jw yesno
		label values  RS_jw yesno
		label values  SBLIGHT_jw yesno
		label values  SP_jw yesno
		label values  Tungro_jw yesno
		label values  AW_jd yesno
		label values  BB_jd yesno
		label values  Blast_jd yesno
		label values  CW_jd yesno
		label values  Check_jd yesno
		label values  Drought_jd yesno
		label values  GM_jd yesno
		label values  GAS_jd yesno
		label values  LF_jd yesno
		label values  PH_jd yesno
		label values  Rat_jd yesno
		label values  RB_jd yesno
		label values  RBug_jd yesno
		label values  Rodent_jd yesno
		label values  SR_jd yesno
		label values  SHGH_jd yesno
		label values  SB_jd yesno
		label values  SM_jd yesno
		label values  Thrips_jd yesno
		label values  BLS_jd yesno
		label values  BS_jd yesno
		label values  GS_jd yesno
		label values  NB_jd yesno
		label values  RS_jd yesno
		label values  SBLIGHT_jd yesno
		label values  SP_jd yesno
		label values  Tungro_jd yesno
	
	
* **********************************************************************
* 5 -	EXPECTED OUTPUT
* **********************************************************************

*Frequency and Percentage Distribution of Insects and Diseases Found in Replacement Varieties during Wet Season
	tab ir_jw repvar_jw if repvar_jw == "PHKA RUMDOUL" | repvar_jw == "IR504", col rowsort
	tab dr_jw repvar_jw if repvar_jw == "PHKA RUMDOUL" | repvar_jw == "IR504", col rowsort
	
*Frequency and Percentage Distribution of Insects and Diseases Found in Replacement Varieties during Dry Season
	tab ir_jd repvar_jd if repvar_jd == "IR504" | repvar_jd == "IR85", col rowsort
	tab dr_jd repvar_jd if repvar_jd == "IR504" | repvar_jd == "IR85", col rowsort

* **********************************************************************
* 6 - OTHER MATTERS
* **********************************************************************

*Order variables in the dataset
	order hhid session hh preyveng date morning market climate repvar_jw repvar_jd number

* **********************************************************************
* 7 - PREPARING FOR EXPORT
* **********************************************************************

*Describe dataset
	compress
	describe
	summarize 
	
*Save the dataset
	save "$output\0_IRDR_draft", replace
	
* **********************************************************************
* END OF CODE
* **********************************************************************


