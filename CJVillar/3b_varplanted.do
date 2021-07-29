* Project: Variety Area Share
* Stata v.16.0

* does
	*clean dataset
	*produces descriptive statistics

* to do:
	*Identify hhid for outliers and other flagged values 
	*Add summary statistics for other variables (percentages for buyers)
	
	
	
* **********************************************************************
* 0 - SETUP 
* **********************************************************************
	clear all 
	
*define directory paths

	*CJVillar

	global	root	=	"$data\raw"
	global	export	=	"$data\refined"

* ***********************************************************************
* 1 - PREPARING DATA
* ***********************************************************************
	
	
	*import- Ma'am Jho
		*import excel "E:\Google Drive\jy_mrt_files\MRT - IGA\IGA - KH\Data analysis\IGA CAM - data\IGA CAM Data (working file).xlsx", 		sheet("varplanted_data") firstrow
		
	*import - CJVillar
		*import excel "$data\CJVillar\raw\3b Data_joinby hhid season2.xlsx", sheet("3b Data_joinby hhid season2") firstrow
	
	*Save import
		*save "$root\3b_varplanted", replace
	
	*load saved data
	
		use	"$root\3b_varplanted", replace
	
* ***********************************************************************
* 2 - CLEANING THE DATA
* ***********************************************************************

* convert variable names to lower cases
	rename 				_all, lower	
	
* renaming variables
	rename id resid

*clean variety

	replace variety="ANGKORNG" if variety=="ANGKORNG"
	replace variety="BANLAPDAV" if variety=="BANLAPDAV"
	replace variety="CAR15" if variety=="CAR 15"
	replace variety="CAR8" if variety=="CAR8"
	replace variety="IR" if variety=="IR OM"
	replace variety="IR" if variety=="IR(100 DAY)"
	replace variety="IR504" if variety=="IR504"
	replace variety="IR66" if variety=="IR66"
	replace variety="IR85" if variety=="IR85"
	replace variety="CAR15" if variety=="KHA 15"
	replace variety="KON CHEN" if variety=="KON CHEN"
	replace variety="KON SROVE" if variety=="KON SROV"
	replace variety="IR85" if variety=="KORMOM YOUN"
	replace variety="KRO SANG TEP" if variety=="KRO SANG TEP"
	replace variety="KROM HORM" if variety=="KROM HORM"
	replace variety="NEANG MENH" if variety=="NEANG MENH"
	replace variety="OM" if variety=="O.M."
	replace variety="OM" if variety=="O.M.42-18"
	replace variety="PHKA RUMDOUL" if variety=="PHAS ROMDUL"
	replace variety="PHKA KHNEI" if variety=="PHKA KHEI"
	replace variety="PHKA KHNEI" if variety=="PHKA KHIE"
	replace variety="PHKA KHNEI" if variety=="PHKA KHNEI"
	replace variety="PHKA KHNEI" if variety=="PHKA KHNIA"
	replace variety="PHKA RUMDOUL" if variety=="PHKA RUMDOUL"
	replace variety="PHKA KHNEI" if variety=="PHOR KHEI"
	replace variety="PHKA RUMDOUL" if variety=="PHOR ROMDUL"
	replace variety="PHKA KHNEI" if variety=="PKHA KHNEI"
	replace variety="PHKA KHNEI" if variety=="PKHKA KHNEI"
	replace variety="RANGCHEY" if variety=="RANG CHEY"
	replace variety="RANGCHEY" if variety=="REANY CHY"
	replace variety="SEN PIDAO" if variety=="SEAM PIDOR"
	replace variety="SEN KRA OB" if variety=="SEN KRA OB"
	replace variety="SEN PIDAO" if variety=="SEN PIDAO"
	replace variety="SOMALI" if variety=="SOMALY"

*season value label 
	label define L_season 1 "Early Wet" 2 "Wet" 3 "Dry"
	label values season L_season
	
	*Generate season2 for only two groups
		tab season
		gen season2=.
		replace season2=1 if season==1 /*Early WS to WS*/
		replace season2=1 if season==2 /*WS*/
		replace season2=2 if season==3 /*DS*/
		
		*season2 value label 
		label define L_season2 1 "Wet Season" 2 "Dry Season"
		label values season2 L_season2
		
		*checker
		tab season season2

