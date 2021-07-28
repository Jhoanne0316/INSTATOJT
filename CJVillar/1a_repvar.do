* Project: Product Investment Portfolio for Replacement Varieties
* Stata v.16.0

* does
	*clean dataset
	*produces descriptive statistics

* to do:
	*Finalize label values: check whether they are correct
	*Finalize variable labels: check whether they are correct
	*Drop if consumption only, 
	
	
* **********************************************************************
* 0 - SETUP 
* **********************************************************************

*define directory paths
	
	global	root	=	"$data\raw"
	global	export	=	"$data\refined"
	
* ***********************************************************************
* 1 - PREPARING DATA
* ***********************************************************************

	* ******************************
	*  IMPORT
	* ******************************
	
	*Ma'am Jho
		*import excel "E:\Google Drive\jy_mrt_files\MRT - IGA\IGA - KH\Data analysis\IGA CAM - data\IGA CAM Data (working file).xlsx", 	sheet("repvar") firstrow
		
	*import - CJVillar
		*import excel "D:\Google Drive\IRRI\OJT Materials\03_raw_data\1a Data_specific HWJ and Season.xlsx", sheet("1a Data_specific HWJ and Season") firstrow
		
	*Save import
		*save "D:\Google Drive\IRRI\OJT Materials\04_syntax (1)\raw\1a_repvar.dta"
		
*load saved data
		use		"$root\1a_repvar", replace
	
	
* ***********************************************************************
* 2 - CLEANING THE DATA
* ***********************************************************************	

	*preyveng
	label define L_preyveng 1 "Prey Veng" 0 "Takeo"
	label values preyveng L_preyveng

	*clean morning
	label define L_morning 1 "Yes" 0 "No"
	label values morning L_morning 

	*market 
	label define L_market 1 "With market information" 0 "Otherwise"
	label values market L_market

	*climate
	label define L_climate 1 "With climate information" 0 "Otherwise"
	label values climate L_climate

*Cons - constraint or crop disposal?

	*define label for crop disposal
	label define L_cons 1 "Consumption only" 2 "Selling only" 3 "Both for consumption and selling" 

	*destring cons
	destring cons_hw, replace
	destring cons_ww, replace
	destring cons_jw, replace
	destring cons_hd, replace
	destring cons_wd, replace
	destring cons_jd, replace

	*label cons
	label values cons_hw L_cons
	label values cons_ww L_cons
	label values cons_jw L_cons
	label values cons_hd L_cons
	label values cons_wd L_cons
	label values cons_jd L_cons
	
*Grow

	*define label for grow: 1 -past 2 -present 3-never
	label define L_grow 1 "Past" 2 "Present" 3 "Never"

	*destring grow
	destring grow_hw, replace
	destring grow_ww, replace
	destring grow_jw, replace
	destring grow_hd, replace
	destring grow_wd, replace
	destring grow_jd, replace


	*label grow 
	label values grow_hw L_grow
	label values grow_ww L_grow
	label values grow_jw L_grow
	label values grow_hd L_grow
	label values grow_wd L_grow
	label values grow_jd L_grow
	
*******************************
*    sample size    
*******************************
	*generating session
	gen H=1
	gen W=1
	gen J=1

	replace H=0 if slinv_hw==.
	replace W=0 if slinv_ww==.
	replace J=0 if slinv_jw==.

	*generating treament variables
	gen     trmt=1 if  market==1
	replace trmt=2 if  climate==1
	replace trmt=3 if  market==1 & climate==1
	replace trmt=0 if  market==0 & climate==0

	tab trmt market
	tab trmt climate
	tab trmt 

	*by location
	tab preyveng H
	tab preyveng W
	tab preyveng J

	*by Session
	tab morning H
	tab morning W
	tab morning J

	*by treatment
	tab trmt H
	tab trmt W
	tab trmt J

	*******************************
	*    replacement variety   (joint session)
	*******************************
	*data cleaning - checking the consistency of the rep var names
	tab repvar_jw if repvar_jw!="."
	tab repvar_jd if repvar_jd!="."

	**result: rep var names are consistent

	/*replacement variety for WS
		Phka Rumduol - n= 54 (38%)
		IR504        - n= 53 (37%)
	  replacement variety for WS
		IR504        - n= 99 (70%)
		IR85         - n= 19 (13%)
	*/

