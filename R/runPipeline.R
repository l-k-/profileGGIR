#' runPipeline
#'
#' @param workdir path to location where code can store test files and results
#' @param pipelineInfo data.frame with pipeline description
#' @param fun2profile function to profile
#' @param filename character with path to file to test
#' @param verbose verbose
#' @param timetag Boolean to indicate whether timestamp should be added to filenames
#' @return List with filenames of the resultsFile which has the profiling
#' summary, sessionInfo and pipeline info and the profFile the object create by
#' the Rprof itself
#' @export
#' @importFrom utils Rprof sessionInfo summaryRprof

#'
runPipeline = function(workdir = c(), pipelineInfo = c(), fun2profile,
                       filename = c(), verbose = TRUE, timetag = TRUE) {
  
  # Create output filenames
  ST = Sys.time()
  time = format(ST, format = "%y%m%d_%H%M")
  filename_tmp = paste0(workdir, "/profile_", pipelineInfo$what,
                        "_", pipelineInfo$brand, 
                        "FID", pipelineInfo$fileID,
                        "_", pipelineInfo$tag,
                        "_", time)
  profFile = paste0(filename_tmp, ".out")
  resultsFile = paste0(filename_tmp, ".RData")
  
  # Turn profiling on
  Rprof(filename = profFile, memory.profiling = TRUE, gc.profiling = TRUE,
        line.profiling = TRUE)
  
  # Run pipeline
  fun2profile(filename = filename, verbose = TRUE)
  
  # Turn profile off
  Rprof(NULL)
  
  # Store results and pipeline info:
  results = summaryRprof(filename = profFile, memory = "both")
  SI = sessionInfo()

  save(results, SI, pipelineInfo, file = resultsFile)
  invisible(list(resultsFile = resultsFile, profFile = profFile))
}
