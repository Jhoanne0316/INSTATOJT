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
	label variable hh "Household ID per session"
	label variable hhid "Unique Household ID"
	label variable preyveng "Province"
	label variable date "Date"
	label variable morning "Morning Session"
	label variable market "Market Information"
	label variable climate "Climate Information"
	
	*For wide data
	label variable slinv_hw "Investment shares for Slenderness (Husband - Wet Season)"
	label variable uninv_hw "Investment shares for Unstickiness (Husband - Wet Season)"
	label variable arinv_hw "Investment shares for Aroma (Husband - Wet Season)"
	label variable hrinv_hw "Investment shares for Head Rice Recovery (Husband - Wet Season)"
	label variable ltinv_hw "Investment shares for Lodging Tolerance (Husband - Wet Season)"
	label variable drinv_hw "Investment shares for Disease Resistance (Husband - Wet Season)"
	label variable irinv_hw "Investment shares for Insect Resistance (Husband - Wet Season)"
	label variable atinv_hw "Investment shares for Abiotic Stress Tolerance (Husband - Wet Season)"
	label variable rsinv_hw "Investment shares for Reduction to Shattering (Husband - Wet Season)"
	label variable eainv_hw "Investment shares for Earliness (Husband - Wet Season)"
	label variable sdinv_hw "Investment shares for Straw Digestibility (Husband - Wet Season)"
	
	label variable slinv_ww "Investment shares for Slenderness (Wife - Wet Season)"
	label variable uninv_ww "Investment shares for Unstickiness (Wife - Wet Season)"
	label variable arinv_ww "Investment shares for Aroma (Wife - Wet Season)"
	label variable hrinv_ww "Investment shares for Head Rice Recovery (Wife - Wet Season)"
	label variable ltinv_ww "Investment shares for Lodging Tolerance (Wife - Wet Season)"
	label variable drinv_ww "Investment shares for Disease Resistance (Wife - Wet Season)"
	label variable irinv_ww "Investment shares for Insect Resistance (Wife - Wet Season)"
	label variable atinv_ww "Investment shares for Abiotic Stress Tolerance (Wife - Wet Season)"
	label variable rsinv_ww "Investment shares for Reduction to Shattering (Wife - Wet Season)"
	label variable eainv_ww "Investment shares for Earliness (Wife - Wet Season)"
	label variable sdinv_ww "Investment shares for Straw Digestibility (Wife - Wet Season)"
	
	label variable slinv_jw "Investment shares for Slenderness (Joint - Wet Season)"
	label variable uninv_jw "Investment shares for Unstickiness (Joint - Wet Season)"
	label variable arinv_jw "Investment shares for Aroma (Joint - Wet Season)"
	label variable hrinv_jw "Investment shares for Head Rice Recovery (Joint - Wet Season)"
	label variable ltinv_jw "Investment shares for Lodging Tolerance (Joint - Wet Season)"
	label variable drinv_jw "Investment shares for Disease Resistance (Joint - Wet Season)"
	label variable irinv_jw "Investment shares for Insect Resistance (Joint - Wet Season)"
	label variable atinv_jw "Investment shares for Abiotic Stress Tolerance (Joint - Wet Season)"
	label variable rsinv_jw "Investment shares for Reduction to Shattering (Joint - Wet Season)"
	label variable eainv_jw "Investment shares for Earliness (Joint - Wet Season)"
	label variable sdinv_jw "Investment shares for Straw Digestibility (Joint - Wet Season)"
	
	label variable slinv_hd "Investment shares for Slenderness (Husband - Dry Season)"
	label variable uninv_hd "Investment shares for Unstickiness (Husband - Dry Season)"
	label variable arinv_hd "Investment shares for Aroma (Husband - Dry Season)"
	label variable hrinv_hd "Investment shares for Head Rice Recovery (Husband - Dry Season)"
	label variable ltinv_hd "Investment shares for Lodging Tolerance (Husband - Dry Season)"
	label variable drinv_hd "Investment shares for Disease Resistance (Husband - Dry Season)"
	label variable irinv_hd "Investment shares for Insect Resistance (Husband - Dry Season)"
	label variable atinv_hd "Investment shares for Abiotic Stress Tolerance (Husband - Dry Season)"
	label variable rsinv_hd "Investment shares for Reduction to Shattering (Husband - Dry Season)"
	label variable eainv_hd "Investment shares for Earliness (Husband - Dry Season)"
	label variable sdinv_hd "Investment shares for Straw Digestibility (Husband - Dry Season)"
	
	label variable slinv_wd "Investment shares for Slenderness (Wife - Dry Season)"
	label variable uninv_wd "Investment shares for Unstickiness (Wife - Dry Season)"
	label variable arinv_wd "Investment shares for Aroma (Wife - Dry Season)"
	label variable hrinv_wd "Investment shares for Head Rice Recovery (Wife - Dry Season)"
	label variable ltinv_wd "Investment shares for Lodging Tolerance (Wife - Dry Season)"
	label variable drinv_wd "Investment shares for Disease Resistance (Wife - Dry Season)"
	label variable irinv_wd "Investment shares for Insect Resistance (Wife - Dry Season)"
	label variable atinv_wd "Investment shares for Abiotic Stress Tolerance (Wife - Dry Season)"
	label variable rsinv_wd "Investment shares for Reduction to Shattering (Wife - Dry Season)"
	label variable eainv_wd "Investment shares for Earliness (Wife - Dry Season)"
	label variable sdinv_wd "Investment shares for Straw Digestibility (Wife - Dry Season)"
	
	label variable slinv_jd "Investment shares for Slenderness (Joint - Dry Season)"
	label variable uninv_jd "Investment shares for Unstickiness (Joint - Dry Season)"
	label variable arinv_jd "Investment shares for Aroma (Joint - Dry Season)"
	label variable hrinv_jd "Investment shares for Head Rice Recovery (Joint - Dry Season)"
	label variable ltinv_jd "Investment shares for Lodging Tolerance (Joint - Dry Season)"
	label variable drinv_jd "Investment shares for Disease Resistance (Joint - Dry Season)"
	label variable irinv_jd "Investment shares for Insect Resistance (Joint - Dry Season)"
	label variable atinv_jd "Investment shares for Abiotic Stress Tolerance (Joint - Dry Season)"
	label variable rsinv_jd "Investment shares for Reduction to Shattering (Joint - Dry Season)"
	label variable eainv_jd "Investment shares for Earliness (Joint - Dry Season)"
	label variable sdinv_jd "Investment shares for Straw Digestibility (Joint - Dry Season)"
	
	label variable repvar_hw "Replacement Variety (Husband - Wet Season)"
	label variable repvar_ww "Replacement Variety (Wife - Wet Season)"
	label variable repvar_jw "Replacement Variety (Joint - Wet Season)"
	label variable repvar_hd "Replacement Variety (Husband - Dry Season)"
	label variable repvar_wd "Replacement Variety (Wife - Dry Season)"
	label variable repvar_jd "Replacement Variety (Joint - Dry Season)"
	
	label variable cons_hw "Disposal (Husband - Wet Season)"
	label variable cons_ww "Disposal (Wife - Wet Season)"
	label variable cons_jw "Disposal (Joint - Wet Season)"
	label variable cons_hd "Disposal (Husband - Dry Season)"
	label variable cons_wd "Disposal (Wife - Dry Season)"
	label variable cons_jd "Disposal (Joint - Dry Season)"
	
	label variable grow_hw "When it was Grown (Husband - Wet Season)"
	label variable grow_ww "When it was Grown (Wife - Wet Season)"
	label variable grow_jw "When it was Grown (Joint - Wet Season)"
	label variable grow_hd "When it was Grown (Husband - Dry Season)"
	label variable grow_wd "When it was Grown (Wife - Dry Season)"
	label variable grow_jd "When it was Grown (Joint - Dry Season)"
	
	label variable remarks "Remarks"
	
	label variable traitsno_hw "Number of Traits Invested (Husband - Wet Season)"
	label variable traitsno_ww "Number of Traits Invested (Wife - Wet Season)"
	label variable traitsno_jw "Number of Traits Invested (Joint - Wet Season)"
	label variable traitsno_hd "Number of Traits Invested (Husband - Dry Season)"
	label variable traitsno_wd "Number of Traits Invested (Wife - Dry Season)"
	label variable traitsno_jd "Number of Traits Invested (Joint - Dry Season)"
	
	label variable totinv_hw "Percent invested (Husband - Wet Season)"
	label variable totinv_ww "Percent invested (Wife - Wet Season)"
	label variable totinv_jw "Percent invested (Joint - Wet Season)"
	label variable totinv_hd "Percent invested (Husband - Dry Season)"
	label variable totinv_wd "Percent invested (Wife - Dry Season)"
	label variable totinv_jd "Percent invested (Joint - Dry Season)"
	
	label variable dret_hw "Deterministic return (Husband - Wet Season)"
	label variable dret_ww "Deterministic return (Wife - Wet Season)"
	label variable dret_jw "Deterministic return (Joint - Wet Season)"
	label variable dret_hd "Deterministic return (Husband - Dry Season)"
	label variable dret_wd "Deterministic return (Wife - Dry Season)"
	label variable dret_jd "Deterministic return (Joint - Dry Season)"
	
	/* For long data
	label variable resp "Respondent and Season"
	
	label variable slinv "Investment shares for Slenderness"
	label variable uninv "Investment shares for Unstickiness"
	label variable arinv "Investment shares for Aroma"
	label variable hrinv "Investment shares for Head Rice Recovery"
	label variable ltinv "Investment shares for Lodging Tolerance"
	label variable drinv "Investment shares for Disease Resistance"
	label variable irinv "Investment shares for Insect Resistance"
	label variable atinv "Investment shares for Abiotic Stress Tolerance"
	label variable rsinv "Investment shares for Reduction to Shattering"
	label variable eainv "Investment shares for Earliness"
	label variable sdinv "Investment shares for Straw Digestibility"
	
	label variable remarks "Remarks"
	
	label variable repvar "Replacement Variety"
	label variable cons "Disposal"
	label variable grow "When it was Grown"
	
	label variable traitsno "Number of Traits Invested"
	label variable totinv "Percent invested"
	label variable dret "Deterministic return"
	*/

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
