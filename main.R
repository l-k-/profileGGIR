# Notes: Design to also be relevant as a tutorial / test example
# roxygen2::roxygenise()

# TO DO:
# - add results comparison
# - warn user about size of file?
# - document optional pipelines
# - work out plan for storing multiple instances, e.g. 
#   - each version in dated folder?
#   - more info in file name?
#   - create hash and incorporate this in filename?
# 

library(profileGGIR)

# Specify working directory
workdir = "~/projects"

# Install GGIR (user will have to do this as
# they want to be in control of the GGIR version)

# ...

# Define pipeline(s) to run
pipelines = data.frame(what = "readFileOnly", 
                       brand = "Axivity",
                       fileID = 1)

for (i in 1:nrow(pipelines)) {
  # Prepare pipeline
  out = preparePipeline(
    workdir = workdir,
    what = pipelines$what[i],
    brand =  pipelines$brand[i],
    fileID =  pipelines$fileID[i]
  )
  # Run and profile pipeline
  runPipeline(
    workdir = workdir,
    pipelineInfo = pipelines[i,],
    fun2profile = out$fun2profile,
    filename = out$filename,
    verbose = TRUE
  )
  
}

# Run basic check to compare with previous profiling results for the same pipeline
# ...