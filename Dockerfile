FROM rocker/r-base

RUN apt-get update && apt-get install -y python-pip
RUN pip install boto3
RUN apt-get update && apt-get install -y libcurl4-openssl-dev libgit2-dev libssl-dev libssh2-1-dev

RUN apt-get update && apt-get install -y --allow-downgrades \
    libcurl4=7.64.0-1 libcurl4-openssl-dev libgit2-dev libssl-dev libssh2-1-dev
RUN R -e "install.packages(c('botor', 'slackr'), repos = 'https://cran.rstudio.com/')"
RUN R -e "devtools::install_github('daroczig/binancer', upgrade_dependencies = FALSE)"
