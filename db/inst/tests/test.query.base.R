#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

test_that("settings variable is passed from db/tests/run.all.R",{
  expect_true(exists("settings"))
  expect_is(settings, "list")
  expect_equal(names(settings), "database")
  expect_equal(names(settings$database), c("userid", "passwd", "location", "name"))
})

test_that("query base can execute a trivial SQL statement and return results",{  
  ans <- query.base("select count(*) from traits;")
  expect_is(ans, "data.frame")
  expect_is(ans[,1], "numeric")
  expect_true(length(ans) == 1)
  
  tables <- query.base('show tables;')
  expect_true(is.data.frame(tables))
  expect_true(is.character(tables[,1]))
  expect_true(ncol(tables) == 1)
})
