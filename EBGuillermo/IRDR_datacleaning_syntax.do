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
*	global root = "C:\Users\Bianca Guillermo\git\04_syntax\EBGuillermo\raw"
*	global output = "C:\Users\Bianca Guillermo\git\04_syntax\EBGuillermo\refined"
	
	global root = "E:\Google Drive\INSTATOJT\EBGuillermo\raw"
	global output = "E:\Google Drive\jy_mrt_files\MRT - VERDE (2018)"
	
* ***********************************************************************
* 1 - PREPARING DATA
* ***********************************************************************

*Import raw data
	import excel "$root\IRDR.xlsx", sheet("Sheet1") firstrow

*Create draft version of data
*	save "$output\0_IRDR_draft", replace
	save "$output\0_IRDR_verde", replace
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
	replace ir_jd= "BLAST" if ir_jd == "RICE BLAST"
	
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
	
	
*Reshape back to wide
	reshape wide
	drop dr_jw5 dr_jd5 dr_jw6 dr_jd6


* **********************************************************************
* 3 -	DUMMY VARIABLES FOR INSECTS AND DISEASES
* **********************************************************************

*Wet Season
	gen AW_jw = 1 if 		ir_jw1 == "ARMYWORM" | ir_jw2 == "ARMYWORM" | ///
							ir_jw3 == "ARMYWORM" | ir_jw4 == "ARMYWORM" | ///
							ir_jw5 == "ARMYWORM" | ir_jw6 == "ARMYWORM" | ///
							dr_jw1 == "ARMYWORM" | dr_jw2 == "ARMYWORM" | ///
							dr_jw3 == "ARMYWORM" | dr_jw4 == "ARMYWORM"
	gen BBLIGHT_jw = 1 if 	ir_jw1 == "BACTERIAL BLIGHT" | ir_jw2 == "BACTERIAL BLIGHT" |  ///
							ir_jw3 == "BACTERIAL BLIGHT" | ir_jw4 == "BACTERIAL BLIGHT" |  ///
							ir_jw5 == "BACTERIAL BLIGHT" | ir_jw6 == "BACTERIAL BLIGHT" |  ///
							dr_jw1 == "BACTERIAL BLIGHT" | dr_jw2 == "BACTERIAL BLIGHT" |  ///
							dr_jw3 == "BACTERIAL BLIGHT" | dr_jw4 == "BACTERIAL BLIGHT"
	gen Blast_jw = 1 if 	ir_jw1 == "BLAST" | ir_jw2 == "BLAST" | ///
							ir_jw3 == "BLAST" | ir_jw4 == "BLAST" | ir_jw5 == "BLAST" |  ///
							ir_jw6 == "BLAST" | dr_jw1 == "BLAST" | dr_jw2 == "BLAST" |  ///
							dr_jw3 == "BLAST" | dr_jw4 == "BLAST"
	gen CW_jw = 1 if 		ir_jw1 == "CASEWORM" | ir_jw2 == "CASEWORM" |  ///
							ir_jw3 == "CASEWORM" | ir_jw4 == "CASEWORM" |  ///
							ir_jw5 == "CASEWORM" | ir_jw6 == "CASEWORM" |  ///
							dr_jw1 == "CASEWORM" | dr_jw2 == "CASEWORM" |  ///
							dr_jw3 == "CASEWORM" | dr_jw4 == "CASEWORM"
	gen Check_jw = 1 if 	ir_jw1 == "CHECK" | ir_jw2 == "CHECK" | ///
							ir_jw3 == "CHECK" | ir_jw4 == "CHECK" | ir_jw5 == "CHECK" |  ///
							ir_jw6 == "CHECK" | dr_jw1 == "CHECK" | dr_jw2 == "CHECK" |  ///
							dr_jw3 == "CHECK" | dr_jw4 == "CHECK"
	gen Drought_jw = 1 if 	ir_jw1 == "DROUGHT" | ir_jw2 == "DROUGHT" |  ///
							ir_jw3 == "DROUGHT" | ir_jw4 == "DROUGHT" |  ///
							ir_jw5 == "DROUGHT" | ir_jw6 == "DROUGHT" |  ///
							dr_jw1 == "DROUGHT" | dr_jw2 == "DROUGHT" |  ///
							dr_jw3 == "DROUGHT" | dr_jw4 == "DROUGHT"
	gen GM_jw = 1 if 		ir_jw1 == "GALL MIDGE" | ir_jw2 == "GALL MIDGE" |  ///
							ir_jw3 == "GALL MIDGE" | ir_jw4 == "GALL MIDGE" |  ///
							ir_jw5 == "GALL MIDGE" | ir_jw6 == "GALL MIDGE" |  ///
							dr_jw1 == "GALL MIDGE" | dr_jw2 == "GALL MIDGE" |  ///
							dr_jw3 == "GALL MIDGE" | dr_jw4 == "GALL MIDGE"
	gen GAS_jw = 1 if 		ir_jw1 == "GOLDEN APPLE SNAIL" | ir_jw2 == "GOLDEN APPLE SNAIL" | ///
							ir_jw3 == "GOLDEN APPLE SNAIL" | ir_jw4 == "GOLDEN APPLE SNAIL" |  ///
							ir_jw5 == "GOLDEN APPLE SNAIL" | ir_jw6 == "GOLDEN APPLE SNAIL" |  ///
							dr_jw1 == "GOLDEN APPLE SNAIL" | dr_jw2 == "GOLDEN APPLE SNAIL" |  ///
							dr_jw3 == "GOLDEN APPLE SNAIL" | dr_jw4 == "GOLDEN APPLE SNAIL"
	gen LF_jw = 1 if 		ir_jw1 == "LEAF FOLDER" | ir_jw2 == "LEAF FOLDER" |  ///
							ir_jw3 == "LEAF FOLDER" | ir_jw4 == "LEAF FOLDER" |  ///
							ir_jw5 == "LEAF FOLDER" | ir_jw6 == "LEAF FOLDER" |  ///
							dr_jw1 == "LEAF FOLDER" | dr_jw2 == "LEAF FOLDER" |  ///
							dr_jw3 == "LEAF FOLDER" | dr_jw4 == "LEAF FOLDER"
	gen PH_jw = 1 if 		ir_jw1 == "PLANTHOPPER" | ir_jw2 == "PLANTHOPPER" |  ///
							ir_jw3 == "PLANTHOPPER" | ir_jw4 == "PLANTHOPPER" |  ///
							ir_jw5 == "PLANTHOPPER" | ir_jw6 == "PLANTHOPPER" |  ///
							dr_jw1 == "PLANTHOPPER" | dr_jw2 == "PLANTHOPPER" |  ///
							dr_jw3 == "PLANTHOPPER" | dr_jw4 == "PLANTHOPPER"
	gen Rat_jw = 1 if 		ir_jw1 == "RAT" | ir_jw2 == "RAT" |  ///
							ir_jw3 == "RAT" | ir_jw4 == "RAT" |  ///
							ir_jw5 == "RAT" | ir_jw6 == "RAT" |  ///
							dr_jw1 == "RAT" | dr_jw2 == "RAT" |  ///
							dr_jw3 == "RAT" | dr_jw4 == "RAT"
	gen RBug_jw = 1 if 		ir_jw1 == "RICE BUG" | ir_jw2 == "RICE BUG" |  ///
							ir_jw3 == "RICE BUG" | ir_jw4 == "RICE BUG" |  ///
							ir_jw5 == "RICE BUG" | ir_jw6 == "RICE BUG" |  ///
							dr_jw1 == "RICE BUG" | dr_jw2 == "RICE BUG" |  ///
							dr_jw3 == "RICE BUG" | dr_jw4 == "RICE BUG"
	gen Rodent_jw = 1 if 	ir_jw1 == "RODENT" | ir_jw2 == "RODENT" |  ///
							ir_jw3 == "RODENT" | ir_jw4 == "RODENT" |  ///
							ir_jw5 == "RODENT" | ir_jw6 == "RODENT" |  ///
							dr_jw1 == "RODENT" | dr_jw2 == "RODENT" |  ///
							dr_jw3 == "RODENT" | dr_jw4 == "RODENT"
	gen SR_jw = 1 if 		ir_jw1 == "SHEATH ROT" | ir_jw2 == "SHEATH ROT" |  ///
							ir_jw3 == "SHEATH ROT" | ir_jw4 == "SHEATH ROT" |  ///
							ir_jw5 == "SHEATH ROT" | ir_jw6 == "SHEATH ROT" |  ///
							dr_jw1 == "SHEATH ROT" | dr_jw2 == "SHEATH ROT" |  ///
							dr_jw3 == "SHEATH ROT" | dr_jw4 == "SHEATH ROT"
	gen SHGH_jw = 1 if 		ir_jw1 == "SHORT-HORNED GRASSHOPPER" | ir_jw2 == "SHORT-HORNED GRASSHOPPER" |  ///
							ir_jw3 == "SHORT-HORNED GRASSHOPPER" | ir_jw4 == "SHORT-HORNED GRASSHOPPER" |  ///
							ir_jw5 == "SHORT-HORNED GRASSHOPPER" | ir_jw6 == "SHORT-HORNED GRASSHOPPER" |  ///
							dr_jw1 == "SHORT-HORNED GRASSHOPPER" | dr_jw2 == "SHORT-HORNED GRASSHOPPER" |  ///
							dr_jw3 == "SHORT-HORNED GRASSHOPPER" | dr_jw4 == "SHORT-HORNED GRASSHOPPER"
	gen SB_jw = 1 if 		ir_jw1 == "STEM BORER" | ir_jw2 == "STEM BORER" |  ///
							ir_jw3 == "STEM BORER" | ir_jw4 == "STEM BORER" |  ///
							ir_jw5 == "STEM BORER" | ir_jw6 == "STEM BORER" |  ///
							dr_jw1 == "STEM BORER" | dr_jw2 == "STEM BORER" |  ///
							dr_jw3 == "STEM BORER" | dr_jw4 == "STEM BORER"
	gen SM_jw = 1 if 		ir_jw1 == "SUBMERGENCE" | ir_jw2 == "SUBMERGENCE" |  ///
							ir_jw3 == "SUBMERGENCE" | ir_jw4 == "SUBMERGENCE" |  ///
							ir_jw5 == "SUBMERGENCE" | ir_jw6 == "SUBMERGENCE" |  ///
							dr_jw1 == "SUBMERGENCE" | dr_jw2 == "SUBMERGENCE" |  ///
							dr_jw3 == "SUBMERGENCE" | dr_jw4 == "SUBMERGENCE"
	gen Thrips_jw = 1 if 	ir_jw1 == "THRIPS" | ir_jw2 == "THRIPS" |  ///
							ir_jw3 == "THRIPS" | ir_jw4 == "THRIPS" |  ///
							ir_jw5 == "THRIPS" | ir_jw6 == "THRIPS" |  ///
							dr_jw1 == "THRIPS" | dr_jw2 == "THRIPS" |  ///
							dr_jw3 == "THRIPS" | dr_jw4 == "THRIPS"
	gen BLS_jw = 1 if 		ir_jw1 == "BACTERIAL LEAF STREAK" | ir_jw2 == "BACTERIAL LEAF STREAK" |  ///
							ir_jw3 == "BACTERIAL LEAF STREAK" | ir_jw4 == "BACTERIAL LEAF STREAK" |  ///
							ir_jw5 == "BACTERIAL LEAF STREAK" | ir_jw6 == "BACTERIAL LEAF STREAK" |  ///
							dr_jw1 == "BACTERIAL LEAF STREAK" | dr_jw2 == "BACTERIAL LEAF STREAK" |  ///
							dr_jw3 == "BACTERIAL LEAF STREAK" | dr_jw4 == "BACTERIAL LEAF STREAK"
	gen BS_jw = 1 if 		ir_jw1 == "BROWN SPOT" | ir_jw2 == "BROWN SPOT" |  ///
							ir_jw3 == "BROWN SPOT" | ir_jw4 == "BROWN SPOT" |  ///
							ir_jw5 == "BROWN SPOT" | ir_jw6 == "BROWN SPOT" |  ///
							dr_jw1 == "BROWN SPOT" | dr_jw2 == "BROWN SPOT" |  ///
							dr_jw3 == "BROWN SPOT" | dr_jw4 == "BROWN SPOT"
	gen GS_jw = 1 if 		ir_jw1 == "GRASSY STUNT" | ir_jw2 == "GRASSY STUNT" |  ///
							ir_jw3 == "GRASSY STUNT" | ir_jw4 == "GRASSY STUNT" |  ///
							ir_jw5 == "GRASSY STUNT" | ir_jw6 == "GRASSY STUNT" |  ///
							dr_jw1 == "GRASSY STUNT" | dr_jw2 == "GRASSY STUNT" |  ///
							dr_jw3 == "GRASSY STUNT" | dr_jw4 == "GRASSY STUNT"
	gen NB_jw = 1 if 		ir_jw1 == "NECK BLAST" | ir_jw2 == "NECK BLAST" |  ///
							ir_jw3 == "NECK BLAST" | ir_jw4 == "NECK BLAST" |  ///
							ir_jw5 == "NECK BLAST" | ir_jw6 == "NECK BLAST" |  ///
							dr_jw1 == "NECK BLAST" | dr_jw2 == "NECK BLAST" |  ///
							dr_jw3 == "NECK BLAST" | dr_jw4 == "NECK BLAST"
	gen RS_jw = 1 if 		ir_jw1 == "RAGGED STUNT" | ir_jw2 == "RAGGED STUNT" |  ///
							ir_jw3 == "RAGGED STUNT" | ir_jw4 == "RAGGED STUNT" |  ///
							ir_jw5 == "RAGGED STUNT" | ir_jw6 == "RAGGED STUNT" |  ///
							dr_jw1 == "RAGGED STUNT" | dr_jw2 == "RAGGED STUNT" |  ///
							dr_jw3 == "RAGGED STUNT" | dr_jw4 == "RAGGED STUNT"
	gen SBLIGHT_jw = 1 if 	ir_jw1 == "SHEATH BLIGHT" | ir_jw2 == "SHEATH BLIGHT" |  ///
							ir_jw3 == "SHEATH BLIGHT" | ir_jw4 == "SHEATH BLIGHT" |  ///
							ir_jw5 == "SHEATH BLIGHT" | ir_jw6 == "SHEATH BLIGHT" |  ///
							dr_jw1 == "SHEATH BLIGHT" | dr_jw2 == "SHEATH BLIGHT" |  ///
							dr_jw3 == "SHEATH BLIGHT" | dr_jw4 == "SHEATH BLIGHT"

	gen Tungro_jw = 1 if 	ir_jw1 == "TUNGRO" | ir_jw2 == "TUNGRO" |  ///
							ir_jw3 == "TUNGRO" | ir_jw4 == "TUNGRO" |  ///
							ir_jw5 == "TUNGRO" | ir_jw6 == "TUNGRO" |  ///
							dr_jw1 == "TUNGRO" | dr_jw2 == "TUNGRO" |  ///
							dr_jw3 == "TUNGRO" | dr_jw4 == "TUNGRO"

