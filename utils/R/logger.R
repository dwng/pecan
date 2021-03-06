#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

.local <- new.env() 
.local$filename <- NA
.local$console  <- TRUE
.local$level    <- 0

##' Prints a debug message.
##' 
##' This function will print a debug message.
##'
##' @param msg the message that should be printed.
##' @param ... any additional text that should be printed.
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.debug("variable", 5)
##' }
logger.debug <- function(msg, ...) {
	logger.message("DEBUG", msg, ...)
}

##' Prints an informational message.
##' 
##' This function will print an informational message.
##'
##' @param msg the message that should be printed.
##' @param ... any additional text that should be printed.
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.info("PEcAn version 1.2")
##' }
logger.info <- function(msg, ...) {
	logger.message("INFO", msg, ...)
}

##' Prints a warning message.
##' 
##' This function will print a warning message.
##'
##' @param msg the message that should be printed.
##' @param ... any additional text that should be printed.
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.warn("detected NA values")
##' }
logger.warn <- function(msg, ...) {
	logger.message("WARN", msg, ...)
}

##' Prints an error message.
##' 
##' This function will print an error message.
##'
##' @param msg the message that should be printed.
##' @param ... any additional text that should be printed.
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.error("system did not converge")
##' }
logger.error <- function(msg, ...) {
	logger.message("ERROR", msg, ...)
}

##' Prints a message at a certain log level.
##' 
##' This function will print a message. This is the function that is responsible for
##' the actual printing of the message.
##'
##' This is a place holder and will be later filled in with a more complex logging set
##' @param level the level of the message (DEBUG, INFO, WARN, ERROR)
##' @param msg the message that should be printed.
##' @param ... any additional text that should be printed.
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.message("DEBUG", "variable", 5)
##' }
logger.message <- function(level, msg, ...) {
	if (logger.getLevelNumber(level) >= .local$level) {
		dump.frames(dumpto="dump.log")
		calls <- names(dump.log)
	    func <- sub("\\(.*\\)", "", tail(calls[-(which(substr(calls, 0, 3) == "log"))], 1))
	    if (length(func) == 0) {
	    	func <- "console"
	    }
		text <- sprintf("%s %-5s [%s] : %s\n", Sys.time(), level, func, paste(msg, ...))
		if (.local$console) {
			cat(text)
		}
		if (!is.na(.local$filename)) {
			cat(text, file=.local$filename, append=TRUE)
		}
	}
}

##' Configure logging level.
##' 
##' This will configure the logger level. This allows to turn DEBUG, INFO,
##' WARN and ERROR messages on and off.
##'
##' @param level the level of the message (ALL, DEBUG, INFO, WARN, ERROR, OFF)
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.setLevel("DEBUG")
##' }
logger.setLevel <- function(level) {
	.local$level = logger.getLevelNumber(level)
}

##' Returns numeric value for string
##'
##' Given the string representation this will return the numeric value
##' ALL   =  0
##' DEBUG = 10
##' INFO  = 20
##' WARN  = 30
##' ERROR = 40
##' ALL   = 99
##'
##' @return level the level of the message
##' @author Rob Kooper
logger.getLevelNumber <- function(level) {
	if (toupper(level) == "ALL") {
		return(0)
	} else if (toupper(level) == "DEBUG") {
		return(10)
	} else if (toupper(level) == "INFO") {
		return(20)
	} else if (toupper(level) == "WARN") {
		return(30)
	} else if (toupper(level) == "ERROR") {
		return(40)
	} else if (toupper(level) == "OFF") {
		return(50)
	} else {
		logger.warn(level, " is not a valid value, setting level to INFO")
		return(logger.getLevelNumber("INFO"))
	}	
}

##' Get configured logging level.
##' 
##' This will return the current level configured of the logging messages
##'
##' @return level the level of the message (ALL, DEBUG, INFO, WARN, ERROR, OFF)
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.getLevel()
##' }
logger.getLevel <- function() {
	if (.local$level < 10) {
		return("ALL")
	} else if (.local$level < 20) {
		return("DEBUG")
	} else if (.local$level < 30) {
		return("INFO")
	} else if (.local$level < 40) {
		return("WARN")
	} else if (.local$level < 50) {
		return("ERROR")
	} else {
		return("OFF")
	}
}

##' Configure logging to console.
##' 
##' Should the logging to be printed to the console or not.
##'
##' @param console set to true to print logging to console.
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.setUseConsole(TRUE)
##' }
logger.setUseConsole <- function(console) {
	.local$console <- console
}

##' Configure logging output filename.
##' 
##' The name of the file where the logging information should be written to.
##'
##' @param filename the file to send the log messages to (or NA to not write to file)
##' @export
##' @author Rob Kooper
##' @examples
##' \dontrun{
##' logger.setOutputFile("pecan.log")
##' }
logger.setOutputFile <- function(filename) {
	.local$filename <- filename
}
