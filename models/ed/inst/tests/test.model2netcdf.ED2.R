require(PEcAn.ED)
extdata.dir <- system.file("extdata", package = "PEcAn.ED")
outdir <- tempdir()
 
system("rm -rf /tmp/out/*")
file.copy(dir(extdata.dir, pattern = ".h5", full.names = TRUE), outdir)

model2netcdf.ED2(outdir)

test_that("a valid .nc file is produced for each corresponding ED2 output", {
  h5files <- dir(outdir, pattern = ".h5")
  ncfiles <- dir(outdir, pattern = ".nc")

  expect_equal(length(h5files), length(ncfiles))
  h5years <- sapply(h5files, function(x) gsub("[A-Za-z.h5-]", "", x))
  ncyears <- sapply(ncfiles, function(x) gsub(".nc", "", x))
  expect_equal(as.numeric(ncyears), as.numeric(h5years))
})

test_that("nc files have correct attributes",{
  ncfiles <- dir(outdir, pattern = ".nc")
  tmp.nc <- open.ncdf(file.path(outdir, ncfiles[1]))
  expect_equal(class(tmp.nc), "ncdf")
  time <- get.var.ncdf(tmp.nc, "time")
  gpp  <- get.var.ncdf(tmp.nc, "GPP")
  
  expect_equal(length(gpp), length(time))
  
})