/*	
	Note: no need to replace 0 when there is no response to indicate that the farmer did not encounter the insect of disease
	
	replace AW_jw = 0 if AW_jw == .
	replace BBLIGHT_jw = 0 if BBLIGHT_jw == .
	replace Blast_jw = 0 if Blast_jw == .
	replace CW_jw = 0 if CW_jw == .
	replace Check_jw = 0 if Check_jw == .
	replace Drought_jw = 0 if Drought_jw == .
	replace GM_jw = 0 if GM_jw == .
	replace GAS_jw = 0 if GAS_jw == .
	replace LF_jw = 0 if LF_jw == .
	replace PH_jw = 0 if PH_jw == .
	replace Rat_jw = 0 if Rat_jw == .
	replace RBug_jw = 0 if RBug_jw == .
	replace Rodent_jw = 0 if Rodent_jw == .
	replace SR_jw = 0 if SR_jw == .
	replace SHGH_jw = 0 if SHGH_jw == .
	replace SB_jw = 0 if SB_jw == .
	replace SM_jw = 0 if SM_jw == .
	replace Thrips_jw = 0 if Thrips_jw == .
	replace BLS_jw = 0 if BLS_jw == .
	replace BS_jw = 0 if BS_jw == .
	replace GS_jw = 0 if GS_jw == .
	replace NB_jw = 0 if NB_jw == .
	replace RS_jw = 0 if RS_jw == .
	replace SBLIGHT_jw = 0 if SBLIGHT_jw == .
	replace SP_jw = 0 if SP_jw == .
	replace Tungro_jw = 0 if Tungro_jw == .
*/