* ***********************************************************************
* 4 - EXPECTED OUTPUT
* ***********************************************************************	

	********************************************************
	* 	Type of disposal frequency and percentages 
	********************************************************
	tab cons_hw
	tab cons_ww
	tab cons_hd
	tab cons_wd
	tab cons_jd
	
	
	********************************************************
	* 	Percentages of replacement variety 
	********************************************************
	tab repvar_hw
	tab repvar_ww
	tab repvar_jw
	tab repvar_hd
	tab repvar_wd
	tab repvar_jd	

	********************************************************
	* Objective 2: Product investment portfolio of relacement varieties 
	*              (Joint session) for WS and DS 
	********************************************************
	*investment shares for WS, joint session
	summarize slinv_jw- sdinv_jw if repvar_jw=="PHKA RUMDOUL"
	summarize slinv_jw- sdinv_jw if repvar_jw=="IR504"

	*investment shares for DS, joint session
	summarize slinv_jd- sdinv_jd if repvar_jd=="IR504"
	summarize slinv_jd- sdinv_jd if repvar_jd=="IR85"

	********************************************************
	* Objective 2: Product investment portfolio of relacement varieties 
	*              (husband session) for WS and DS 
	********************************************************
	*investment shares for WS, husband session
	summarize slinv_hw- sdinv_hw if repvar_hw=="PHKA RUMDOUL"
	summarize slinv_hw- sdinv_hw if repvar_hw=="IR504"

	*investment shares for DS, husband session
	summarize slinv_hd- sdinv_hd if repvar_hd=="IR504"
	summarize slinv_hd- sdinv_hd if repvar_hd=="IR85"

	********************************************************
	* Objective 2: Product investment portfolio of relacement varieties 
	*              (wife session) for WS and DS 
	********************************************************
	*investment shares for WS, wife session
	summarize slinv_ww- sdinv_ww if repvar_ww=="PHKA RUMDOUL"
	summarize slinv_ww- sdinv_ww if repvar_ww=="IR504"

	*investment shares for DS, husband session
	summarize slinv_wd- sdinv_wd if repvar_wd=="IR504"
	summarize slinv_wd- sdinv_wd if repvar_wd=="IR85"
	

	
* **********************************************************************
* 5 - OTHER MATTERS
* **********************************************************************