*year value label 
	label define L_year 1 "2016" 2 "2017"
	label values year L_year

*method
	tab method
	
	destring method, replace
	label define L_method 1 "Transplanted" 2 "Dry direct seeded" 3 "Wet direct seeded" 4 "Others"
	label values method L_method
	
*Source seed
	
	*view/tabulate values 
	tab source_seed

	*Note possible typographical error 
	note source_seed: values listed with respect with respect to hhid are possible errors since these answers pertains to 	variable seedtype
	
	*list possible errors
	list hhid source_seed if source_seed == "AGRI COOP", divider
	list hhid source_seed if source_seed == "COMMUNITY SEED" , divider
	list hhid source_seed if source_seed == "VIETNAMESE" , divider
	list hhid source_seed if source_seed == "30" , divider

	*replace values
	replace source_seed = "90" if source_seed  == "AGRI COOP"
	replace source_seed = "90" if source_seed  == "COMMUNITY SEED"
	replace source_seed = "90" if source_seed  == "VIETNAMESE"
	replace source_seed = "90" if source_seed  == "30"
	replace source_seed = "." if source_seed  == "-"

	*destring
	destring source_seed, replace
	
	*label define
	label define L_source_seed 1 "Own harvest" 2 "Neighbour" 3 "Trader" 4 "Input dealer" 5 "Government" 6 "Private seed grower" 90 "Others"
	
	*label value
	label values source_seed L_source_seed
			
*Seed type 

	*view/tabulate values 
	tab seedtype,m
	
	*Possible error of values in seedtype
		note seedtype: values listed  with respect to hhid are possible errors since these answers pertains to 	variable source_seed
		 
	*list possible errors
	list seedtype hhid if seedtype ==  "FROM VIETNAM"
	list seedtype hhid if seedtype ==  "GOVT"
	list seedtype hhid if seedtype ==  "INPUT DEALER"
	list seedtype hhid if seedtype ==  "NEIGHBOR"
	list seedtype hhid if seedtype ==  "TRADER"
	

	*Check values of seed type
	replace seedtype = "." if missing(seedtype) 
	replace seedtype = "." in 28
	replace seedtype = "." if seedtype == "?"
	replace seedtype = "4" if seedtype == "COMMUNITY SEED" /*community seed banking produces good seeds*/
	replace seedtype = "90" if seedtype ==  "BUY"
	replace seedtype = "90" if seedtype ==  "DON'T KNOW"
	replace seedtype = "90" if seedtype ==  "FROM VIETNAM"
	replace seedtype = "90" if seedtype ==  "GOVT"
	replace seedtype = "90" if seedtype ==  "INPUT DEALER"
	replace seedtype = "90" if seedtype ==  "NEIGHBOR"
	replace seedtype = "90" if seedtype ==  "TRADER"
	replace seedtype = "5" if seedtype ==  "OWN HARVEST" /*Considered own harvest as farmer's seed*/

	*destring
	destring seedtype, replace
		
	*label define
	label define L_seedtype 1 "Foundation Seed" 2 "Registered seed" 3 "Certified seed" 4 "Good seed" 5 "Farmer's seed" 90 "Others"
		
	*label values
	label values seedtype L_seedtype

*Buyer/s

	*view/tabulate value of buyers
	tab buyers, m
	
	*replace 
	replace buyers = "8" if buyers =="AGRI COOP"
	replace buyers = "." if missing(buyers)
	
	*destring
	destring buyers, replace 
	
	*Label define
	label define L_buyers 	1 "Village shop/retailer" 2 "Wholesale" 3 "Middleman/broker" 4 "Money lender" 5 "Input supplier"6 "Miller" 7 	  	"Neighbour" 8 "Co-farmer" 9 "Trader" 10 "Livestock owner/farmer" 11 "Dairy farmer"  90 "Others"
	
	*label buyers
	label values buyers L_buyers