*Dry Season
	gen AW_jd = 1 if 		ir_jd1 == "ARMYWORM" | ir_jd2 == "ARMYWORM" |  ///
							ir_jd3 == "ARMYWORM" | ir_jd4 == "ARMYWORM" |  ///
							ir_jd5 == "ARMYWORM" | ir_jd6 == "ARMYWORM" |  ///
							dr_jd1 == "ARMYWORM" | dr_jd2 == "ARMYWORM" |  ///
							dr_jd3 == "ARMYWORM" | dr_jd4 == "ARMYWORM"
	gen BBLIGHT_jd = 1 if 	ir_jd1 == "BACTERIAL BLIGHT" | ir_jd2 == "BACTERIAL BLIGHT" |  ///
							ir_jd3 == "BACTERIAL BLIGHT" | ir_jd4 == "BACTERIAL BLIGHT" |  ///
							ir_jd5 == "BACTERIAL BLIGHT" | ir_jd6 == "BACTERIAL BLIGHT" |  ///
							dr_jd1 == "BACTERIAL BLIGHT" | dr_jd2 == "BACTERIAL BLIGHT" |  ///
							dr_jd3 == "BACTERIAL BLIGHT" | dr_jd4 == "BACTERIAL BLIGHT"
	gen Blast_jd = 1 if 	ir_jd1 == "BLAST" | ir_jd2 == "BLAST" |  ///
							ir_jd3 == "BLAST" | ir_jd4 == "BLAST" |  ///
							ir_jd5 == "BLAST" | ir_jd6 == "BLAST" |  ///
							dr_jd1 == "BLAST" | dr_jd2 == "BLAST" |  ///
							dr_jd3 == "BLAST" | dr_jd4 == "BLAST"
	gen CW_jd = 1 if 		ir_jd1 == "CASEWORM" | ir_jd2 == "CASEWORM" |  ///
							ir_jd3 == "CASEWORM" | ir_jd4 == "CASEWORM" |  ///
							ir_jd5 == "CASEWORM" | ir_jd6 == "CASEWORM" |  ///
							dr_jd1 == "CASEWORM" | dr_jd2 == "CASEWORM" |  ///
							dr_jd3 == "CASEWORM" | dr_jd4 == "CASEWORM"
	gen Check_jd = 1 if 	ir_jd1 == "CHECK" | ir_jd2 == "CHECK" |  ///
							ir_jd3 == "CHECK" | ir_jd4 == "CHECK" |  ///
							ir_jd5 == "CHECK" | ir_jd6 == "CHECK" |  ///
							dr_jd1 == "CHECK" | dr_jd2 == "CHECK" |  ///
							dr_jd3 == "CHECK" | dr_jd4 == "CHECK"
	gen Drought_jd = 1 if 	ir_jd1 == "DROUGHT" | ir_jd2 == "DROUGHT" |  ///
							ir_jd3 == "DROUGHT" | ir_jd4 == "DROUGHT" |  ///
							ir_jd5 == "DROUGHT" | ir_jd6 == "DROUGHT" |  ///
							dr_jd1 == "DROUGHT" | dr_jd2 == "DROUGHT" |  ///
							dr_jd3 == "DROUGHT" | dr_jd4 == "DROUGHT"
	gen GM_jd = 1 if 		ir_jd1 == "GALL MIDGE" | ir_jd2 == "GALL MIDGE" |  ///
							ir_jd3 == "GALL MIDGE" | ir_jd4 == "GALL MIDGE" |  ///
							ir_jd5 == "GALL MIDGE" | ir_jd6 == "GALL MIDGE" |  ///
							dr_jd1 == "GALL MIDGE" | dr_jd2 == "GALL MIDGE" |  ///
							dr_jd3 == "GALL MIDGE" | dr_jd4 == "GALL MIDGE"
	gen GAS_jd = 1 if 		ir_jd1 == "GOLDEN APPLE SNAIL" | ir_jd2 == "GOLDEN APPLE SNAIL" |  ///
							ir_jd3 == "GOLDEN APPLE SNAIL" | ir_jd4 == "GOLDEN APPLE SNAIL" |  ///
							ir_jd5 == "GOLDEN APPLE SNAIL" | ir_jd6 == "GOLDEN APPLE SNAIL" |  ///
							dr_jd1 == "GOLDEN APPLE SNAIL" | dr_jd2 == "GOLDEN APPLE SNAIL" |  ///
							dr_jd3 == "GOLDEN APPLE SNAIL" | dr_jd4 == "GOLDEN APPLE SNAIL"
	gen LF_jd = 1 if 		ir_jd1 == "LEAF FOLDER" | ir_jd2 == "LEAF FOLDER" |  ///
							ir_jd3 == "LEAF FOLDER" | ir_jd4 == "LEAF FOLDER" |  ///
							ir_jd5 == "LEAF FOLDER" | ir_jd6 == "LEAF FOLDER" |  ///
							dr_jd1 == "LEAF FOLDER" | dr_jd2 == "LEAF FOLDER" |  ///
							dr_jd3 == "LEAF FOLDER" | dr_jd4 == "LEAF FOLDER"
	gen PH_jd = 1 if 		ir_jd1 == "PLANTHOPPER" | ir_jd2 == "PLANTHOPPER" |  ///
							ir_jd3 == "PLANTHOPPER" | ir_jd4 == "PLANTHOPPER" |  ///
							ir_jd5 == "PLANTHOPPER" | ir_jd6 == "PLANTHOPPER" |  ///
							dr_jd1 == "PLANTHOPPER" | dr_jd2 == "PLANTHOPPER" |  ///
							dr_jd3 == "PLANTHOPPER" | dr_jd4 == "PLANTHOPPER"
	gen Rat_jd = 1 if 		ir_jd1 == "RAT" | ir_jd2 == "RAT" |  ///
							ir_jd3 == "RAT" | ir_jd4 == "RAT" |  ///
							ir_jd5 == "RAT" | ir_jd6 == "RAT" |  ///
							dr_jd1 == "RAT" | dr_jd2 == "RAT" |  ///
							dr_jd3 == "RAT" | dr_jd4 == "RAT"
		gen RBug_jd = 1 if ir_jd1 == "RICE BUG" | ir_jd2 == "RICE BUG" |  ///
							ir_jd3 == "RICE BUG" | ir_jd4 == "RICE BUG" |  ///
							ir_jd5 == "RICE BUG" | ir_jd6 == "RICE BUG" |  ///
							dr_jd1 == "RICE BUG" | dr_jd2 == "RICE BUG" |  ///
							dr_jd3 == "RICE BUG" | dr_jd4 == "RICE BUG"
	gen Rodent_jd = 1 if 	ir_jd1 == "RODENT" | ir_jd2 == "RODENT" |  ///
							ir_jd3 == "RODENT" | ir_jd4 == "RODENT" |  ///
							ir_jd5 == "RODENT" | ir_jd6 == "RODENT" |  ///
							dr_jd1 == "RODENT" | dr_jd2 == "RODENT" |  ///
							dr_jd3 == "RODENT" | dr_jd4 == "RODENT"
	gen SR_jd = 1 if 		ir_jd1 == "SHEATH ROT" | ir_jd2 == "SHEATH ROT" |  ///
							ir_jd3 == "SHEATH ROT" | ir_jd4 == "SHEATH ROT" |  ///
							ir_jd5 == "SHEATH ROT" | ir_jd6 == "SHEATH ROT" |  ///
							dr_jd1 == "SHEATH ROT" | dr_jd2 == "SHEATH ROT" |  ///
							dr_jd3 == "SHEATH ROT" | dr_jd4 == "SHEATH ROT"
							
	replace SR_jd = 1 if 	ir_jw1 == "SHEATH PANICLE" | ir_jw2 == "SHEATH PANICLE" |  ///
							ir_jw3 == "SHEATH PANICLE" | ir_jw4 == "SHEATH PANICLE" |  ///
							ir_jw5 == "SHEATH PANICLE" | ir_jw6 == "SHEATH PANICLE" |  ///
							dr_jw1 == "SHEATH PANICLE" | dr_jw2 == "SHEATH PANICLE" |  ///
							dr_jw3 == "SHEATH PANICLE" | dr_jw4 == "SHEATH PANICLE"
							
	note SR_jd: There is no Sheath panicle but sheath rot is found in panicle, implying that sheath panicle is the same as sheath rot
							
	gen SHGH_jd = 1 if 		ir_jd1 == "SHORT-HORNED GRASSHOPPER" | ir_jd2 == "SHORT-HORNED GRASSHOPPER" |  ///
							ir_jd3 == "SHORT-HORNED GRASSHOPPER" | ir_jd4 == "SHORT-HORNED GRASSHOPPER" |  ///
							ir_jd5 == "SHORT-HORNED GRASSHOPPER" | ir_jd6 == "SHORT-HORNED GRASSHOPPER" |  ///
							dr_jd1 == "SHORT-HORNED GRASSHOPPER" | dr_jd2 == "SHORT-HORNED GRASSHOPPER" |  ///
							dr_jd3 == "SHORT-HORNED GRASSHOPPER" | dr_jd4 == "SHORT-HORNED GRASSHOPPER"
	gen SB_jd = 1 if 		ir_jd1 == "STEM BORER" | ir_jd2 == "STEM BORER" |  ///
							ir_jd3 == "STEM BORER" | ir_jd4 == "STEM BORER" |  ///
							ir_jd5 == "STEM BORER" | ir_jd6 == "STEM BORER" |  ///
							dr_jd1 == "STEM BORER" | dr_jd2 == "STEM BORER" |  ///
							dr_jd3 == "STEM BORER" | dr_jd4 == "STEM BORER"
	gen SM_jd = 1 if 		ir_jd1 == "SUBMERGENCE" | ir_jd2 == "SUBMERGENCE" |  ///
							ir_jd3 == "SUBMERGENCE" | ir_jd4 == "SUBMERGENCE" |  ///
							ir_jd5 == "SUBMERGENCE" | ir_jd6 == "SUBMERGENCE" |  ///
							dr_jd1 == "SUBMERGENCE" | dr_jd2 == "SUBMERGENCE" |  ///
							dr_jd3 == "SUBMERGENCE" | dr_jd4 == "SUBMERGENCE"
	gen Thrips_jd = 1 if 	ir_jd1 == "THRIPS" | ir_jd2 == "THRIPS" |  ///
							ir_jd3 == "THRIPS" | ir_jd4 == "THRIPS" |  ///
							ir_jd5 == "THRIPS" | ir_jd6 == "THRIPS" |  ///
							dr_jd1 == "THRIPS" | dr_jd2 == "THRIPS" |  ///
							dr_jd3 == "THRIPS" | dr_jd4 == "THRIPS"
	gen BLS_jd = 1 if 		ir_jd1 == "BACTERIAL LEAF STREAK" | ir_jd2 == "BACTERIAL LEAF STREAK" |  ///
							ir_jd3 == "BACTERIAL LEAF STREAK" | ir_jd4 == "BACTERIAL LEAF STREAK" |  ///
							ir_jd5 == "BACTERIAL LEAF STREAK" | ir_jd6 == "BACTERIAL LEAF STREAK" |  ///
							dr_jd1 == "BACTERIAL LEAF STREAK" | dr_jd2 == "BACTERIAL LEAF STREAK" |  ///
							dr_jd3 == "BACTERIAL LEAF STREAK" | dr_jd4 == "BACTERIAL LEAF STREAK"
	gen BS_jd = 1 if 		ir_jd1 == "BROWN SPOT" | ir_jd2 == "BROWN SPOT" |  ///
							ir_jd3 == "BROWN SPOT" | ir_jd4 == "BROWN SPOT" |  ///
							ir_jd5 == "BROWN SPOT" | ir_jd6 == "BROWN SPOT" |  ///
							dr_jd1 == "BROWN SPOT" | dr_jd2 == "BROWN SPOT" |  ///
							dr_jd3 == "BROWN SPOT" | dr_jd4 == "BROWN SPOT"
	gen GS_jd = 1 if 		ir_jd1 == "GRASSY STUNT" | ir_jd2 == "GRASSY STUNT" |  ///
							ir_jd3 == "GRASSY STUNT" | ir_jd4 == "GRASSY STUNT" |  ///
							ir_jd5 == "GRASSY STUNT" | ir_jd6 == "GRASSY STUNT" |  ///
							dr_jd1 == "GRASSY STUNT" | dr_jd2 == "GRASSY STUNT" |  ///
							dr_jd3 == "GRASSY STUNT" | dr_jd4 == "GRASSY STUNT"
	gen NB_jd = 1 if 		ir_jd1 == "NECK BLAST" | ir_jd2 == "NECK BLAST" |  ///
							ir_jd3 == "NECK BLAST" | ir_jd4 == "NECK BLAST" |  ///
							ir_jd5 == "NECK BLAST" | ir_jd6 == "NECK BLAST" |  ///
							dr_jd1 == "NECK BLAST" | dr_jd2 == "NECK BLAST" |  ///
							dr_jd3 == "NECK BLAST" | dr_jd4 == "NECK BLAST"
	gen RS_jd = 1 if 		ir_jd1 == "RAGGED STUNT" | ir_jd2 == "RAGGED STUNT" |  ///
							ir_jd3 == "RAGGED STUNT" | ir_jd4 == "RAGGED STUNT" |  ///
							ir_jd5 == "RAGGED STUNT" | ir_jd6 == "RAGGED STUNT" |  ///
							dr_jd1 == "RAGGED STUNT" | dr_jd2 == "RAGGED STUNT" |  ///
							dr_jd3 == "RAGGED STUNT" | dr_jd4 == "RAGGED STUNT"
	gen SBLIGHT_jd = 1 if 	ir_jd1 == "SHEATH BLIGHT" | ir_jd2 == "SHEATH BLIGHT" |  ///
							ir_jd3 == "SHEATH BLIGHT" | ir_jd4 == "SHEATH BLIGHT" |  ///
							ir_jd5 == "SHEATH BLIGHT" | ir_jd6 == "SHEATH BLIGHT" |  ///
							dr_jd1 == "SHEATH BLIGHT" | dr_jd2 == "SHEATH BLIGHT" |  ///
							dr_jd3 == "SHEATH BLIGHT" | dr_jd4 == "SHEATH BLIGHT"

	gen Tungro_jd = 1 if 	ir_jd1 == "TUNGRO" | ir_jd2 == "TUNGRO" |  ///
							ir_jd3 == "TUNGRO" | ir_jd4 == "TUNGRO" |  ///
							ir_jd5 == "TUNGRO" | ir_jd6 == "TUNGRO" |  ///
							dr_jd1 == "TUNGRO" | dr_jd2 == "TUNGRO" |  ///
							dr_jd3 == "TUNGRO" | dr_jd4 == "TUNGRO"

