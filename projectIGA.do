* Project: Interns 2021
* Created on: July 22, 2021
* Created by: DVillanueva
* Stata v.16.1

*does
	* establishes an identical workspace between users
	* sets globals that define absolute paths
	* serves as the starting point to find any do-file, dataset or output
	* runs all do-files needed for data work. ([!] Eventually)
	* loads any user written packages needed for analysis

* assumes
	* access to all data and code

* TO DO:
	* add all do-files


* **********************************************************************
* 0 - setup
* **********************************************************************

clear all

* set $pack to 0 to skip package installation
	global 			pack			1

* set $adoUpdate to 0 to skip updating ado files
	global			adoUpdate		1
		
* specify Stata version in use
    global			stataVersion	16.0
    version			$stataVersion

* dependencies
	* for packages/commands, make a local containing any required packages
        local userpack "mdesc estout reghdfe ftools distinct winsor2 unique labsumm grouplabs collapseunique"

* **********************************************************************
* 0 (a) - Create user specific paths
* **********************************************************************


* Define root folder globals


* Jhoanne
    if `"`c(username)'"' == "JYnion" {
        global 		code  	"C:\Users\jynion\git\Sample"
		global 		data	"E:\Google Drive\jy_mrt_files\sample_project"
		}
		
* Jacob		
    if `"`c(username)'"' == "me" {
        global 		code  	"C:\Users\me\git\GitHub\INSTATOJT"
		global 		data	"D:\Google Drive\IRRI\OJT Materials\04_syntax (1)"
		}
		
* Bianca	
    if `"`c(username)'"' == "Bianca Guillermo" {
        global 		code  	"C:\Users\Bianca Guillermo\git\INSTATOJT"
		global 		data	"C:\Users\Bianca Guillermo\Google Drive\School\Practicum\OJT Materials\04_syntax (1)"
		}

* **********************************************************************
* 0 (b) - Check if any required packages are installed:
* **********************************************************************

foreach package in `userpack' {
	capture : which `package', all
	if (_rc) {
        capture window stopbox rusure "You are missing some packages." "Do you want to install `package'?"
        if _rc == 0 {
            capture ssc install `package', replace
            if (_rc) {
                window stopbox rusure `"This package is not on SSC. Do you want to proceed without it?"'
            }
        }
        else {
            exit 199
        }
	}
}

* Update all ado files
    if $adoUpdate == 1 {
        adoupdate, update
    }

* Set graph and Stata preferences
    set more off
    set logtype text    // so logs can be opened without Stata