*Reason

	*view/tabulate value of reason
	tab reason, m
	
	*list possible errors
	list hhid reason if reason== "720"
	list hhid reason if reason == "770"
	list hhid reason if reason == "820"
	list hhid reason if reason == "0"
	
	*replace reason
	replace reason = "." if missing(reason)
	replace reason = "." if reason == "-"
	replace reason = "90" if reason == "FOR SEED"
	replace reason = "90" if reason == "NO OTHER BUYER, ONLY TRADER FROM VIETNAM"
	replace reason = "90" if reason == "720"
	replace reason = "90" if reason == "770"
	replace reason = "90" if reason == "820"
	replace reason = "90" if reason == "0"
	
	
	*Multiple Responses 
	split reason, parse(,) destring gen(reasons)
	gen id = _n
	
	tab reason
	tab reasons1 
	tab reasons2
	tab reasons3
	
	*label define
	label define L_reason 1 "Known for long time" 2 "Contract production" 3 "Provides inputs/credit" 4 "Short distance" 5 "Convenient to sell" 6 "Come to house" 7 "Can sell even small quantity" 8 "Receive a good price" 9 "No time and space to dry rice" 10 "No enough warehouse to store rice" 90 "Others"
	
	*label reasons
	label values reasons1-reasons3 L_reason
	
	*reshape reasons to long by id
	reshape long reasons, i(id) j(rea)
	
	*drop old reason and other generated variables
	drop rea reason id
	
	*Notes:
	note reasons: What to do with missing reasons?	
	note reasons: values listed with respect to hhid are possible errors since these answers pertains are no under in any category according to the IGA manual

	/*In case reshaping to wide is needed by reasons*/
	*Reshape to wide	
	gen act = 1
	reshape wide rea, i(id) j(reason)
	
	/*
	
	JY comment:
	 output of reshape to wide : variable reasons contains missing values
	 There is a need to return the data in its original shape with 605 cases. 
	
	*/
	
*Price

	*view/tabulate values of price
	tab price
	
	*replace
	replace price = "." if missing(price)
	
	*destring
	destring price, replace 
	
*Distance in km

	*view/tabulate values of distance_km
	tab distance_km
	
	*replace
	replace distance_km = "." if missing(distance_km)
	
	*destring
	destring distance_km, replace 
	
* **********************************************************************
* 3. EDITING BASED ON VALUES FROM OTHER VARIABLES 
		/* STEPS:
		1. check consistency with hh_data total land area
		2. replace area planted
		3. recompute Conv_area
		*/
* **********************************************************************

**check consistency with hh_data total land area
edit session hh hhid variety areaplanted areaunit conv_area if areaplanted>10

/*data cleaning: replace area planted */
	replace areaplanted=0.8  if session==1  & hh==5 & hhid==5     & variety=="SEN KRA OB"
	replace areaplanted=0.8  if session==1  & hh==5 & hhid==5     & variety=="IR504"
	replace areaplanted=0.25  if session==1  & hh==5 & hhid==5    & variety=="PHKA RUMDOUL"
	replace areaplanted=0.6  if session==2  & hh==5 & hhid==15    & variety=="IR504"
	replace areaplanted=0.6  if session==2  & hh==5 & hhid==15    & variety=="CAR15"
	replace areaplanted=0.7  if session==3  & hh==1 & hhid==21    & variety=="SEN PIDAO"
	replace areaplanted=1.55 if session==3  & hh==3 & hhid==23    & variety=="IR504"
	replace areaplanted=0.6  if session==5  & hh==3 & hhid==42    & variety=="IR504"
	replace areaplanted=0.6  if session==6  & hh==4 & hhid==53    & variety=="IR504"
	replace areaplanted=0.9  if session==9  & hh==4 & hhid==81    & variety=="PHKA KHNEI"
	replace areaplanted=0.6  if session==9  & hh==10 & hhid==86   & variety=="PHKA RUMDOUL"
	replace areaplanted=0.6  if session==9  & hh==10 & hhid==86   & variety=="SOMALI"
	replace areaplanted=0.3  if session==10  & hh==3 & hhid==89   & variety=="IR504"
	replace areaplanted=0.8  if session==13  & hh==6 & hhid==121  & variety=="PHKA RUMDOUL"
	replace areaplanted=0.8  if session==13  & hh==6 & hhid==121  & variety=="IR504"
	replace areaplanted=0.6  if session==13  & hh==11 & hhid==126 & variety=="KON CHEN"

	replace areaunit=4   if session==1   & hh==5  & hhid==5
	replace areaunit=4   if session==2   & hh==5  & hhid==15
	replace areaunit=4   if session==3   & hh==1  & hhid==21
	replace areaunit=4   if session==3   & hh==3  & hhid==23
	replace areaunit=4   if session==5   & hh==3  & hhid==42
	replace areaunit=4   if session==6   & hh==4  & hhid==53
	replace areaunit=4   if session==9   & hh==4  & hhid==81
	replace areaunit=4   if session==9   & hh==10 & hhid==86
	replace areaunit=4   if session==10  & hh==3  & hhid==89
	replace areaunit=4   if session==13  & hh==6  & hhid==121
	replace areaunit=4   if session==13  & hh==11 & hhid==126

