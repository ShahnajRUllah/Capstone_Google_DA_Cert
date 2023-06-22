library(rmarkdown)

# Set the path to your Rmd file
rmd_file <- "/cloud/project/fitbit_consumer_usage_data_analysis_v3.Rmd"

# Set the output file name and path for the HTML file
output_file <- "/cloud/project/fitbit_consumer_usage_data_analysis_v3.html"

# Render the Rmd file to HTML
render(rmd_file, output_format = "html_document", output_file = output_file)


