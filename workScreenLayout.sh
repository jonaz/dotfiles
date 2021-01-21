#!/bin/bash

CURRENT_WORKSPACE=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

PRIMARY=$1
SECONDARY=$2

i3-msg "workspace 1; move workspace to $1"
i3-msg "workspace 2; move workspace to eDP-1"
for i in {3..10}; do
	i3-msg "workspace $i; move workspace to $2"
done

i3-msg "workspace $CURRENT_WORKSPACE"