*no need to change the Areaunit
	replace areaplanted=0.4  if session==5  & hh==5 & hhid==44  & variety=="IR504"
	replace areaplanted=19.5  if session==7  & hh==4 & hhid==60 & variety=="IR504"
	replace areaplanted=0.8  if session==9  & hh==4 & hhid==81  & variety=="IR504"
	replace areaplanted=1.0  if session==13  & hh==2 & hhid==117   & variety=="IR504"
	replace areaplanted=1.0  if session==13  & hh==2 & hhid==117   & variety=="PHKA RUMDOUL"

**recompute Conv_area
	drop conv_area yield
	gen double conv_area=round(areaplanted,0.01)
	replace    conv_area=round(areaplanted*0.4046,0.01) if areaunit==3

	*checker
	edit session hh hhid areaplanted areaunit conv_area if areaunit==3
	
	*generate yield
	gen double yield=round(conv_prod/conv_area/1000,0.01)

	summarize areaplanted conv_area yield if season==1
	summarize areaplanted conv_area yield if season==2
	edit session hh hhid areaplanted areaunit conv_area conv_prod yield if yield>11
	
	*gen per_sold
		drop per_sold
		gen double per_sold=round(conv_sold/conv_prod,0.01)
		drop if per_sold==0
	
	
* **********************************************************************
* 4 -OUTPUTS
*   To Jacob: May I know when is the taghh var necessary? I did not run the 
*             reshape syntax in line 244 and notice running the taghh 
*             would only result to code=1. 
*              
*
* **********************************************************************
*Flagging of values 

	sort hhid

	*by hhid
	egen tagunique = tag(hhid)

		*To know unique number of households 
		tab tagunique if tagunique == 1
		


	*by hhid and variety
	egen tagvar = tag(hhid variety)
	
		*To know unique number of households 
		tab tagunique if tagvar == 1
		
		*To know reasons of selling per household
		tab reason if tagvar== 1 
		
		*tabulation of variety by classif
		tab variety classif if tagvar ==1 
		
		*tabulation of buyers per variety and household
		tab buyers if tagvar ==1 
		
		*Number of buyers per variety and household
		tab2 variety buyers if tagvar==1 
		
		*Percentage of method
		tab method if tagvar ==1 
		
		*Percentage of source_seed
		tab source_seed if tagvar ==1 
		
		*Percentage of seedtype
		tab seedtype if tagvar ==1 
		
	*by hhid season and variety
	egen taghh= tag(hhid season2 variety) 
		
		*Count how many households planted IR504 during Wet Season
		count if season2 == 1 & variety == "IR504" & taghh ==1
		
	
		
		*Count how many households planted IR504 during Dry Season
		count if season2 == 2 & variety == "IR504" & taghh ==1

		*tabulation of variety by season2 per hhid 
			tab variety season2 if taghh == 1
			
		/*recommendation: use tab to check with other categories for efficiency	*/
			
			tab taghh season2 if variety == "IR504" & taghh ==1
			
	
	********************************************************
	* 					Variety Area Share 
	*             (Joint session) for Wet Season  
	********************************************************
	
	*PHKA RUMDOUL
	summarize conv_area conv_prod yield if season2 == 1 & variety == "PHKA RUMDOUL" & taghh ==1
	
	*IR504
	summarize conv_area conv_prod yield if season2 == 1 & variety == "IR504" & taghh ==1
	
	********************************************************
	* 					Variety Area Share 
	*             (Joint session) for Dry Season
	********************************************************
	
	*IR85
	summarize conv_area conv_prod yield if season2 == 2 & variety == "IR85" & taghh ==1
	
	*IR504
	summarize conv_area conv_prod yield if season2 == 2 & variety == "IR504" & taghh ==1
	
	********************************************************
	* 					Selling related 
	*            (Joint session) for Wet Season
	********************************************************
	
	*PHKA RUMDOUL
	summarize price per_sold distance_km if season2 == 1 & variety == "PHKA RUMDOUL" & taghh ==1
	
	*IR504
	summarize price per_sold distance_km if season2 == 1 & variety == "IR504" & taghh ==1
		
	********************************************************
	* 					Selling related 
	*             (Joint session) for Dry Season
	********************************************************
	
	*PHKA RUMDOUL
	summarize  price per_sold distance_km if season2 == 2 & variety == "IR85" & taghh ==1
	
	*IR504
	summarize  price per_sold distance_km if season2 == 2 & variety == "IR504" & taghh ==1


