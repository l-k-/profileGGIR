#' preparePipeline
#'
#' @param workdir path to location where code can store test files and results
#' @param what character to specify what to profile readfile
#' @param brand character with name of brand: Axivity
#' @param fileID number to indicate which file to read
#' @return no object is returned
#' @export
#' @importFrom utils download.file

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
    }
  }
  if (length(filename) > 0) {
    if (!file.exists(filename)) {
      download.file(url = url, destfile = filename)
    }
  } else {
    warning("no file available, check arguments to function preparePipeline")
  }
  
  # Prepare call:
  if (what == "readFile" & brand == "AX") {
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
  }
  invisible(list(filename = filename, fun2profile = fun2profile))
}
