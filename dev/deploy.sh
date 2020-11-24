#!/bin/bash
set -e

declare -a projects_list

deploy_log_file=/deploy_out.log
sudo touch "$deploy_log_file"

if [ -z "$INPUT_PROJECTS" ] || [ "$INPUT_PROJECTS" == "*" ]; then
  if [ -z "$INPUT_ARGS" ]; then
    ( cd "$INPUT_WORKING_DIRECTORY" && sudo s deploy "$INPUT_COMMANDS" ) | sudo tee -a "$deploy_log_file"
  else
    ( cd "$INPUT_WORKING_DIRECTORY" && sudo s deploy "$INPUT_COMMANDS" "$INPUT_ARGS" ) | sudo tee -a "$deploy_log_file"
  fi
else
  projects_list=( $INPUT_PROJECTS )
  for project in "${projects_list[@]}"
  do
    if [ -z "$INPUT_ARGS" ]; then
      ( cd "$INPUT_WORKING_DIRECTORY" && sudo s "$project" deploy "$INPUT_COMMANDS" ) | tee -a "$deploy_log_file"
    else
      ( cd "$INPUT_WORKING_DIRECTORY" && sudo s "$project" deploy "$INPUT_COMMANDS" "$INPUT_ARGS" ) | tee -a "$deploy_log_file"
    fi
  done
fi

deploy_logs=$( sudo cat "$deploy_log_file" )
echo "::set-output name=deploy-logs::$(echo $deploy_logs)"