/*	
	Note: no need to replace 0 when there is no response to indicate that the farmer did not encounter the insect of disease
	
	replace AW_jd = 0 if AW_jd == .
	replace BBLIGHT_jd = 0 if BBLIGHT_jd == .
	replace Blast_jd = 0 if Blast_jd == .
	replace CW_jd = 0 if CW_jd == .
	replace Check_jd = 0 if Check_jd == .
	replace Drought_jd = 0 if Drought_jd == .
	replace GM_jd = 0 if GM_jd == .
	replace GAS_jd = 0 if GAS_jd == .
	replace LF_jd = 0 if LF_jd == .
	replace PH_jd = 0 if PH_jd == .
	replace Rat_jd = 0 if Rat_jd == .
	replace RBug_jd = 0 if RBug_jd == .
	replace Rodent_jd = 0 if Rodent_jd == .
	replace SR_jd = 0 if SR_jd == .
	replace SHGH_jd = 0 if SHGH_jd == .
	replace SB_jd = 0 if SB_jd == .
	replace SM_jd = 0 if SM_jd == .
	replace Thrips_jd = 0 if Thrips_jd == .
	replace BLS_jd = 0 if BLS_jd == .
	replace BS_jd = 0 if BS_jd == .
	replace GS_jd = 0 if GS_jd == .
	replace NB_jd = 0 if NB_jd == .
	replace RS_jd = 0 if RS_jd == .
	replace SBLIGHT_jd = 0 if SBLIGHT_jd == .
	replace SP_jd = 0 if SP_jd == .
	replace Tungro_jd = 0 if Tungro_jd == .
	
*/	

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
	
	label variable ir_jw1 "Insect (Wet Season - Response 1)" 
	label variable ir_jw2 "Insect (Wet Season - Response 2)" 
	label variable ir_jw3 "Insect (Wet Season - Response 3)" 
	label variable ir_jw4 "Insect (Wet Season - Response 4)" 
	label variable ir_jw5 "Insect (Wet Season - Response 5)" 
	label variable ir_jw6 "Insect (Wet Season - Response 6)" 
	label variable ir_jd1 "Insect (Dry Season - Response 1)" 
	label variable ir_jd2 "Insect (Dry Season - Response 2)" 
	label variable ir_jd3 "Insect (Dry Season - Response 3)" 
	label variable ir_jd4 "Insect (Dry Season - Response 4)" 
	label variable ir_jd5 "Insect (Dry Season - Response 5)" 
	label variable ir_jd6 "Insect (Dry Season - Response 6)" 
	label variable dr_jw1 "Disease (Wet Season - Response 1)" 
	label variable dr_jw2 "Disease (Wet Season - Response 2)" 
	label variable dr_jw3 "Disease (Wet Season - Response 3)" 
	label variable dr_jw4 "Disease (Wet Season - Response 4)" 
	label variable dr_jd1 "Disease (Dry Season - Response 1)" 
	label variable dr_jd2 "Disease (Dry Season - Response 2)" 
	label variable dr_jd3 "Disease (Dry Season - Response 3)" 
	label variable dr_jd4 "Disease (Dry Season - Response 4)" 
	
	label variable AW_jw "Armyworm  (WS)-insect"
	label variable BBLIGHT_jw "Bacterial Blight  (WS)-disease"
	label variable Blast_jw "Blast  (WS)-disease"
	label variable CW_jw "Caseworm  (WS)-insect"
	label variable Check_jw "Check  (WS)-"
	label variable Drought_jw "Drought  (WS)-"
	label variable GM_jw "Gall Midge  (WS)-insect"
	label variable GAS_jw "Golden Apple Snail  (WS)-insect"
	label variable LF_jw "Leaf Folder  (WS)-insect"
	label variable PH_jw "Planthopper  (WS)-insect"
	label variable Rat_jw "Rat  (WS)-insect"
	label variable RBug_jw "Rice Bug  (WS)-insect"
	label variable Rodent_jw "Rodent  (WS)-insect"
	label variable SR_jw "Sheath Rot  (WS)-disease"
	label variable SHGH_jw "Short-Horned Grasshopper  (WS)-insect"
	label variable SB_jw "Stem Borer  (WS)-insect"
	label variable SM_jw "Submergence  (WS)-"
	label variable Thrips_jw "Thrips  (WS)-insect"
	label variable BLS_jw "Bacterial Leaf Streak  (WS)-disease"
	label variable BS_jw "Brown Spot  (WS)-disease"
	label variable GS_jw "Grassy Stout  (WS)-disease"
	label variable NB_jw "Neck Blast  (WS)-disease"
	label variable RS_jw "Ragged Stunt  (WS)-disease"
	label variable SBLIGHT_jw "Sheath Blight  (WS)-disease"
	label variable Tungro_jw "Tungro  (WS)-disease"

	label variable AW_jd "Armyworm  (DS)-insect"
	label variable BBLIGHT_jd "Bacterial Blight  (DS)-disease"
	label variable Blast_jd "Blast  (DS)-disease"
	label variable CW_jd "Caseworm  (DS)-insect"
	label variable Check_jd "Check  (DS)-"
	label variable Drought_jd "Drought  (DS)-"
	label variable GM_jd "Gall Midge  (DS)-insect"
	label variable GAS_jd "Golden Apple Snail  (DS)-insect"
	label variable LF_jd "Leaf Folder  (DS)-insect"
	label variable PH_jd "Planthopper  (DS)-insect"
	label variable Rat_jd "Rat  (DS)-insect"
	label variable RBug_jd "Rice Bug  (DS)-insect"
	label variable Rodent_jd "Rodent  (DS)-insect"
	label variable SR_jd "Sheath Rot  (DS)-disease"
	label variable SHGH_jd "Short-Horned Grasshopper  (DS)-insect"
	label variable SB_jd "Stem Borer  (DS)-insect"
	label variable SM_jd "Submergence  (DS)-"
	label variable Thrips_jd "Thrips  (DS)-insect"
	label variable BLS_jd "Bacterial Leaf Streak  (DS)-disease"
	label variable BS_jd "Brown Spot  (DS)-disease"
	label variable GS_jd "Grassy Stout  (DS)-disease"
	label variable NB_jd "Neck Blast  (DS)-disease"
	label variable RS_jd "Ragged Stunt  (DS)-disease"
	label variable SBLIGHT_jd "Sheath Blight  (DS)-disease"
	label variable Tungro_jd "Tungro  (DS)-disease"


	
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
		label values 	AW_jw BBLIGHT_jw Blast_jw CW_jw Check_jw Drought_jw GM_jw GAS_jw LF_jw PH_jw Rat_jw RBug_jw Rodent_jw SR_jw SHGH_jw SB_jw SM_jw ///
						Thrips_jw BLS_jw BS_jw GS_jw NB_jw RS_jw SBLIGHT_jw Tungro_jw AW_jd BBLIGHT_jd Blast_jd CW_jd Check_jd Drought_jd GM_jd ///
						GAS_jd LF_jd PH_jd Rat_jd RBug_jd Rodent_jd SR_jd SHGH_jd SB_jd SM_jd Thrips_jd BLS_jd BS_jd GS_jd NB_jd RS_jd SBLIGHT_jd ///
						Tungro_jd yesno
		
	