* keep what we want, get rid of what we don't

	
*Arrange all the variables in the data with specific order" 


	
*labelling variables
label variable session "Session"
label variable hh "Household no."
label variable hhid "Unique Household ID"
label variable preyveng "Location"
label variable date "Date of Interview"
label variable morning "Session time"
label variable market "Market Information"
label variable climate "Climate Information"
label variable slinv_hw "Investment shares for Slenderness during Wet Season (Husband)"
label variable uninv_hw "Investment shares for Unstickiness during Wet Season (Husband)"
label variable arinv_hw "Investment shares for Aroma during Wet Season (Husband)"
label variable hrinv_hw "Investment shares for Head Rice Recovery during Wet Season (Husband)"
label variable ltinv_hw "Investment shares for Lodging Tolerance during Wet Season (Husband)"
label variable drinv_hw "Investment shares for Disease Resistance during Wet Season (Husband)"
label variable irinv_hw "Investment shares for Insect Resistance during Wet Season (Husband)"
label variable atinv_hw "Investment shares for Abiotic Stress Tolerance during Wet Season (Husband)"
label variable rsinv_hw "Investment shares for Reduction to Shattering during Wet Season (Husband)"
label variable eainv_hw "Investment shares for Earliness during Wet Season (Husband)"
label variable sdinv_hw "Investment shares for Straw Digestibility during Wet Season (Husband)"
label variable slinv_ww "Investment shares for Slenderness during Wet Season (Wife)"
label variable uninv_ww "Investment shares for Unstickiness during Wet Season (Wife)"
label variable arinv_ww "Investment shares for Aroma during Wet Season (Wife)"
label variable hrinv_ww "Investment shares for Head Rice Recovery during Wet Season (Wife)"
label variable ltinv_ww "Investment shares for Lodging Tolerance during Wet Season (Wife)"
label variable drinv_ww "Investment shares for Disease Resistance during Wet Season (Wife)"
label variable irinv_ww "Investment shares for Insect Resistance during Wet Season (Wife)"
label variable atinv_ww "Investment shares for Abiotic Stress Tolerance during Wet Season (Wife)"
label variable rsinv_ww "Investment shares for Reduction to Shattering during Wet Season (Wife)"
label variable eainv_ww "Investment shares for Earliness during Wet Season (Wife)"
label variable sdinv_ww "Investment shares for Straw Digestibility during Wet Season (Wife)"
label variable slinv_jw "Investment shares for Slenderness during Wet Season (Joint)"
label variable uninv_jw "Investment shares for Unstickiness during Wet Season (Joint)"
label variable arinv_jw "Investment shares for Aroma during Wet Season (Joint)"
label variable hrinv_jw "Investment shares for Head Rice Recovery during Wet Season (Joint)"
label variable ltinv_jw "Investment shares for Lodging Tolerance during Wet Season (Joint)"
label variable drinv_jw "Investment shares for Disease Resistance during Wet Season (Joint)"
label variable irinv_jw "Investment shares for Insect Resistance during Wet Season (Joint)"
label variable atinv_jw "Investment shares for Abiotic Stress Tolerance during Wet Season (Joint)"
label variable rsinv_jw "Investment shares for Reduction to Shattering during Wet Season (Joint)"
label variable eainv_jw "Investment shares for Earliness during Wet Season (Joint)"
label variable sdinv_jw "Investment shares for Straw Digestibility during Wet Season (Joint)"
label variable slinv_hd "Investment shares for Slenderness during Dry Season (Husband)"
label variable uninv_hd "Investment shares for Unstickiness during Dry Season (Husband)"
label variable arinv_hd "Investment shares for Aroma during Dry Season (Husband)"
label variable hrinv_hd "Investment shares for Head Rice Recovery during Dry Season (Husband)"
label variable ltinv_hd "Investment shares for Lodging Tolerance during Dry Season (Husband)"
label variable drinv_hd "Investment shares for Disease Resistance during Dry Season (Husband)"
label variable irinv_hd "Investment shares for Insect Resistance during Dry Season (Husband)"
label variable atinv_hd "Investment shares for Abiotic Stress Tolerance during Dry Season (Husband)"
label variable rsinv_hd "Investment shares for Reduction to Shattering during Dry Season (Husband)"
label variable eainv_hd "Investment shares for Earliness during Dry Season (Husband)"
label variable sdinv_hd "Investment shares for Straw Digestibility during Dry Season (Husband)"
label variable slinv_wd "Investment shares for Slenderness during Dry Season (Wife)"
label variable uninv_wd "Investment shares for Unstickiness during Dry Season (Wife)"
label variable arinv_wd "Investment shares for Aroma during Dry Season (Wife)"
label variable hrinv_wd "Investment shares for Head Rice Recovery during Dry Season (Wife)"
label variable ltinv_wd "Investment shares for Lodging Tolerance during Dry Season (Wife)"
label variable drinv_wd "Investment shares for Disease Resistance during Dry Season (Wife)"
label variable irinv_wd "Investment shares for Insect Resistance during Dry Season (Wife)"
label variable atinv_wd "Investment shares for Abiotic Stress Tolerance during Dry Season (Wife)"
label variable rsinv_wd "Investment shares for Reduction to Shattering during Dry Season (Wife)"
label variable eainv_wd "Investment shares for Earliness during Dry Season (Wife)"
label variable sdinv_wd "Investment shares for Straw Digestibility during Dry Season (Wife)"
label variable slinv_jd "Investment shares for Slenderness during Dry Season (Joint)"
label variable uninv_jd "Investment shares for Unstickiness during Dry Season (Joint)"
label variable arinv_jd "Investment shares for Aroma during Dry Season (Joint)"
label variable hrinv_jd "Investment shares for Head Rice Recovery during Dry Season (Joint)"
label variable ltinv_jd "Investment shares for Lodging Tolerance during Dry Season (Joint)"
label variable drinv_jd "Investment shares for Disease Resistance during Dry Season (Joint)"
label variable irinv_jd "Investment shares for Insect Resistance during Dry Season (Joint)"
label variable atinv_jd "Investment shares for Abiotic Stress Tolerance during Dry Season (Joint)"
label variable rsinv_jd "Investment shares for Reduction to Shattering during Dry Season (Joint)"
label variable eainv_jd "Investment shares for Earliness during Dry Season (Joint)"
label variable sdinv_jd "Investment shares for Straw Digestibility during Dry Season (Joint)"
label variable repvar_hw "Replacement Variety for Wet Season (Husband)"
label variable repvar_ww "Replacement Variety for Wet Season (Wife)"
label variable repvar_jw "Replacement Variety for Wet Season (Joint)"
label variable repvar_hd "Replacement Variety for Dry  Season (Husband)"
label variable repvar_wd "Replacement Variety for Dry  Season (Wife)"
label variable repvar_jd "Replacement Variety for Dry  Season (Joint)"
label variable cons_hw "Disposal during Wet Season (Husband)"
label variable cons_ww "Disposal during Wet Season (Wife)"
label variable cons_jw "Disposal during Wet Season (Joint)"
label variable cons_hd "Disposal during Dry Season (Husband)"
label variable cons_wd "Disposal during Dry Season (Wife)"
label variable cons_jd "Disposal during Dry Season (Joint)"
label variable grow_hw "When it was Grown by the Husband during Wet Season"
label variable grow_ww "When it was Grown by the Wife during Wet Season"
label variable grow_jw "When it was Grown by Joint during Wet Season"
label variable grow_hd "When it was Grown by the Husband during Dry Season"
label variable grow_wd "When it was Grown by the Wife during Dry Season"
label variable grow_jd "When it was Grown by Joint during Dry Season"
label variable remarks "Remarks"
label variable traitsno_hw "Number of Traits Invested of Husband during Wet Season"
label variable traitsno_ww "Number of Traits Invested of Wife during Wet Season"
label variable traitsno_jw "Number of Traits Invested of Joint during Wet Season"
label variable traitsno_hd "Number of Traits Invested of Husband during Dry Season"
label variable traitsno_wd "Number of Traits Invested of Wife during Dry Season"
label variable traitsno_jd "Number of Traits Invested of Joint during Dry Season"
label variable totinv_hw "Percent Invested of Husband during Wet Season"
label variable totinv_ww "Percent Invested of Wife during Wet Season"
label variable totinv_jw "Percent Invested of Joint during Wet Season"
label variable totinv_hd "Percent Invested of Husband during Dry Season"
label variable totinv_wd "Percent Invested of Wife during Dry Season"
label variable totinv_jd "Percent Invested of Joint during Dry Season"
label variable dret_hw "Deterministic Return of Husband during Wet Season"
label variable dret_ww "Deterministic Return  of Wife during Wet Season"
label variable dret_jw "Deterministic Return of Joint during Wet Season"
label variable dret_hd "Deterministic Return of Husband during Dry Season"
label variable dret_wd "Deterministic Return  of Wife during Dry Season"
label variable dret_jd "Deterministic Return  of Joint during Dry Season"

* **********************************************************************
* 6 - PREPARING FOR EXPORT
* **********************************************************************

*Identify and report duplicates with  categories*
	sort session hh hhid 
	unique session hh hhid 
	duplicates report session hh hhid 

*Drop duplicate observations to avoid double-counting of varieties planted per household
	duplicates drop session hh hhid, force

*Check whether these variables uniquely identify the observations*
	isid session hh hhid 
	
*Describe dataset
	compress
	describe
	summarize 
	
*Saving the dataset	
	save "$export/1a_repvar_final", replace

/* END */
