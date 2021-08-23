SwatInitialization=function (dirname="OWASCOIDWalpha", iyr="2010", nbyr=12,
            wsarea=flowgage$area, elev=flowgage$elev,
            declat=flowgage$declat, declon=flowgage$declon, hist_wx) 
{
  swat_general <- NULL
  rm(swat_general)
  load(paste(path.package("SWATmodel"), "data/swat_general.rda", 
             sep = "/"))
  dir.create(dirname)
  setwd(dirname)
  for (file in names(swat_general)) {
    print(file)
    cat(unlist(swat_general[file]), file = file, sep = "\n")
  }
  if (length(hist_wx) > 2) {
    tmp_head = paste("Tmp\nLati Not Used\nLong Not Used\nElev        ", 
                     sprintf("%5.0f\n", elev), sep = "")
    pcp_head = paste("Pcp\nLati Not Used\nLong Not Used\nElev        ", 
                     sprintf("%5.0f\n", elev), sep = "")
    cat(tmp_head, sprintf("%s%005.1f%005.1f\n", format(hist_wx$date, 
                                                       "%Y%j"), hist_wx$MaxTemp, hist_wx$MinTemp), file = "tmp.tmp", 
        sep = "")
    cat(pcp_head, sprintf("%s%005.1f\n", format(hist_wx$date, 
                                                "%Y%j"), hist_wx$P), file = "pcp.pcp", sep = "")
  }
  filecio = readLines("file.cio")
  if (length(hist_wx) > 2) {
    filecio = sub("pcp1\\.pcp", "pcp\\.pcp", filecio)
    filecio = sub("tmp1\\.tmp", "tmp\\.tmp", filecio)
  }
  filecio = sub("\\d\\d\\d\\d(    \\| IYR)", paste(iyr, "\\1", 
                                                   sep = ""), filecio)
  substr = sprintf("      %10d    | NBYR", nbyr)
  filecio = sub("^.*\\| NBYR", substr, filecio, perl = T)
  cat(filecio, file = "file.cio", sep = "\n")
  num_subbasins = length(list.files(pattern = "0*.sub"))
  for (subfilename in list.files(pattern = "0*.sub")) {
    subfile = readLines(subfilename)
    substr = sprintf("%12.1f        | SUB_KM", wsarea/num_subbasins)
    subfile = sub("^.*\\| SUB_KM", substr, subfile, perl = T)
    substr = sprintf("%12.1f        | SUB_LAT", declat)
    subfile = sub("^.*\\| SUB_LAT", substr, subfile, perl = T)
    substr = sprintf("%12.1f        | SUB_ELEV", elev)
    subfile = sub("^.*\\| SUB_ELEV", substr, subfile, perl = T)
    cat(subfile, file = subfilename, sep = "\n")
  }
}