* **********************************************************************
* 5 -	EXPECTED OUTPUT
* **********************************************************************

	/*
	Comment: 
	How do we verify if the stats are correct? Please add some commands(e.g., table, desc stat)
	Kindly return the data back to its original shape (wide with obs=156).
	*/

*Frequency and Percentage Distribution of Insects and Diseases Found in Replacement Varieties during Wet Season
	**************
	*PHKA RUMDOUL*
	**************
	summarize AW_jw-SM_jw if repvar_jw == "PHKA RUMDOUL"
	tab1 AW_jw-SM_jw if repvar_jw == "PHKA RUMDOUL"
	**************
	*   IR504    *
	**************
	summarize AW_jw-SM_jw if repvar_jw == "IR504"
	tab1 AW_jw-SM_jw if repvar_jw == "IR504"
	
*Frequency and Percentage Distribution of Insects and Diseases Found in Replacement Varieties during Dry Season
	**************
	*   IR504    *
	**************
	summarize AW_jd-SM_jd if repvar_jd == "IR504"
	tab1 AW_jd-SM_jd if repvar_jd == "IR504"
	**************
	*    IR85    *
	**************
	summarize AW_jd-SM_jd if repvar_jd == "IR85"
	tab1 AW_jd-SM_jd if repvar_jd == "IR85"
	
