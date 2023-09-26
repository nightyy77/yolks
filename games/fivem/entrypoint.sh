#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Auto update resources from git.
if [ "${GIT_ENABLED}" == "true" ] || [ "${GIT_ENABLED}" == "1" ]; then

  # Pre git stuff
  echo "Wait, preparing to pull or clone from Git.";

  cd /home/container/resources

  # Git stuff
  if [[ ${GIT_REPOURL} != *.git ]]; then # Add .git at end of URL
      GIT_REPOURL=${GIT_REPOURL}.git
  fi

  if [ -z "${GIT_USERNAME}" ] && [ -z "${GIT_TOKEN}" ]; then # Check for git username & token
    echo -e "Git Username or Git Token was not specified."
  else
    GIT_REPOURL="https://${GIT_USERNAME}:${GIT_TOKEN}@$(echo -e ${GIT_REPOURL} | cut -d/ -f3-)"
  fi

  if [ "$(ls -A /home/container/resources)" ]; then # Files exist in resources folder, pull
    # Get git origin from /home/container/resources/.git/config
    if [ -d .git ]; then
      if [ -f .git/config ]; then
        GIT_ORIGIN=$(git config --get remote.origin.url)
      fi
    fi

    # If git origin matches the repo specified by user then pull
    if [ "${GIT_ORIGIN}" == "${GIT_REPOURL}" ]; then #
      git pull && echo "Finished pulling /resources/* from Git." || echo "Failed pulling /resources/* from Git."
    fi
  else # No files exist in resources folder, clone
    echo -e "Resources directory is empty."
    if [ -z ${GIT_BRANCH} ]; then
      echo -e "Cloning default branch into /resources/*."
      git clone ${GIT_REPOURL} .
    else
      echo -e "Cloning ${GIT_BRANCH} branch into /resources/*."
      git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPOURL} . && echo "Finished cloning into /resources/* from Git." || echo "Failed cloning into /resources/* from Git."
    fi
  fi

  # Post git stuff
  cd /home/container
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
