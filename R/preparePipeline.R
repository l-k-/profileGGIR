#' preparePipeline
#'
#' @param workdir path to location where code can store test files and results
#' @param what character to specify what to profile readfile
#' @param brand character with name of brand: Axivity
#' @param fileID number to indicate which file to read
#' @return no object is returned
#' @export
#' @importFrom utils download.file unzip

#'
preparePipeline = function(workdir = c(), what = "readFileOnly",
                           brand = "AX", fileID = 1) {
  
  # Download file
  if (brand == "AX") {
    if (fileID == 1) {
      # AX3 multi day
      url = "https://www.dropbox.com/s/fntsuth4esye9ke/37727_0000000049_13-03-2022_leftwrist.cwa?raw=1"
      filename = paste0(workdir, "/37727_0000000049_13-03-2022_leftwrist.cwa")
    } else if (fileID == 2) {
      # AX6 multi day
      url = "https://www.dropbox.com/s/q7rqy8l27djr03v/6011834_0000000050_23-03-2023_leftwrist.cwa?raw=2"
      filename = paste0(workdir, "/6011834_0000000050_23-03-2023_leftwrist.cwa")
    } else if (fileID == 3) {
      # UK Biobank example file https://biobank.ctsu.ox.ac.uk/crystal/refer.cgi?id=131620
      url = "biobank.ctsu.ox.ac.uk/ukb/ukb/examples/accsamp.zip"
      filename = paste0(workdir, "/ukbbzip.zip")
    }
  }

  if (length(filename) > 0) {
    if (!file.exists(filename)) {
      download.file(url = url, destfile = filename)
    }
    # Unzip if it is a zip file
    extension = unlist(strsplit(filename, "[.]"))
    extension = extension[length(extension)]
    if (extension == "zip") {
      filename = unzip(zipfile = filename, exdir = workdir)
    }
  } else {
    warning("no file available, check arguments to function preparePipeline")
  }
  
  # Prepare call:
  if (what == "readFile" & brand == "AX") {
    # Only read file in chunks/batches without processing them
    fun2profile = function(filename = c(), verbose = FALSE) {
      k = 1
      previousNR = 0
      if (verbose == TRUE) cat("\nreading block ")
      while (k > 0) {
        if (verbose == TRUE) cat(paste0(k, " "))
        start = ((k - 1) * 28000) + 1
        end = k * 28000
        data = GGIRread::readAxivity(filename = filename, start = start, end = end)
        NR = nrow(data$data)
        if (k > 1) {
          if (NR < previousNR) {
            break()
          }
        }
        previousNR = NR
        rm(data)
        k = k + 1
      }
      if (verbose == TRUE) cat("\n")
      return()
    }
  } else if (what == "GGIRp1" & brand == "AX") {
    # GGIR part 1 with default arguments
    fun2profile = function(filename = c(), verbose = FALSE) {
      GGIR::GGIR(datadir = filename, studyname = "profiling", outputdir = workdir,
                 overwrite = TRUE, verbose = TRUE)
      return()
    }
  }
  invisible(list(filename = filename, fun2profile = fun2profile))
}