*Statistics Verification
	tab repvar_jw if repvar_jw == "PHKA RUMDOUL" | repvar_jw == "IR504"
	tab repvar_jd if repvar_jd == "IR504" | repvar_jd == "IR85"

		
*count the no. of farmers who encountered insects and/or diseases
tab dr_jw1
tab ir_jw1
tab dr_jd1
tab ir_jd1
		
* **********************************************************************
* 6 - OTHER MATTERS
* **********************************************************************

*Order variables in the dataset (Demographics, Repvar, Insects, Diseases, Others)
	order 	hhid session hh preyveng date morning market climate repvar_jw repvar_jd ///
			ir_jw1 ir_jw2 ir_jw3 ir_jw4 ir_jw5 ir_jw6 ///
			ir_jd1 ir_jd2 ir_jd3 ir_jd4 ir_jd5 ir_jd6 ///
			dr_jw1 dr_jw2 dr_jw3 dr_jw4 ///
			dr_jd1 dr_jd2 dr_jd3 dr_jd4 ///
			BBLIGHT_jw Blast_jw SR_jw BLS_jw BS_jw GS_jw NB_jw RS_jw SBLIGHT_jw Tungro_jw ///
			AW_jw CW_jw GM_jw GAS_jw LF_jw PH_jw Rat_jw RBug_jw Rodent_jw SHGH_jw SB_jw Thrips_jw ///
			Check_jw Drought_jw SM_jw ///
			BBLIGHT_jd Blast_jd SR_jd BLS_jd BS_jd GS_jd NB_jd RS_jd SBLIGHT_jd Tungro_jd ///
			AW_jd CW_jd GM_jd GAS_jd LF_jd PH_jd Rat_jd RBug_jd Rodent_jd SHGH_jd SB_jd Thrips_jd ///
			Check_jd Drought_jd SM_jd

* **********************************************************************
* 7 - PREPARING FOR EXPORT
* **********************************************************************

*Describe dataset
	compress	
	describe
	summarize 
	
*Save the dataset
	save "$output\0_IRDR_verde", replace
	
* **********************************************************************
* END OF CODE
* **********************************************************************