* **********************************************************************
* 5-	CHECKING OF OUTLIERS
* **********************************************************************
*VARIETY: IR504, PHKA RUMDOUL, IR85

*Production
	sort conv_prod
	extremes  conv_prod hhid if variety == "IR504", iqr(1.5)
	extremes  conv_prod hhid if variety == "PHKA RUMDOUL", iqr(1.5)
	extremes  conv_prod hhid if variety == "IR85", iqr(1.5)
	
*Sold
	sort conv_sold
	extremes  conv_sold hhid if variety == "IR504", iqr(1.5)
	extremes  conv_sold hhid if variety == "PHKA RUMDOUL", iqr(1.5)
	extremes  conv_sold hhid if variety == "IR85", iqr(1.5)
	
*Price
	sort price
	extremes price hhid if variety == "IR504", iqr(1.5)
	extremes price hhid if variety == "PHKA RUMDOUL", iqr(1.5)
	extremes price hhid if variety == "IR85", iqr(1.5)
	
	note price: Flag: price possible outlier with a value of 4

*distance_km
	sort distance_km
	extremes distance_km hhid if variety == "IR504", iqr(1.5)
	extremes distance_km hhid if variety == "PHKA RUMDOUL", iqr(1.5)
	extremes distance_km hhid if variety == "IR85", iqr(1.5)
	
	note distance_km: Flag: distance_km possible outlier having a value of 700, 1500

* **********************************************************************
* 6 - OTHER MATTERS
* **********************************************************************
	
* keep what we want, get rid of what we don't
	drop weightunit u checker prod sold_kg season areaplanted taghh tagvar tagunique
	note: prod, Sold_kg, areaplanted  is the same with Conv_prod, Conv_sold and Conv_area respectively
	 
*Arrange all the variables in the data with specific order" 
	order resid session hh hhid classif variety season2 year method source_seed seedtype buyers reason price amt_seed per_sold distance_km areaunit conv_area conv_prod conv_sold yield
	
*labelling variables

	label variable resid "Respondent ID"
	label variable session "Session"
	label variable hh "Household ID per session"
	label variable hhid "Unique Household ID"
	label variable classif "Classification"
	label variable variety "Rice Variety Grown"
	label variable season "Season"
	label variable year "Year Planted"
	label variable areaunit "Area Unit"
	label variable method  "Method of Crop Establishment"
	label variable amt_seed "Amount of seed used per ha (in kg)"
	label variable source_seed "Source of seed"
	label variable seedtype "Seed type"
	label variable conv_prod "Total grain production (in kg)"
	label variable conv_sold "Quantity sold (in kg)"
	label variable per_sold "Proportion of sold in paddy"
	label variable buyer "Buyer/s"
	label variable reason "Reason for choosing the buyer"
	label variable price "Price received in selling of paddy"
	label variable distance_km "Distance from the field to place/point of sale (km)"
	label variable season2 "Season2"
	label variable conv_area "Area Planted (in ha)"
	label variable yield "Yield"
	
* **********************************************************************
* 7 - FINALIZING DATA 
* **********************************************************************

*Identify and report duplicates with  categories*
	sort resid session hh hhid 
	unique resid session hh hhid 
	duplicates report resid session hh hhid 

*Drop duplicate observations to avoid double-counting of varieties planted per household
	duplicates drop resid session hh hhid, force

*Check whether these variables uniquely identify the observations*
	isid				resid session hh hhid 
	
*Describe dataset
	compress
	describe
	summarize 
	
*Sort the data
	sort 				resid session hh hhid
*Saving the dataset	
	save "$export/3b_varplanted_final", replace

*Summary of notes
	notes

/* END */
