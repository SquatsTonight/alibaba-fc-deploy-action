#!/bin/bash
set -e

declare -a projects_list

deploy_log_file=./deploy_out.log
touch "$deploy_log_file"
:>"$deploy_log_file"

if [ "$INPUT_PROJECTS" == "*" ]; then
  if [ -z "$INPUT_ARGS" ]; then
    (
      cd "$INPUT_WORKING_DIRECTORY"
      echo "Deploying all the projects"
      sudo --preserve-env s deploy "$INPUT_COMMANDS" || { echo "deploy failed"; exit 1; }
    ) | tee -a "$deploy_log_file"
  else
    ( 
      cd "$INPUT_WORKING_DIRECTORY"
      echo "Deploying all the projects"
      sudo --preserve-env s deploy "$INPUT_COMMANDS" "$INPUT_ARGS" || { echo "deploy failed"; exit 1; }
    ) | tee -a "$deploy_log_file"
  fi
else
  projects_list=( $INPUT_PROJECTS )
  for project in "${projects_list[@]}"
  do
    if [ -z "$INPUT_ARGS" ]; then
      (
        cd "$INPUT_WORKING_DIRECTORY"
        echo "Deploying project: $project"
        sudo --preserve-env s "$project" deploy "$INPUT_COMMANDS" || { echo "deploy failed"; exit 1; }
      ) | tee -a "$deploy_log_file"
    else
      (
        cd "$INPUT_WORKING_DIRECTORY"
        echo "Deploying project: $project"
        sudo --preserve-env s "$project" deploy "$INPUT_COMMANDS" "$INPUT_ARGS" || { echo "deploy failed"; exit 1; }
      ) | tee -a "$deploy_log_file"
    fi
    if [ `grep -c "deploy failed" "$deploy_log_file"` -ne 0 ]; then
      exit 1
    fi
  done
fi

if [ `grep -c "deploy failed" "$deploy_log_file"` -ne 0 ]; then
  exit 1
fi

# deploy_logs=$( cat "$deploy_log_file" )
echo "::set-output name=deploy-logs::$(echo $(<$deploy_log_file))"
rm -rf "$deploy_log_file"