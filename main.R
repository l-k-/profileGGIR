# Notes: Design to also be relevant as a tutorial / test example
# roxygen2::roxygenise()

# TO DO:
# - Document optional pipelines in code, functions, and in README
# - Add example of how to run this via system command line in README and in main.R
# - Add pre-processed part 1 output and create pipeline for GGIR 2-5

library(profileGGIR)

# Specify working directory
workdir = "~/projects/profilingResults"

# Install GGIR and dependencies (user will have to do this as
# they want to be in control of this)

# ...

# Define pipeline(s) to run
pipelines = data.frame(what = c("readFile", "GGIRp1"),
                       brand = c("AX", "AX"),
                       fileID = c(3, 3),
                       tag = c("tag1", "tag1"), # tag can be any string
                       resultsFile = c("", ""), # leave empty as this will be overwritten
                       profFile = c("", "")) # leave empty as this will be overwritten

timetag = TRUE # set to FALSE if you do not want a time tage in the filename

for (i in 1:nrow(pipelines)) {
  # Prepare pipeline
  out = preparePipeline(
    workdir = workdir,
    what = pipelines$what[i],
    brand =  pipelines$brand[i],
    fileID =  pipelines$fileID[i]
  )
  # Run and profile pipeline
  proffiles = runPipeline(
    workdir = workdir,
    pipelineInfo = pipelines[i,],
    fun2profile = out$fun2profile,
    filename = out$filename,
    verbose = TRUE,
    timetag = timetag
  )
  pipelines$resultsFile[i] = proffiles$resultsFile
  pipelines$profFile[i] = proffiles$profFile
  
}

# It is now up to user to inspect and compare the files, for example:
library(profvis)
# Inspect profiling info visually
# profvis(prof_input = pipelines$profFile[1]) # run this line manually
# profvis(prof_input = pipelines$profFile[2]) # run this line manually

# Check profiling summery
load(pipelines$resultsFile[1])
print(results)
