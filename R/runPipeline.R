#' runPipeline
#'
#' @param workdir path to location where code can store test files and results
#' @param pipelineInfo data.frame with pipeline description
#' @param fun2profile function to profile
#' @param filename character with path to file to test
#' @param verbose verbose
#' @return no object is returned
#' @export
#' @importFrom utils Rprof sessionInfo summaryRprof

#'
runPipeline = function(workdir = c(), pipelineInfo = c(), fun2profile,
                       filename = c(), verbose = TRUE) {
  # Turn profiling on
  proffile = paste0(workdir, "/profile_", pipelineInfo$what,
                    "_", pipelineInfo$brand,
                    "_", pipelineInfo$fileID, ".out")
  Rprof(filename = proffile, memory.profiling = TRUE, gc.profiling = TRUE,
        line.profiling = TRUE)
  
  # Run pipeline
  fun2profile(filename = filename, verbose = TRUE)
  
  # Turn profile off
  Rprof(NULL)
  
  # Store results and pipeline info:
  results = summaryRprof(filename = proffile, memory = "both")
  SI = sessionInfo()
  resultsFile = paste0(workdir, "/profile_", pipelineInfo$what,
                       "_", pipelineInfo$brand,
                       "_", pipelineInfo$fileID, ".RData")
  save(results, SI, pipelineInfo, file = resultsFile)
  return()
}
