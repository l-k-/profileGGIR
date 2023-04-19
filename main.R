# Notes: Design to also be relevant as a tutorial / test example
# roxygen2::roxygenise()

# TO DO:
# - use UKBB example file for profiling
# - document optional pipelines
# - Add example of how to run this via system command line

library(profileGGIR)

# Specify working directory
workdir = "~/projects"

# Install GGIR and dependencies (user will have to do this as
# they want to be in control of this)

# ...

# Define pipeline(s) to run
pipelines = data.frame(what = "readFile",
                       brand = "AX",
                       fileID = 1,
                       tag = "tag1", # tag can be any string
                       resultsFile = "", # leave empty as this will be overwritten
                       profFile = "") # leave empty as this will be overwritten

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
profvis(prof_input = pipelines$profFile[1]) # run this line manually

# Check profiling summery
load(pipelines$resultsFile[1])
print(results)
